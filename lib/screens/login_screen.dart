import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../components/roundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/chat_screen.dart';
import '../screens/registration_screen.dart';

import '../constants.dart';


import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = FirebaseAuth.instance;
  late String email = "abc@gmail.com";
  late String password = "123123";
  bool showLoading = false;


  Future<void> loginSubmit() async {
    if(email.isEmpty || password.isEmpty) {
      snakeBarMsg('Enter username and password');
    } else {
      try {
        setState(() {
          showLoading = true;
        });
        final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password
        );
        if(user != null) {
          Navigator.pushNamed(context, ChatScreen.id);
        }
        setState(() {
          showLoading = false;
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          showLoading = false;
        });
        if (e.code == 'user-not-found') {
          snakeBarMsg('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          snakeBarMsg('Wrong password provided for that user.');
        } else {
          snakeBarMsg('The account is not exist. create Account');
          Navigator.pushNamed(context, RegistrationScreen.id);
        }
      }
    }

    if (kDebugMode) {
      print('Email $email Password $password');
    }
  }

  void snakeBarMsg(message){
    final snackBar = SnackBar(
      content:  Text(message),
      // backgroundColor: (Colors.black12),
      action: SnackBarAction(
        label: 'dismiss',
        onPressed: () {
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                  kInputDecoration.copyWith(hintText: 'Enter your email')),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                textAlign: TextAlign.center,
                obscureText: true,
                obscuringCharacter: '*',
                onChanged: (value) {
                  password = value;
                },
                decoration:
                kInputDecoration.copyWith(hintText: 'Enter your password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                name: "Log In",
                color: Colors.lightBlueAccent,
                onPressed: () {
                  loginSubmit();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
