import 'package:auth/business_logic/signup/fill_account_data/fill_account_data_viewstate.dart';
import 'package:auth/business_logic/signup/register/register_viewstate.dart';
import 'package:auth/business_logic/signup/signup_datasource.dart';
import 'package:base/base.dart';

class FillAccountDataUseCase{
  final SignupDataSource _dataSource;

  FillAccountDataUseCase(this._dataSource);

  Future<FillAccountDataViewState> fillData(FillAccountDataViewState viewState , User user) async {
    try{
      await _dataSource.fillAccountData(user);
      return viewState.copy(loading: false , done: true , error: "");
    }catch(e){
      print("koko sign up error : "+e.toString());
      return viewState.copy(error: e.toString() , loading: false);
    }
  }

}