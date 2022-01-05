import 'package:a_task/model/message_room.dart';
import 'package:a_task/widget/show_message.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatListState with ChangeNotifier {
  final database = FirebaseDatabase.instance.reference();
  List<MessageRoom> roomList = [];

  makeRoom(String roomName, BuildContext c, String uid) async {
    try {
      String key = database.child('message_room').push().key;
      await database.child('message_room').child(key).set({
        'name': roomName,
        'id': key,
        'date': DateTime.now().toString(),
      }).whenComplete(() async {
        await database.child('message_room_member').child(key).set({
          uid: uid,
        });
      });
    } catch (e) {
      showMessage(c, 'Error', '$e', true);
      print(e);
    }
  }
}
