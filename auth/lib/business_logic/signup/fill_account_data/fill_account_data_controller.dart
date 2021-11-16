import 'package:auth/business_logic/signup/fill_account_data/fill_account_data_usecase.dart';
import 'package:auth/business_logic/signup/fill_account_data/fill_account_data_viewstate.dart';
import 'package:auth/business_logic/signup/register/register_viewstate.dart';
import 'package:auth/business_logic/signup/signup_datasource.dart';
import 'package:auth/business_logic/signup/register/register_usecase.dart';
import 'package:base/base.dart';
import 'package:get/get.dart';

class FillAccountDataController extends GetxController{

  final Rx<FillAccountDataViewState> viewState = FillAccountDataViewState(
      loading: false,
      error: "",
      done: false
  ).obs;
  
  late final FillAccountDataUseCase _useCase;
  
  FillAccountDataController(SignupDataSource dataSource){
    _useCase = FillAccountDataUseCase(dataSource);
  }
  
  fillAccountData(User user) async {
    _updateViewState(viewState.value.copy(loading: true));
    _updateViewState(await _useCase.fillData(viewState.value, user));
  }
  
  _updateViewState(FillAccountDataViewState newState){
    viewState.value = newState;
  }

}