import 'package:base/base.dart';

abstract class UserDataSource{
  Stream<User> userData();
  
}