import 'package:base/base.dart';

abstract class SignupDataSource{
  Future registerAccount(String email , String password);
  Future fillAccountData(User user);
}