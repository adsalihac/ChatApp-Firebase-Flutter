import 'package:chatapp/screens/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const String id = 'chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {

  final _auth = FirebaseAuth.instance;
  late User loggedInUser;


  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if(user != null) {
        loggedInUser = user;
      }
    } on FirebaseAuthException catch (e) {
      // if (e.code == 'weak-password') {
      //   snakeBarMsg('The password provided is too weak.');
      // } else if (e.code == 'email-already-in-use') {
      //   snakeBarMsg('The account already exists for that email.');
      // }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
    Navigator.pushNamed(context, LoginScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                logOut();
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
