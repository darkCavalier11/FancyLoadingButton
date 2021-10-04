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
  String _currentState = 'idle';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FancyLoadingButton(
                onTap: () {
                  _fancyButtonAnimationController.start();
                },
                fancyButtonAnimationController: _fancyButtonAnimationController,
              ),
              SizedBox(
                height: 50,
              ),
              IconButton(
                onPressed: () {
                  if (_currentState == 'idle') {
                    _fancyButtonAnimationController.start();
                    setState(() {
                      _currentState = 'play';
                    });
                  } else {
                    _fancyButtonAnimationController.complete();
                    setState(() {
                      _currentState = 'idle';
                    });
                  }
                },
                icon: _currentState == 'idle'
                    ? Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 50,
                      )
                    : Icon(
                        Icons.pause_circle,
                        color: Colors.white,
                        size: 50,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
