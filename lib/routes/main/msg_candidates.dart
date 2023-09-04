import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:banana/util/Colors.dart';
import 'package:banana/util/User.dart';
import 'package:banana/components/postCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<List<User_>> fetchUsers()  async{

  List<User_> lister = [];
  User user = FirebaseAuth.instance.currentUser;
  Map<String,bool> observed={};
  var followings_id = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("followings").get();
  for(var user_id in followings_id.docs){
    var users = await FirebaseFirestore.instance.collection('users').doc(user_id.id).get();
    lister.add(User_(id:user_id.id,username:users.data()["username"],name:users.data()["name"],picture: users.data()["picUrl"]));
    observed.putIfAbsent(users.data()["username"], () => true);
  }
  var followers_id = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("followers").get();
  for(var user_id in followers_id.docs){
    var users = await FirebaseFirestore.instance.collection('users').doc(user_id.id).get();
    if(!observed.containsKey(users.data()["username"]))
    lister.add(User_(id:user_id.id,username:users.data()["username"],name:users.data()["name"],picture: users.data()["picUrl"]));
  }
  return lister;
}

class MsgCandidate extends StatefulWidget {

  @override
  _MsgCandidate createState() => _MsgCandidate();
}

class _MsgCandidate extends State<MsgCandidate> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:fetchUsers(),
        builder: (context,users){
          if(users.hasData){
            return Scaffold(
                appBar: AppBar(
                  leading: new IconButton(
                    icon: new Icon(Icons.arrow_back, color: AppColors().mostUsedBlack),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  bottom: PreferredSize(
                      child: Container(
                        color: AppColors().mostUsedBlack,
                        height: 1.0,
                      ),
                      preferredSize: Size.fromHeight(4.0)),
                  iconTheme: IconThemeData(
                    color: AppColors().mostUsedBlack,
                  ),
                  title: Text("Select an account",
                    style: TextStyle(
                      color: AppColors().mostUsedBlack,
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: AppColors().innerButtonWhite,

                ),
                body:SingleChildScrollView(child: Column(
                  children: [
                    for(int i=0;i<users.data.length;i++)
                      UserCards().MsgCan(context,users.data[i])
                  ],
                ),)
            );
          }return Container();
        });
  }
}
