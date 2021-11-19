import 'package:auth/business_logic/login/login_datasource.dart';
import 'package:auth/business_logic/login/viewstate.dart';

class LoginUseCase{

  final LoginDataSource _loginDataSource;

  LoginUseCase(this._loginDataSource);

  Future<LoginViewState> login(LoginViewState viewState , String email , String password) async {
    try{
      print("koko "+email+" "+password);
      await _loginDataSource.login(email, password);
      var isEmailVerified = await _loginDataSource.isEmailVerified();
      var doesAccountExist = await _loginDataSource.isUserInDatabase();
      return viewState.copy(loading: false ,isEmailNotVerified: !isEmailVerified , successfulLogin: isEmailVerified && doesAccountExist , fillAccountData: isEmailVerified && !doesAccountExist , error: "");
    } catch(e) {
      print("koko login error : "+e.toString());
      return viewState.copy(error: e.toString() , loading: false);
    }
  }

}