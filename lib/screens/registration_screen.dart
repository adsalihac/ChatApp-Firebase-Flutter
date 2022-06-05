import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../components/roundedButton.dart';
import '../constants.dart';

import '../screens/chat_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;
  late String email = "";
  late String password = "";
  bool showLoading = false;

  Future<void> registerSubmit() async {
    if(email.isEmpty || password.isEmpty) {
      snakeBarMsg('Enter username and password');
    } else {
      setState(() {
        showLoading = true;
      });
      try {
        final newUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if(newUser != null) {
          Navigator.pushNamed(context, ChatScreen.id);
        }
        setState(() {
          showLoading = false;
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          showLoading = false;
        });
        if (e.code == 'weak-password') {
          snakeBarMsg('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          snakeBarMsg('The account already exists for that email.');
        } else {
          snakeBarMsg('Enter details is wrong');
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);

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
                name: "Register",
                color: Colors.blueAccent,
                onPressed: () {

                  registerSubmit();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
