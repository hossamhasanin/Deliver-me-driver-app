import 'package:auth/business_logic/signup/register/register_viewstate.dart';
import 'package:auth/business_logic/signup/signup_datasource.dart';

class RegisterUseCase{
  final SignupDataSource _dataSource;

  RegisterUseCase(this._dataSource);

  Future<RegisterViewState> register(RegisterViewState viewState , String email , String password) async {
    try{
      await _dataSource.registerAccount(email, password);
      return viewState.copy(loading: false , done: true , error: "");
    }catch(e){
      print("koko sign up error : "+e.toString());
      return viewState.copy(error: e.toString() , loading: false);
    }
  }

}