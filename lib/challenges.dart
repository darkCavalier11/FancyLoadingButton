import 'dart:math';

import 'package:flutter/material.dart';

class FancyLoadingButton extends StatelessWidget {
  const FancyLoadingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Button();
  }
}

class Button extends StatefulWidget {
  const Button({
    Key? key,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> with TickerProviderStateMixin {
  late final AnimationController _widthAnimationController,
      _borderRadiusAnimationController,
      _textAnimationController,
      _centerDotOffsetAnimationController,
      _centerDotRotationAnimationController,
      _buttonScaleAnimationController;
  late final Animation<double> _widthAnimation,
      _borderRadiusAnimation,
      _textAnimation,
      _centerDotOffsetAnimation,
      _centerDotRotationAnimation,
      _buttonScaleAnimation;

  @override
  void initState() {
    _widthAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _borderRadiusAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _centerDotOffsetAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _centerDotRotationAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 4))
          ..repeat();

    _buttonScaleAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _buttonScaleAnimationController.repeat(reverse: true);
            }
          });
    _widthAnimation = Tween<double>(begin: 300, end: 65).animate(
        CurvedAnimation(
            parent: _widthAnimationController, curve: Curves.easeInBack));

    _borderRadiusAnimation = Tween<double>(begin: 15, end: 50)
        .animate(_borderRadiusAnimationController);

    _textAnimation =
        Tween<double>(begin: 22, end: 0).animate(_textAnimationController);

    _centerDotOffsetAnimation = Tween<double>(begin: 0, end: 50)
        .animate(_centerDotOffsetAnimationController);

    _centerDotRotationAnimation = Tween<double>(begin: 0, end: 2)
        .animate(_centerDotRotationAnimationController);

    _buttonScaleAnimation = Tween<double>(begin: 1, end: 1.2)
        .animate(_buttonScaleAnimationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _widthAnimation,
          builder: (context, widget) {
            return GestureDetector(
              onTap: () {
                _widthAnimationController.forward().whenComplete(
                    () => _buttonScaleAnimationController.forward());
                _borderRadiusAnimationController.forward();
                _textAnimationController.forward().whenCompleteOrCancel(() {
                  _centerDotOffsetAnimationController.forward();
                });
              },
              child: AnimatedBuilder(
                animation: _borderRadiusAnimation,
                builder: (context, child) {
                  return AnimatedBuilder(
                    animation: _buttonScaleAnimation,
                    builder: (context, widget) => Container(
                      width:
                          _widthAnimation.value * _buttonScaleAnimation.value,
                      height: 65 * _buttonScaleAnimation.value,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(
                            _borderRadiusAnimation.value *
                                _buttonScaleAnimation.value),
                      ),
                      child: Center(
                        child: CustomAnimatedText(
                          textAnimation: _textAnimation,
                          textAnimationController: _textAnimationController,
                          centerDotOffsetAnimation: _centerDotOffsetAnimation,
                          centerDotOffsetAnimationController:
                              _centerDotOffsetAnimationController,
                          centerDotRotationAnimation:
                              _centerDotRotationAnimation,
                          centerDotRotationAnimationController:
                              _centerDotRotationAnimationController,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        ElevatedButton(
            onPressed: () async {
              _buttonScaleAnimationController.reverse();
              _centerDotOffsetAnimationController.reverse();
              // Let the dot come to
              await Future.delayed(Duration(milliseconds: 500));
              _centerDotRotationAnimationController.stop();
            },
            child: Text('Reverse')),
      ],
    );
  }
}

class CustomAnimatedText extends StatelessWidget {
  final AnimationController textAnimationController,
      centerDotOffsetAnimationController,
      centerDotRotationAnimationController;
  final Animation<double> textAnimation,
      centerDotOffsetAnimation,
      centerDotRotationAnimation;
  const CustomAnimatedText({
    required this.textAnimationController,
    required this.centerDotOffsetAnimationController,
    required this.centerDotOffsetAnimation,
    required this.textAnimation,
    required this.centerDotRotationAnimationController,
    required this.centerDotRotationAnimation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: textAnimation,
      builder: (context, widget) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Text(
              'Submit',
              style: TextStyle(
                fontSize: textAnimation.value,
                color: Colors.white,
              ),
            ),
            AnimatedBuilder(
                animation: centerDotOffsetAnimation,
                builder: (context, widget) {
                  return AnimatedBuilder(
                      animation: centerDotRotationAnimation,
                      builder: (context, widget) {
                        return Transform.rotate(
                          angle: centerDotRotationAnimation.value * 5 * pi,
                          child: Transform.translate(
                            offset: Offset(centerDotOffsetAnimation.value,
                                centerDotOffsetAnimation.value),
                            child: Container(
                              width: 22 - textAnimation.value,
                              height: 22 - textAnimation.value,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ],
        );
      },
    );
  }
}
