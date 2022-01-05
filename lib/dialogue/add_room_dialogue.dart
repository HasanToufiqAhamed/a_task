import 'package:a_task/state/chat_list_state.dart';
import 'package:a_task/widget/show_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class addRoomDialogue extends StatelessWidget {
  String uid;
  addRoomDialogue(this.uid);

  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _room = context.watch<ChatListState>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                'Create room',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Room name *',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    labelStyle: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () {
                  if(name.text.isEmpty){
                    showMessage(context, 'Sorry', 'Room name is empty', true);
                  } else {
                    _room.makeRoom(name.text, context, uid);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add room'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
