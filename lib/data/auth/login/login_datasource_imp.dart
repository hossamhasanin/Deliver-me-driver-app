import 'package:auth/business_logic/login/login_datasource.dart';
import 'package:base/base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginDataSourceImp implements LoginDataSource{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future forgotPassword(String email) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future login(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<bool> isUserInDatabase() async {
    var query = await _firestore.collection(USERS).doc(_firebaseAuth.currentUser!.uid).get();

    return query.exists;
  }

  @override
  Future<bool> isEmailVerified() async {
    return _firebaseAuth.currentUser!.emailVerified;
  }

}