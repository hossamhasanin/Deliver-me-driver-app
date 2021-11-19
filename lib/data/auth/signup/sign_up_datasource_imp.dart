import 'dart:io';

import 'package:auth/business_logic/signup/signup_datasource.dart';
import 'package:base/base.dart';
import 'package:base/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as F;
import 'package:firebase_storage/firebase_storage.dart';

class SignUpDataSourceImp implements SignupDataSource{

  final F.FirebaseAuth _firebaseAuth = F.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future fillAccountData(String phone , String imgUrl) async {
    var query = _firestore.collection(USERS).doc(_firebaseAuth.currentUser!.uid);
    return query.set(User(
        id: _firebaseAuth.currentUser!.uid,
        name: _firebaseAuth.currentUser!.displayName,
        email: _firebaseAuth.currentUser!.email,
        phone: phone,
        img: imgUrl
    ).toMap());
  }

  @override
  Future registerAccount(String email, String password) async {
    var u = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return u.user!.sendEmailVerification();
  }

  @override
  Future<String> upload(File image) async {
    var storageReference = FirebaseStorage.instance
        .ref()
        .child('users_images')
        .child(DateTime.now().millisecondsSinceEpoch.toString());

    await storageReference.putFile(image);

    var fileURL = await storageReference.getDownloadURL();

    return fileURL;
  }

}