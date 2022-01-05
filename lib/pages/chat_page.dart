import 'package:a_task/model/chat.dart';
import 'package:a_task/widget/show_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  String roomId, roomName;

  ChatPage({
    required this.roomId,
    required this.roomName,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirebaseAuth? _auth = FirebaseAuth.instance;
  final database = FirebaseDatabase.instance.reference();
  List<Chat> chatList = [];
  TextEditingController message = TextEditingController();
  bool maxUser = false;
  bool allowPermission = false;
  bool readAllData = false;
  int a=0;
  int member=0;

  @override
  void initState() {
    super.initState();
    getChat();
    checkUsers();
  }

  checkUsers() {
    database
        .child('message_room_member/${widget.roomId}')
        .once()
        .then((DataSnapshot snapshot) async {

      var keys = snapshot.value.keys;
      var value = snapshot.value;

      setState(() {
        member=snapshot.value.length;
      });

      for (var key in keys) {
        if (_auth!.currentUser!.uid == value[key]) {
          setState(() {
            allowPermission = true;
            readAllData = true;
          });
        }
      }

      if (!allowPermission) {
        if (snapshot.value.length < 10) {
          await database
              .child(
                  'message_room_member/${widget.roomId}/${_auth!.currentUser!.uid}')
              .set(_auth!.currentUser!.uid)
              .whenComplete(() {
            setState(() {
              allowPermission = true;
            });
          });
        } else {
          print('max 10 user');
          setState(() {
            allowPermission = false;
          });
        }
        setState(() {
          readAllData = true;
        });
      }
    });
  }

  getChat() {
    database.child('room_chat/${widget.roomId}').onValue.listen((event) {
      chatList = [];
      database
          .child('room_chat/${widget.roomId}')
          .once()
          .then((DataSnapshot snapshot) {
        // print(snapshot.value);

        var keys = snapshot.value.keys;
        var value = snapshot.value;

        for (var key in keys) {
          Chat chat = Chat(
            message: value[key]['message'],
            uId: value[key]['uId'],
            date: DateTime.parse(value[key]['date']),
          );
          setState(() {
            chatList.add(chat);
          });
        }
        if(a!=0){
          showMessage(context, 'Alert', 'Some one send message in this group', false);
        }
        a++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName),
        actions: [
          Container(child: Text('$member members'), alignment: Alignment.center, padding: EdgeInsets.all(15),)
        ],
      ),
      body: readAllData == false
          ? Center(
            child: CircularProgressIndicator(),
          )
          : !allowPermission
              ? Center(
                child: Container(
                  color: Colors.red,
                  padding: EdgeInsets.all(30),
                  child: Text(
                    'Max 10 users allow!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              )
              : Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: SingleChildScrollView(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: chatList.length,
                              reverse: false,
                              itemBuilder: (context, index) {
                                return chatListLayout(
                                    chatList[index].message,
                                    _auth!.currentUser!.uid,
                                    chatList[index].uId);
                              }),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: message,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Type message',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2.0),
                                ),
                                labelStyle: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                if (message.text.isEmpty) {
                                  showMessage(context, 'Sorry',
                                      'Plese type your message', true);
                                } else {
                                  try {
                                    String key = database
                                        .child('room_chat/${widget.roomId}')
                                        .push()
                                        .key;
                                    await database
                                        .child('room_chat/${widget.roomId}')
                                        .push()
                                        .set(Chat(
                                                message: message.text,
                                                uId: _auth!.currentUser!.uid,
                                                date: DateTime.now())
                                            .toJson())
                                        .whenComplete(() {
                                      // FocusScope.of(context).unfocus();
                                      message.clear();
                                    });
                                  } catch (e) {
                                    showMessage(context, 'Error', '$e', true);
                                    print(e);
                                  }
                                }
                              },
                              icon: Icon(Icons.send))
                        ],
                      ),
                    )
                  ],
                ),
    );
  }

  Widget chatListLayout(String message, String myUid, String uId) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          uId == myUid ? Spacer() : SizedBox(),
          Flexible(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft:
                      uId == myUid ? Radius.circular(12) : Radius.circular(0),
                  topRight: Radius.circular(12),
                  bottomRight:
                      uId == myUid ? Radius.circular(0) : Radius.circular(12),
                ),
                color: Colors.black12,
              ),
              child: Text(
                message,
              ),
            ),
          ),
          uId == myUid ? SizedBox() : Spacer(),
        ],
      ),
    );
  }
}
