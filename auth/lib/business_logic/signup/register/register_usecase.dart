import 'package:auth/business_logic/signup/register/busuness_logic_events.dart';
import 'package:auth/business_logic/signup/register/register_viewstate.dart';
import 'package:auth/business_logic/signup/signup_datasource.dart';
import 'package:base/base.dart';

class RegisterUseCase{
  final SignupDataSource _dataSource;

  RegisterUseCase(this._dataSource);

  Future<BusinessLogicEvents> register(String email , String password) async {
    try{
      await _dataSource.registerAccount(email, password);
      return ShowDoneRegistrationDialog();
    } on AuthException catch(e){
      print("koko sign up error : "+e.code);
      return ShowErrorDialog(e.code);
    }
  }

}