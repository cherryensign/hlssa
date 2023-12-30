import 'package:HLSA/screens/homepage.dart';
import 'package:HLSA/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key, this.supabaseToken});
  final String? supabaseToken;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => widget.supabaseToken != null
                ? HomePage()
                : LoginScreen()), // Replace HomeScreen with your actual main screen widget
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Hero(
                  tag: "logo",
                  child: Image.asset("assets/images/HLSLogo.png")))),
    );
  }
}
