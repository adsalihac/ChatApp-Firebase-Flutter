import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../screens/registration_screen.dart';
import '../screens/login_screen.dart';

import '../components/roundedButton.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static const String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
      // upperBound: 100.0
    );

    // easeIn , bounce .etc
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
      // reverseCurve: Curves.easeOut,
    );

    //Color Transition
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(animationController);

    animationController.forward();

    // Continous Animation
    // animation.addStatusListener((status) {
    //   if (kDebugMode) {
    //     print('status $status');
    //   }
    //   if(status == AnimationStatus.completed) {
    //     animationController.reverse(from: 1.0);
    //   } else if(status == AnimationStatus.dismissed) {
    //     animationController.forward();
    //   }
    // });


    animationController.addListener(() {
      setState(() {});
      if (kDebugMode) {
        print(animationController.value);
        print(animation.value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red.withOpacity(animationController.value),
      // backgroundColor: Colors.white,
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 60.0,
                    // height: animation.value,
                    // height: animation.value *100,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: const TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
               name: "Login",
               color: Colors.lightBlueAccent,
               onPressed :() {
                 Navigator.pushNamed(context, LoginScreen.id);
                 //Go to login screen.
               },
             ),
            RoundedButton(
              name: "Register",
              color:  Colors.blueAccent,
              onPressed :() {
                Navigator.pushNamed(context, RegistrationScreen.id);
                //Go to login screen.
              },
            ),
          ],
        ),
      ),
    );
  }
}
