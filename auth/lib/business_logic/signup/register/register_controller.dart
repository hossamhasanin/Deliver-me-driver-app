import 'package:auth/business_logic/signup/register/register_viewstate.dart';
import 'package:auth/business_logic/signup/signup_datasource.dart';
import 'package:auth/business_logic/signup/register/register_usecase.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController{

  final Rx<RegisterViewState> viewState = RegisterViewState(
      loading: false,
      error: "",
      done: false
  ).obs;
  
  late final RegisterUseCase _useCase;
  
  RegisterController(SignupDataSource dataSource){
    _useCase = RegisterUseCase(dataSource);
  }
  
  register(String email , String password) async {
    _updateViewState(viewState.value.copy(loading: true));
    _updateViewState(await _useCase.register(viewState.value, email, password));
  }
  
  _updateViewState(RegisterViewState newState){
    viewState.value = newState;
  }

}