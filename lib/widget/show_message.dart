import 'package:ai_awesome_message/ai_awesome_message.dart';
import 'package:flutter/material.dart';

void showMessage(BuildContext c, String title, String message, bool error) {
  Navigator.push(
    c,
    AwesomeMessageRoute(
      awesomeMessage: AwesomeMessage(
        title: title==''? null : title,
        message: message,
        leftBarIndicatorColor: null,
        duration: Duration(seconds: 2),
        backgroundColor: error? Colors.red : Colors.green,
        // backgroundColor: MyColors.mainColor,
        awesomeMessagePosition: AwesomeMessagePosition.TOP,
        borderRadius: 5,
        margin: EdgeInsets.only(left: 15, right: 15, top: 20),
      ),
    ),
  );
}
