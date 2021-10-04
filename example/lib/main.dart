import 'package:flutter/material.dart';
import 'package:challenges/challenges.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FancyButtonAnimationController _fancyButtonAnimationController =
      FancyButtonAnimationController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: FancyLoadingButton(
            onTap: () {
              _fancyButtonAnimationController.start();
            },
            fancyButtonAnimationController: _fancyButtonAnimationController,
          ),
        ),
      ),
    );
  }
}
