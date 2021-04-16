import 'dart:convert';
import 'dart:async';
import 'package:banana/components/postCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:banana/util/Colors.dart';
import 'package:banana/components/customDrawer.dart';
import 'package:banana/components/messagesBody.dart';
import 'package:banana/util/Feed.dart';
import 'package:banana/util/Message.dart';

/*
* return SingleChildScrollView(child:
    Column(
      children: [
        for(var item in data.data)UserCards().postCard(item)
      ],)
    );
* */
Widget buildBody(int state,String id,dynamic context){
  if(state==0){
    return FutureBuilder(
      future:fetchFeed(state, id),
      builder:(context,data){
        if(data.hasData){
          return SingleChildScrollView(child:
          Column(
            children: [
              for(var item in data.data)UserCards().postCard(item)
            ],)
          );
        }return Center(
          child: CircularProgressIndicator(
            backgroundColor: AppColors().themeColor,
            valueColor: new AlwaysStoppedAnimation<Color>(AppColors().themeColor),
          ),
        );
      }
    );
  }else if (state==3){
    return FutureBuilder(
      future:fetchMessages(state, id),
      builder:(context,data){
        if(data.hasData){
          return messages(data.data);
        }return Center(
          child: CircularProgressIndicator(
            backgroundColor: AppColors().themeColor,
            valueColor: new AlwaysStoppedAnimation<Color>(AppColors().themeColor),
          ),
        );
      }
    );
  }else{
    print(state);
    return Text("Something is wrong...");
  }
}
Future<List<Feed>> fetchFeed(int state,String id) async{
  List<Feed> feeds = [];
  if(state==0){
    final response = await http.get(Uri.http('localhost:3000', '/feeds',{"_start":id,"_end":(int.parse(id)+1).toString()}));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      feeds = List<Feed>.from(jsonDecode(response.body)[0].map((model)=> Feed.fromJson(model)));
      return feeds;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load feed information.');
    }
  }else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load feed information.');
    }
}
Future<List<ChatUsers>> fetchMessages(int state,String id) async{
  List<ChatUsers> msg = [];
  final response = await http.get(Uri.http('localhost:3000', '/messages',{"_start":id,"_end":(int.parse(id)+1).toString()}));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var decoded = jsonDecode(response.body)[0];
    print(decoded);
    for(var item in decoded){
      msg.add(ChatUsers(id:item["id"].toString(),text: item["text"], messageText: item["messageText"], image: item["p_pic"]));
    }
    return msg;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load feed information.');
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  List<String> CurrentTitle = ["Home","Search","Notifications","Messages"];
  List<IconData> IconsList = [Icons.home_filled,Icons.search,Icons.notifications,Icons.message];
  List<IconData> FABIcons = [Icons.keyboard,Icons.keyboard,null,Icons.mail];
  int currentState = 0;
  String id = null;

  void onTabTapped(int index) {
    setState(() {
      currentState = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final  Map<String, Object>rcvdData = ModalRoute.of(context).settings.arguments;
    setState(() {
      id=rcvdData["id"].toString();
    });
    return WillPopScope(
      onWillPop: () async => false,
      child:Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(color: AppColors().themeColor),
            title: Center(
              child: Row(
                children: [
                  Icon(IconsList[currentState],size:35.0,color:AppColors().batmanGrey),
                  SizedBox(width: 10.0,),
                  Text(CurrentTitle[currentState],style:TextStyle(color:AppColors().batmanGrey)),
                ],
              ),
            ),
            backgroundColor: AppColors().innerButtonWhite,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentState,
            onTap: onTabTapped,
            fixedColor: AppColors().themeColor,
            items:<BottomNavigationBarItem> [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notification',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Messages',
              ),
            ],
          ),
          body:buildBody(currentState,id,context),
          floatingActionButton: currentState!=2?Container(
              height: 70.0,
              width: 70.0,
              child: FloatingActionButton(
                onPressed:(){},
                child: Icon(FABIcons[currentState],color: AppColors().mostUsedBlack,size: 55.0,),
                backgroundColor: AppColors().themeColor,
              )
          ):null,
          endDrawer: customDrawer(id)
      )
    );
  }
}

