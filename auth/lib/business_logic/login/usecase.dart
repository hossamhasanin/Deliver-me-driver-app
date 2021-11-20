import 'package:auth/business_logic/login/busuness_logic_events.dart';
import 'package:auth/business_logic/login/login_datasource.dart';
import 'package:auth/business_logic/login/viewstate.dart';
import 'package:base/base.dart';

class LoginUseCase{

  final LoginDataSource _loginDataSource;

  LoginUseCase(this._loginDataSource);

  Future<BusinessLogicEvents> login(String email , String password) async {
    try{
      print("koko "+email+" "+password);
      await _loginDataSource.login(email, password);
      var isEmailVerified = await _loginDataSource.isEmailVerified();
      var doesAccountExist = await _loginDataSource.isUserInDatabase();

      if (!isEmailVerified){
        throw AuthException("email-not-verified", "");
      }

      if (!doesAccountExist){
        return ShowGoToFillAccountDataDialog();
      }

      return ShowSuccessFullLoginDialog();
    } on AuthException catch(e) {
      print("koko login error : "+e.code);
      return ShowErrorDialog(e.code);
    }
  }

}