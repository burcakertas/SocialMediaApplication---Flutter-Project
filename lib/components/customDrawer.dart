import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:banana/util/Colors.dart';
import 'package:banana/util/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as authenticator;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<User_> fetchDrawer(var context) async {
  //first fetch id
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.containsKey("uid@banana")){
    final String  id = prefs.getString("uid@banana").toString();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot snapshot = await users.doc(id).get();
    if(snapshot.exists){
      var returner = User_.fromJson(snapshot.data());
      return returner;
    }
    else{
      //should log out;
    }

  }
  else
    Navigator.popAndPushNamed(context, "/welcome");
}

class customDrawer extends StatefulWidget {
  @override
  _customDrawerState createState() => _customDrawerState();
}
class _customDrawerState extends State<customDrawer> {
  @override
  void initState() {
    super.initState();
  }
  authenticator.FirebaseAuth auth = authenticator.FirebaseAuth.instance;
  signOut() async {
    await auth.signOut().catchError((error){
      print(error.toString());
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("uid@banana")){
      await prefs.remove("uid@banana");
    }
    Navigator.popAndPushNamed(context, "/welcome");
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child:FutureBuilder<User_>(
          future: fetchDrawer(context),
          builder: (context, user) {
            if (user.hasData) {
              return Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(200.0),
                  child: AppBar(
                    leading: new IconButton(
                      icon: new Icon(Icons.arrow_back, color: AppColors().themeColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    backgroundColor: AppColors().themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      title: Row(
                        children: [
                          GestureDetector(
                            child:Image(
                              image:NetworkImage(
                                  "${user.data.picture}"
                              ),
                              height: 80,
                            ),
                            onTap: (){
                              Navigator.pushNamed(context, "/profile");
                            },
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(onPressed: (){},
                                  child: Text(user.data.username.length<20 ? user.data.username : user.data.username.substring(0,20)+'...',
                                  style:TextStyle(
                                    color:AppColors().mostUsedBlack
                                    )
                                  )
                              ),
                              TextButton(onPressed: (){},
                                  child: Text(user.data.name.length<40 ? user.data.name : user.data.name.substring(0,40)+'...',
                                      style:TextStyle(
                                      color:AppColors().mostUsedBlack
                                )
                                  )
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                body:ListView(
// Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ExpansionTile(
                      title: Text('Profile'),
                      children: [
                        ListTile(
                          title:Text("Profile"),
                          onTap: () {
                            Navigator.pushNamed(context, "/profile");
                          },
                        ),
                        ListTile(
                          title:Text("Following"),
                          onTap: () {
                            Navigator.pushNamed(context, "/self_following");
                          },
                        ),ListTile(
                          title:Text("Followers"),
                          onTap: () {
                            Navigator.pushNamed(context, "/self_followers");
                          },
                        )
                      ],
                    ),
                    ListTile(
                      title: Text('Lists'),
                      onTap: () {
// Update the state of the app.
// ...
                      },
                    ),
                    ListTile(
                      title: Text('Topics'),
                      onTap: () {
// Update the state of the app.
// ...
                      },
                    ),
                    ListTile(
                      title: Text('Bookmarks'),
                      onTap: () {
// Update the state of the app.
// ...
                      },
                    ),
                    ListTile(
                      title: Text('Follower Requests'),
                      onTap: () {
// Update the state of the app.
// ...
                      },
                    ),
                    Divider(
                        color:AppColors().mostUsedBlack
                    ),
                    ListTile(
                      title: Text('Settings and Privacy'),
                      onTap: () {
// Update the state of the app.
// ...
                      },
                    ),
                    ListTile(
                      title: Text('Help Center'),
                      onTap: () {
// Update the state of the app.
// ...
                      },
                    ),
                    Divider(
                        color:AppColors().mostUsedBlack
                    ),
                    ListTile(
                      title: Text('Logout'),
                      onTap: () {
                        signOut();

                        //remove from shared preferences
                        //signout

                      },
                    ),
                  ],
                ),
              );
            } else if (user.hasError) {
              return ListTile(
                title: Text('Logout'),
                onTap: () {
                  signOut();

                },
              );
            }

            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ),
    );
  }
}



