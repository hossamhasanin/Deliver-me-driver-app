import 'package:base/base.dart';
import 'package:deliver_me_driver/data/user/user_datasource.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map/ui/map_screen.dart';
import 'package:splash/ui/splash_screen.dart';
import 'package:auth/auth.dart';

import 'dependincies.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainApp(),
      getPages: [
        GetPage(name: SPLASH_SCREEN, page: () => const SplashScreen()),
        GetPage(name: AUTH_SCREEN, page: () => const AuthScreen()),
        GetPage(name: MAP_SCREEN, page: () => Builder(
          builder: (context) {
            UserDataSource _userDatasource = Get.find();
            _userDatasource.listenToUserData();
            return const MapScreen();
          }
        )),
      ],
    );
  }
}

class MainApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text(snapshot.error.toString()),),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          inject();
          return const SplashScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }
}
