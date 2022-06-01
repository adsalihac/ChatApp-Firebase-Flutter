import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/chat_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FlashChat());
}


class FlashChat extends StatelessWidget {
  const FlashChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark().copyWith(
      //   textTheme: const TextTheme(
      //     bodyText1: TextStyle(color: Colors.black54),
      //   ),
      // ),
      // home: WelcomeScreen(),
        initialRoute: WelcomeScreen.id ,
        routes: {
          WelcomeScreen.id: (context) =>  const WelcomeScreen(),
          LoginScreen.id: (context) =>  const LoginScreen(),
          RegistrationScreen.id: (context) =>  const RegistrationScreen(),
          ChatScreen.id: (context) =>  const ChatScreen(),
        }
    );
  }
}

