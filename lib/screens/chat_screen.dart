import 'package:chatapp/screens/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
final Stream<QuerySnapshot> _chatStream = FirebaseFirestore.instance.collection('messages').snapshots();
late User loggedInUser;


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const String id = 'chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();

  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // messageStream();
  }

  Future<void> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
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

  void sendMessage() {
    // print('message $messageText');
    // print('email id ');
    // Create a new user with a first and last name
    final messageData = <String, dynamic>{
      "text": messageText,
      "sender": loggedInUser.email,
    };

    // Add a new document with a generated ID
    _firestore.collection("messages").add(messageData).then(
        (DocumentReference doc) =>
            {
              print('DocumentSnapshot added with ID: ${doc.id}'),
            messageTextController.clear(),
            });
  }

  Future<void> logOut() async {
    await _auth.signOut();
    Navigator.pushNamed(context, LoginScreen.id);
  }

  // Future<void> getMessages() async {
  //   await _firestore.collection("messages").get().then((event) {
  //     for (var doc in event.docs) {
  //       if (kDebugMode) {
  //         print("${doc.id} => ${doc.data()}");
  //       }
  //     }
  //   });
  // }

  Future<void> messageStream() async {
    await for (var snapshot in _firestore.collection("messages").snapshots()) {
      for (var doc in snapshot.docs) {
        if (kDebugMode) {
          print("${doc.id} => ${doc.data()}");
        }
      }
    }
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
                // getMessages();
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
            const MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      sendMessage();
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


class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
      stream: _chatStream,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 20.0),
            shrinkWrap: true,
            children:
            snapshot.data!.docs.reversed.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data()! as Map<String, dynamic>;
              // return ListTile(
              //   title: Text(data['text']),
              //   subtitle: Text(data['sender']),
              // );

              final currentUser = loggedInUser.email;
              if (kDebugMode) {
                print(currentUser);
              }

              return
                MessageBubble(
                  messageText: data['text'],
                  messageSender: data['sender'],
                  isMe: currentUser == data['sender'],
                );
            }).toList(),
          ),
        );

      },
      // return const Text("f");
    );
  }
}



class MessageBubble extends StatelessWidget {

  final String messageText;
  final String messageSender;
  final bool isMe;

  MessageBubble({required this.messageText, required this.messageSender , required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(messageSender,
      style: const TextStyle(
        fontSize: 12.0,
        color: Colors.black54
      ),
      ),
          Material(
            elevation: 5.0,
            borderRadius:  BorderRadius.only(
              topLeft: isMe ? const Radius.circular(30.0) : const Radius.circular(0.0),
              topRight:isMe ? const Radius.circular(0.0) : const Radius.circular(30.0),
              bottomLeft: const Radius.circular(30.0),
              bottomRight: const Radius.circular(30.0),
            ),
            color: isMe ? Colors.lightBlueAccent :  Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0 , horizontal: 20.0),
              child: Text(messageText,
                style:  TextStyle(
                    fontSize: 15.0,
                    color: isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
