
import 'package:banana/util/Colors.dart';
import 'package:flutter/material.dart';
import 'package:banana/services/Posts.dart';

class Add extends StatefulWidget {
  Add({Key key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final PostService _postService = PostService();
  String text = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Splashing'),
          actions: <Widget>[
            FlatButton(
                textColor: Colors.white,
                onPressed: () async {
                  //parse text and add media
                  var tokenized = text.split(" ");
                  var hashes = [];
                  for(var token in tokenized)
                    if(token.startsWith("#"))
                      hashes.add(token.split("#")[1]);
                  _postService.savePost(text,[],hashes);
                  Navigator.pop(context);
                },
                child: Text('Banana'))
          ],
          backgroundColor: AppColors().themeColor,
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: new Form(child: TextFormField(
              onChanged: (val) {
                setState(() {
                  text = val;
                });
              },
            ))));
  }
}