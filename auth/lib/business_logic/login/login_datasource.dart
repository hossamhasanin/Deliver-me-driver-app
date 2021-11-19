abstract class LoginDataSource{
  Future login(String email , String password);
  Future forgotPassword(String email);
  Future<bool> isUserInDatabase();
  Future<bool> isEmailVerified();
}