import 'dart:io';

import 'package:base/base.dart';

abstract class SignupDataSource{
  Future registerAccount(String email , String password);
  Future fillAccountData(String phone , String imgUrl);
  Future<String> upload(File image);
}