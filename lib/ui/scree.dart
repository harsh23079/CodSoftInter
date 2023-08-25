import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todoapp/ui/homescreen.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/img/list.png",
            scale: 5,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Welcome..!!",
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
