import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:banana/util/Colors.dart';
import 'package:banana/util/User.dart';
import 'package:banana/util/Feed.dart';
import 'package:banana/components/postCard.dart';


Future<User_> fetchUser() async {
  var uid = FirebaseAuth.instance.currentUser.uid;
  var usrInfo = await FirebaseFirestore.instance.collection("users").doc(uid).get();
  var followers = await FirebaseFirestore.instance.collection("users").doc(uid).collection("followers").get();
  var followings = await FirebaseFirestore.instance.collection("users").doc(uid).collection("followings").get();
  User_ current = new User_(
      name:usrInfo.data()["name"],
      username:usrInfo.data()["username"],
      picture:usrInfo.data()["picUrl"],
      followers: followers.docs.length,
      followings: followings.docs.length
      );

  return current;
}
Future<List<Feed>> buildContext(int currentState) async {
  //get user
  List<Feed> lister = [];
  var uid = FirebaseAuth.instance.currentUser.uid;
  var posts = await FirebaseFirestore.instance.collection("users").
              doc(uid).collection("posts").orderBy("timestamp",descending: true).get();//.orderBy("timestamp")
  for(var post in posts.docs){
    //get user info if not self
    var bananaOwnerInfo;
    if(post.data()["creator"]!=uid){
      bananaOwnerInfo = await FirebaseFirestore.instance.collection("users").doc(post.data()["creator"]).get();
      lister.add(
          Feed(
              id: bananaOwnerInfo.id,
              name:  bananaOwnerInfo.data()["name"],
              username: bananaOwnerInfo.data()["username"],
              content: post.data()["text"],
              picture:bananaOwnerInfo.data()["picUrl"],
              media: ""
          )
      );
    }
    else{
      bananaOwnerInfo = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      lister.add(
          Feed(
              id:uid,
              name: bananaOwnerInfo.data()["name"],
              username: bananaOwnerInfo.data()["username"],
              content: post.data()["text"],
              picture: bananaOwnerInfo.data()["picUrl"],
              media: ""
          )
      );
    }
  }
  return lister;
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int currentShow;
@override
  void initState() {
    currentShow=1;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:fetchUser(),
      builder:(context,user){
        if(user.hasData){
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(200.0),
              child: AppBar(
                actions: [
                  new IconButton(
                    icon: new Icon(Icons.settings, color: AppColors().mostUsedBlack),
                    onPressed: () => Navigator.pushNamed(context, "/change_profile")
            ),
                ],
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back, color: AppColors().mostUsedBlack),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                backgroundColor: AppColors().themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.all(8),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child:Image(
                          image:NetworkImage(
                            "${user.data.picture}",
                          ),
                          height: 80,
                        ),
                        //onTap: (){
                        //Navigator.pushNamed(context, "/profile",arguments:{'id':id});
                        //},
                      ),
                      Text(user.data.username,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: AppColors().mostUsedBlack
                          )
                      ),
                      Text(user.data.name,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: AppColors().mostUsedBlack
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: (){Navigator.pushNamed(context, "/self_following");},
                            child: Text("Following ${user.data.followings}",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: AppColors().mostUsedBlack
                                )
                            ),
                          ),TextButton(
                            onPressed: (){Navigator.pushNamed(context, "/self_followers");},
                            child: Text("Followers ${user.data.followers}",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: AppColors().mostUsedBlack
                                )
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(child: Text("Bananas and Peels",style: TextStyle(color:AppColors().batmanGrey,decoration: currentShow==1?TextDecoration.underline:null),),onPressed: (){setState(() {
                          currentShow=1;
                        });}),
                        TextButton(child: Text("Media",style: TextStyle(color:AppColors().batmanGrey,decoration: currentShow==2?TextDecoration.underline:null)),onPressed: (){setState(() {
                          currentShow=2;
                        });}),
                        TextButton(child: Text("Locations",style: TextStyle(color:AppColors().batmanGrey,decoration: currentShow==3?TextDecoration.underline:null)),onPressed: (){setState(() {
                          currentShow=3;
                        });}),
                      ],
                    ),
                    Divider(color: AppColors().batmanGrey,),
                    FutureBuilder(future:buildContext(currentShow),builder: (context,data){
                     if(data.hasData){
                       if(currentShow==1){
                         return Column(
                           children: [ for(var item in data.data ) UserCards().postCard(item)
                           ],
                         );
                       }else if(currentShow==2){
                         return Column(
                           children: [ for(var item in data.data ) UserCards().postCard(item)
                           ],
                         );
                       }
                     }return Container(child:Center(child: Text("No data exists")));
                    }),
                  ],
                ),
              ),
            ),
            floatingActionButton: Container(
              height: 70.0,
              width: 70.0,
              child: FloatingActionButton(
                onPressed:(){},
                child: Icon(Icons.keyboard,color: AppColors().mostUsedBlack,size: 55.0,),
                backgroundColor: AppColors().themeColor,
              ),
            ),
          );
      }
        else{
          return Scaffold(body:Center(child:CircularProgressIndicator()));
        }
    }
    );

  }
}
