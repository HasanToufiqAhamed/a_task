import 'package:a_task/dialogue/add_room_dialogue.dart';
import 'package:a_task/model/message_room.dart';
import 'package:a_task/pages/chat_page.dart';
import 'package:a_task/state/chat_list_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseAuth? _auth = FirebaseAuth.instance;
  final database = FirebaseDatabase.instance.reference();
  List<MessageRoom> roomList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRooms();
  }

  getRooms(){
    database.child('message_room').onValue.listen((event) {
      roomList=[];
      database.child('message_room').once().then((DataSnapshot snapshot) {
        // print(snapshot.value);

        var keys = snapshot.value.keys;
        var value = snapshot.value;

        for (var key in keys) {
          MessageRoom mr = MessageRoom(
            name: value[key]['name'],
            id: value[key]['id'],
            date: DateTime.parse(value[key]['date']),
          );
          setState(() {
            roomList.add(mr);
          });
          roomList.length;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final _room = context.watch<ChatListState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: roomList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(roomId: roomList[index].id, roomName: roomList[index].name),
                      ),
                    );
                  },
                  title: Text('${roomList[index].name}'),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // _room.getRooms();
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                addRoomDialogue(_auth!.currentUser!.uid),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
