import 'package:flutter/cupertino.dart';

class ChatUsers{
  String id;
  String text;
  String messageText;
  String image;
  ChatUsers({@required this.id,@required this.text,@required this.messageText,@required this.image});
}

class ChatUsersDetailed{
  String id;
  String chtname;
  String image;
  List<String> conversations;
  List<int> turn;
  ChatUsersDetailed({@required this.id,@required this.chtname,@required this.image,@required this.conversations,this.turn});
}