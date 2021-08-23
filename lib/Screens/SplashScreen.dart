import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:world/Screens/HomeScreen.dart';

class SplashScreen extends StatefulWidget{
  @override
  _SplashScreen createState()=> _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>{
  @override
  void initState(){
    super.initState();
    Timer(
        Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomeScreen()
                )
            )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Images/bI.jpg'),
            fit: BoxFit.cover
          )
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 10,
              ),
              child: Text("Relaxing..",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 22,
                  fontFamily: 'Caveat',
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                ),
              ),
            ),
            Text('Take a Deep breath...',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 22,
                fontFamily: 'Caveat',
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            Text("Inhale peace",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 22,
                fontFamily: 'Caveat',
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),),
            Text("ExHale happiness",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 22,
                fontFamily: 'Caveat',
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}