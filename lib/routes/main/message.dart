import 'package:flutter/material.dart';
import 'package:banana/util/User.dart';
import 'package:banana/util/Colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<User> fetchUser(String id) async {
  final response = await http.get(Uri.http('localhost:3000', '/users',{"id":id}));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return User.fromJson(jsonDecode(response.body)[0]);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load user information.');
  }
}

class SingleMessage extends StatefulWidget {
  @override
  _SingleMessageState createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  String id = null;
  @override
  Widget build(BuildContext context) {
    final  Map<String, Object>rcvdData = ModalRoute.of(context).settings.arguments;
    setState(() {
      id=rcvdData["id"].toString();
    });
    return FutureBuilder(future:fetchUser(id),builder: (context,data){
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
                        backgroundImage: NetworkImage(data.data.picture),
                        maxRadius: 20,
                      ),
                      SizedBox(width: 12,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(data.data.name,style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
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
            body: Container()
        );
      }return Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColors().themeColor,
          valueColor: new AlwaysStoppedAnimation<Color>(AppColors().themeColor),
        ),
      );
    });
  }
}
