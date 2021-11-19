import 'dart:async';

import 'package:base/base.dart';
import 'package:base/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_me_driver/data/user/user_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart' as F;

class UserDataSourceImp extends UserDataSource{

  final F.FirebaseAuth _firebaseAuth = F.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;

  @override
  Stream<User?> listenToUserData() async* {
    // return Stream.value(User(
    //     id: "kokoDriver1",
    //     name: "kokoDriver",
    //     email: "kokoDriver@koko.com",
    //     phone: "123456789",
    //     img: "https://www.volvotrucks.com/content/dam/volvo-trucks/markets/master/home/services-updates/driver-support/driver-development/driver-support-steering-wheel.jpg"
    // )).asBroadcastStream();

    if (isLoggedIn()){
      var query = _firestore.collection(USERS).doc(_firebaseAuth.currentUser!.uid);

      yield* query.snapshots().where((doc) => doc.exists).map((doc) { 
        _user = User.fromMap(doc.data()!);  
        return _user;
      });
    }else{
      throw "Error listened before there is any user";
    }
  }

  @override
  User? get user => _user;

  @override
  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null ? _firebaseAuth.currentUser!.emailVerified : false;
  }

  @override
  Future<User?> getUserData() async{
    var query = _firestore.collection(USERS).doc(_firebaseAuth.currentUser!.uid);

    var data = await query.get();

    if (!data.exists) {
      return null;
    }
    var user = User.fromMap(data.data()!);

    _user = user;
    return user;
  }




}