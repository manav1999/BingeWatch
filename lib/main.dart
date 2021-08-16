import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/Home.dart';
import 'package:movie_app/splashScreen.dart';
import 'package:movie_app/utils/movieProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'model/movie_model.dart';
 void main() {
   WidgetsFlutterBinding.ensureInitialized();
   Hive.registerAdapter(MovieAdapter());
   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
       .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {


  Future initHive() async {
    Directory directory =await getApplicationDocumentsDirectory();
    await Firebase.initializeApp();


    Hive.init(directory.path);

  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(create: (context)=>MovieProvider(),child: MaterialApp(
      title: 'BingeWatch',
      debugShowCheckedModeBanner:false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => FutureBuilder(future:initHive(),builder: (context,snapshot)
        {
          if(snapshot.connectionState==ConnectionState.done)
            {
              if(snapshot.error!=null)
              {
                print(snapshot.error);
                return Scaffold(
                  body: Center(child:Text("Error ")),
                );
              }
              else
                {
                  return Home();
                }

            }
          else
            {
              return SplashScreen();
            }

        })
      },
    ),);
  }
}

