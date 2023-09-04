import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostService {
  Future savePost(text,media,hashes) async{
    var uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection("users").doc(uid).collection("posts").add({
      'text':text,
      'media':media,
      'creator':FirebaseAuth.instance.currentUser.uid,
      'timestamp':FieldValue.serverTimestamp(),
      'hashes':hashes,
    });
  }
}