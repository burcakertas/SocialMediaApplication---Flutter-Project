import 'package:banana/util/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:banana/util/Colors.dart';

Future<ChatUsersDetailed> fetchMessages(String id) async {
  //get current user
  var uid = FirebaseAuth.instance.currentUser.uid;
  var usrInfo = await FirebaseFirestore.instance.collection("users").doc(id).get();
  //connect to realtime db
  DatabaseReference dbRefs = FirebaseDatabase.instance.reference();
  var tempMsg;
  List<int>turner = [];
  if(id.compareTo(uid)==0 || id.compareTo(uid)==1)
    tempMsg =  dbRefs.child("chtBtwn").child(uid+id).limitToLast(100);
  else
    tempMsg =  dbRefs.child("chtBtwn").child(id+uid).limitToLast(100);
  ChatUsersDetailed currentChat = new ChatUsersDetailed(id: id, chtname: usrInfo.data()["name"],image: usrInfo.data()["picUrl"], conversations: []);
  //parse conversation
  List<String> conversations_ = [];
  await tempMsg.once().then((DataSnapshot snapshot){
    try{
      Map<dynamic, dynamic> mapped = snapshot.value;
      var obj = mapped.values.toList();
      obj.sort((b,a) => b["timestamp"].compareTo(a["timestamp"]));
      for(var val in obj){
        conversations_.add(val["text"]);
        turner.add(val["sender"]==uid ? 1 : 0);
      }
    }catch(e){
      print("No elements to add");
    }

  });
  currentChat.conversations = List.from(conversations_.reversed);
  currentChat.turn = List.from(turner.reversed);
  return currentChat;
}

Future<void> sendMessage(String id,String text) async{
  //check for text limit
  var uid = FirebaseAuth.instance.currentUser.uid;
  DatabaseReference dbRefs = FirebaseDatabase.instance.reference();
  var ifUserChats = await FirebaseFirestore.instance.collection("users").doc(uid).collection("chtWith").doc(id).get();
  if(!ifUserChats.exists){
    await FirebaseFirestore.instance.collection("users").doc(uid).collection("chtWith").doc(id).set({});
  }
  ifUserChats = await FirebaseFirestore.instance.collection("users").doc(id).collection("chtWith").doc(uid).get();
  if(!ifUserChats.exists){
    await FirebaseFirestore.instance.collection("users").doc(id).collection("chtWith").doc(uid).set({});
  }
  if(id.compareTo(uid)==0 || id.compareTo(uid)==1)
    dbRefs.child("chtBtwn").child(uid+id).push().set({
      "sender":uid,
      "timestamp":ServerValue.timestamp,
      "text":text
  });
  else
    dbRefs.child("chtBtwn").child(id+uid).push().set({
      "sender":uid,
      "timestamp":ServerValue.timestamp,
      "text":text
    });
}

class SingleMessage extends StatefulWidget {
  @override
  _SingleMessageState createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  String id = null;
  final TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final  Map<String, Object>rcvdData = ModalRoute.of(context).settings.arguments;
    setState(() {
      id=rcvdData["id"].toString();
    });
    return FutureBuilder(future:fetchMessages(id),builder: (context,data){
      if(data.hasData){
        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              flexibleSpace: SafeArea(
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: (){
                            Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back,color: Colors.black,),
                      ),
                      SizedBox(width: 2,),
                      CircleAvatar(
                        backgroundImage: NetworkImage(data.data.image),
                        maxRadius: 20,
                      ),
                      SizedBox(width: 12,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(data.data.chtname,style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                            SizedBox(height: 6,),
                            Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                          ],
                        ),
                      ),
                      //Icon(Icons.settings,color: Colors.black54,),
                      GestureDetector(
                        onTap: () {  Navigator.pushNamed(context, "/message_",arguments: {"id":id});},
                        child: CircleAvatar(
                          backgroundImage: NetworkImage("https://cdn0.iconfinder.com/data/icons/kameleon-free-pack-rounded/110/Settings-2-512.png"),
                          maxRadius: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: data.data.conversations.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10,bottom: 10),
                    physics: PageScrollPhysics(),
                    reverse: true,
                    itemBuilder: (context, index){
                      return Container(
                        padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                        child: Align(
                          alignment: (data.data.turn[index]==0?Alignment.topLeft:Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (data.data.turn[index]!=0?Colors.grey.shade200:Colors.blue[200]),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(data.data.conversations[index], style: TextStyle(fontSize: 15),),
                          ),
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                  hintText: "Write message...",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          FloatingActionButton(
                            onPressed: (){
                              //validate string
                              sendMessage(id, _controller.text);
                              _controller.clear();
                              setState(() {

                              });
                              //refresh
                            },
                            child: Icon(Icons.send,color: Colors.white,size: 18,),
                            backgroundColor: Colors.blue,
                            elevation: 0,
                          ),
                        ],

                      ),
                    ),
                  ),
                  Container(child: SizedBox(height:10,),color: Colors.white,)
                ],
              ),
            ),
        );
      }

      return Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColors().themeColor,
          valueColor: new AlwaysStoppedAnimation<Color>(AppColors().themeColor),
        ),
      );

    });
  }
}
