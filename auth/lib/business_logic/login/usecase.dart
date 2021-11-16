import 'package:auth/business_logic/login/login_datasource.dart';
import 'package:auth/business_logic/login/viewstate.dart';

class LoginUseCase{

  final LoginDataSource _loginDataSource;

  LoginUseCase(this._loginDataSource);

  Future<LoginViewState> login(LoginViewState viewState , String email , String password) async {
    try{
      await _loginDataSource.login(email, password);
      return viewState.copy(loading: false , successfulLogin: true , error: "");
    } catch(e) {
      print("koko login error : "+e.toString());
      return viewState.copy(error: e.toString() , loading: false);
    }
  }

}