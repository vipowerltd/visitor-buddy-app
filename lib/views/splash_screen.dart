import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';

import '../resources/styles/colours.dart';
import '../resources/widgets/drawer.dart';
import '../resources/widgets/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key,});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColour,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Stack(
          children: [
            ImageAnimateRotate(child: Container(
              height: 150,
              child: Image.asset('assets/images/splash_comp2.png',),
            ),),
            Center(
              child: Container(
                height: 75,
                child: Image.asset('assets/images/splash_comp1.png', fit: BoxFit.fitHeight),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ImageAnimateRotate extends StatefulWidget {
  final Widget child;
  const ImageAnimateRotate({Key? key, required this.child}) : super(key: key);

  @override
  _ImageAnimateRotateState createState() => _ImageAnimateRotateState();
}

class _ImageAnimateRotateState extends State<ImageAnimateRotate> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 10))..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}


//TODO
//________________________
//