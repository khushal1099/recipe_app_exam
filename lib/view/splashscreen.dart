import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app_exam/view/loginpage.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
      () {
        Get.off(
          LoginPage(),
        );
      },
    );
    super.initState();
  }

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.sizeOf(context).height * 3,
        width: MediaQuery.sizeOf(context).width * 4,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("recipe.jpg"),),),
      ),
    );
  }
}
