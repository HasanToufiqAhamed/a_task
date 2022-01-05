import 'package:a_task/widget/show_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FirebaseAuth? _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 25,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email *',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  labelStyle: TextStyle(color: Colors.black54),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password *',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  labelStyle: TextStyle(color: Colors.black54),
                ),
              ),
              SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  signIn(email.text, password.text);
                },
                child: Text('Sign In'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  signUp(email.text, password.text);
                },
                child: Text('Sign Up'),
              ),
              SizedBox(height: 20),
              const Text(
                  'If you did not have account, simply fill up the\nform and press Sign Up.\nDo not need retype password', textAlign: TextAlign.center,),
              Text('Sorry for the ui',style: TextStyle(color: Colors.black.withOpacity(0.3)),)
            ],
          ),
        ),
      ),
    );
  }

  void signIn(String em, String pass) async {
    if (em.isEmpty) {
      showMessage(context, 'Sorry', 'Email empty', true);
    } else if (pass.isEmpty) {
      showMessage(context, 'Sorry', 'Password empty', true);
    } else {
      print('fdfd');
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: em, password: pass)
            .then((value) {
          if (_auth!.currentUser != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          }
        });
      } on FirebaseAuthException catch (e) {
        showMessage(context, 'Sorry', e.message!, true);
      }
    }
  }

  void signUp(String em, String pass) async {
    if (em.isEmpty) {
      showMessage(context, 'Sorry', 'Email empty', true);
    } else if (pass.isEmpty) {
      showMessage(context, 'Sorry', 'Password empty', true);
    } else {
      print('fdfd');
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: em, password: pass)
            .then((value) {
          if (_auth!.currentUser != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          }
        });
      } on FirebaseAuthException catch (e) {
        showMessage(context, 'Sorry', e.message!, true);
      }
    }
  }
}
