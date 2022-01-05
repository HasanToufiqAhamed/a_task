import 'package:a_task/pages/home_page.dart';
import 'package:a_task/pages/sign_in_page.dart';
import 'package:a_task/state/chat_list_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatListState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyInitPage(),
    );
  }
}

class MyInitPage extends StatefulWidget {
  MyInitPage();

  @override
  State<MyInitPage> createState() => _MyInitPageState();
}

class _MyInitPageState extends State<MyInitPage> {
  FirebaseAuth? _auth = FirebaseAuth.instance;
  bool showSignIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSignIn();
  }

  checkSignIn() async {
    await Future.delayed(Duration(seconds: 1));
    if (_auth!.currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      setState(() {
        showSignIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('widget.title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            showSignIn
                ? TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              },
              child: Text('Sign In'),
            )
                : Text('Welcome'),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}