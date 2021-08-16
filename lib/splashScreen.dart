import 'dart:async';
import 'dart:io';
import 'package:movie_app/model/movie_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/Home.dart';

class SplashScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff031435),
      body: Center(child: Lottie.asset('assets/animate.json'),),
    );
  }

}