import 'package:base/base.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map/ui/map_screen.dart';

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
        GetPage(name: MAP_SCREEN, page: () => const MapScreen())
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
          return const MapScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }
}
