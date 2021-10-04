import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class FancyLoadingButton extends StatelessWidget {
  final Color? primaryColor;
  final Color? accentColor;
  final double? width;
  final double? height;
  final Function() onTap;
  final FancyButtonAnimationController fancyButtonAnimationController;
  const FancyLoadingButton(
      {Key? key,
      this.primaryColor,
      this.accentColor,
      this.width,
      this.height,
      required this.fancyButtonAnimationController,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Button(
      fancyButtonAnimationController: fancyButtonAnimationController,
      onTap: onTap,
    );
  }
}

class _Button extends StatefulWidget {
  final Color? primaryColor;
  final Color? accentColor;
  final double? width;
  final double? height;
  final Function() onTap;
  final FancyButtonAnimationController fancyButtonAnimationController;
  const _Button({
    Key? key,
    this.primaryColor,
    this.accentColor,
    this.width,
    this.height,
    required this.fancyButtonAnimationController,
    required this.onTap,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<_Button> with TickerProviderStateMixin {
  late final Color? primaryColor;
  late final Color? accentColor;
  late final double? width;
  late final double? height;
  late final Function() onTap;
  late final Widget initial;
  late final Stream<String> _streamSubscription;
  late final AnimationController _widthAnimationController,
      _borderRadiusAnimationController,
      _textAnimationController,
      _centerDotOffsetAnimationController,
      _centerDotRotationAnimationController,
      _buttonScaleAnimationController,
      _visibilityAnimationController;
  late final Animation<double> _widthAnimation,
      _borderRadiusAnimation,
      _textAnimation,
      _centerDotOffsetAnimation,
      _centerDotRotationAnimation,
      _buttonScaleAnimation,
      _visibilityAnimation;

  @override
  void initState() {
    primaryColor = widget.primaryColor;
    accentColor = widget.accentColor;
    width = widget.width;
    height = widget.height;
    onTap = widget.onTap;
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

    _visibilityAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

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

    _visibilityAnimation =
        Tween<double>(begin: 0, end: 1).animate(_visibilityAnimationController);
    super.initState();
  }

  void forward() {
    _widthAnimationController
        .forward()
        .whenComplete(() => _buttonScaleAnimationController.forward());
    _borderRadiusAnimationController.forward();
    _textAnimationController.forward().whenCompleteOrCancel(() {
      _centerDotOffsetAnimationController.forward();
    });
  }

  void complete() async {
    _buttonScaleAnimationController.reverse();
    _centerDotOffsetAnimationController.reverse();
    // Let the dot come to
    await Future.delayed(Duration(milliseconds: 500));
    _centerDotRotationAnimationController.stop();
    _visibilityAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: widget.fancyButtonAnimationController.stream,
        builder: (context, snapshot) {
          if (snapshot.data == 'Complete') {
            complete();
          }
          if (snapshot.data == 'Start') {
            forward();
          }
          return AnimatedBuilder(
            animation: _widthAnimation,
            builder: (context, widget) {
              return GestureDetector(
                onTap: () {
                  onTap();
                  if (snapshot.data == 'forward') forward();
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
                          child: _CustomAnimatedText(
                            visibilityAnimation: _visibilityAnimation,
                            visibilityAnimationController:
                                _visibilityAnimationController,
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
          );
        });
  }
}

class _CustomAnimatedText extends StatelessWidget {
  final AnimationController textAnimationController,
      centerDotOffsetAnimationController,
      centerDotRotationAnimationController,
      visibilityAnimationController;
  final Animation<double> textAnimation,
      centerDotOffsetAnimation,
      centerDotRotationAnimation,
      visibilityAnimation;
  const _CustomAnimatedText({
    required this.textAnimationController,
    required this.centerDotOffsetAnimationController,
    required this.centerDotOffsetAnimation,
    required this.textAnimation,
    required this.centerDotRotationAnimationController,
    required this.centerDotRotationAnimation,
    Key? key,
    required this.visibilityAnimationController,
    required this.visibilityAnimation,
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
                          child: AnimatedBuilder(
                            animation: visibilityAnimation,
                            builder: (context, widget) => Opacity(
                              opacity: 1 - visibilityAnimation.value,
                              child: Container(
                                width: 22 - textAnimation.value,
                                height: 22 - textAnimation.value,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
            AnimatedBuilder(
              animation: visibilityAnimation,
              builder: (context, widget) => Opacity(
                opacity: visibilityAnimation.value,
                child: Icon(
                  Icons.check_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class FancyButtonAnimationController {
  StreamController<String> _interaction = StreamController<String>();

  void start() {
    _interaction.sink.add('Start');
  }

  void complete() {
    _interaction.sink.add('Complete');
  }

  Stream<String> get stream => _interaction.stream;
}
