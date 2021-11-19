import 'package:base/base.dart';

abstract class UserDataSource{
  Stream<User?> listenToUserData();
  Future<User?> getUserData();
  User? get user;
  bool isLoggedIn();
}