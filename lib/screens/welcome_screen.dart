import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
      // upperBound: 100.0, // can't be used when animation uses curve
    );

    animation = ColorTween(begin: Colors.white, end: Colors.blue)
        .animate(animationController);

    // animation = CurvedAnimation(
    //   parent: animationController,
    //   curve: Curves.decelerate,
    //   //curve: Curves.easeIn,
    // );
    //animationController.forward(); // for animation forward 0 to 1;
    animationController.reverse(from: 1.0); // for animation reverse 1 to 0;

    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.dismissed) {
    //     animationController.forward();
    //   } else if (status == AnimationStatus.completed) {
    //     animationController.reverse(from: 1.0);
    //   }
    // });

    animationController.addListener(() {
      setState(() {});
      print(animation.value);
      //print(animationController.value);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    //height: animationController.value, // dynamically increasing the height (Animation)
                    // height: animation.value * 100,
                    height: 60.0,
                  ),
                ),
                Text(
                  'Flash Chat',
                  // '${animationController.value.toInt()}%',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Log In',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
