import 'dart:async';

import 'package:auth/business_logic/signup/register/busuness_logic_events.dart';
import 'package:auth/business_logic/signup/register/events.dart';
import 'package:auth/business_logic/signup/register/register_event_carrier.dart';
import 'package:auth/business_logic/signup/register/register_viewstate.dart';
import 'package:auth/business_logic/signup/signup_datasource.dart';
import 'package:auth/business_logic/signup/register/register_usecase.dart';
import 'package:auth/business_logic/validation_errors.dart';
import 'package:auth/business_logic/validation_usecase.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController{

  final Rx<RegisterViewState> viewState = RegisterViewState(
      emailError: ValidationErrors.NONE,
      passwordError: ValidationErrors.NONE,
      passwordConfirmError: ValidationErrors.NONE,
      nameError: ValidationErrors.NONE
  ).obs;

  RegisterEventCarrier _eventCarrier = RegisterEventCarrier(
      email: "",
      name: "",
      password: "",
      passwordConfirm: ""
  );
  
  late final RegisterUseCase _useCase;
  final InputsValidationUseCase _validationUseCase = InputsValidationUseCase();

  final StreamController<Events> _eventStream = StreamController.broadcast();
  final StreamController<BusinessLogicEvents> _businessLogicEvents = StreamController.broadcast();

  Stream<BusinessLogicEvents> get businessLogicEventStream => _businessLogicEvents.stream;

  StreamSubscription? _eventListener;
  
  RegisterController(SignupDataSource dataSource){
    _useCase = RegisterUseCase(dataSource);
  }

  listenToEvents(){
    _eventListener = _eventStream.stream.distinct().listen((event) {
      if (event is EnterEmail){
        _validateEmail(event.email);
      } else if (event is EnterName){
        _validateName(event.name);
      } else if (event is EnterPassword){
        _validatePassword(event.password);
      } else if (event is EnterPasswordConfirm){
        _validatePasswordConfirm(event.passwordConfirm);
      } else if (event is Register){
        _register();
      }
    });
  }
  
  register() async {
    _eventStream.add(Register());
  }

  enterEmail(String email){
    _eventStream.add(EnterEmail(email));
  }

  enterPassword(String password){
    _eventStream.add(EnterPassword(password));
  }

  enterPasswordConfirm(String passwordConfirm){
    _eventStream.add(EnterPasswordConfirm(passwordConfirm));
  }

  enterName(String name){
    _eventStream.add(EnterName(name));
  }

  _validateEmail(String email){
    _eventCarrier = _eventCarrier.copy(email: email);
    var error = _validationUseCase.validateEmail(email);
    _updateViewState(viewState.value.copy(emailError: error));
  }

  _validateName(String name){
    _eventCarrier = _eventCarrier.copy(name: name);
    var error = _validationUseCase.validateName(name);
    _updateViewState(viewState.value.copy(nameError: error));
  }

  _validatePassword(String password){
    _eventCarrier = _eventCarrier.copy(password: password);
    var error = _validationUseCase.validatePassword(password);
    _updateViewState(viewState.value.copy(passwordError: error));
  }

  _validatePasswordConfirm(String passwordConfirm){
    _eventCarrier = _eventCarrier.copy(passwordConfirm: passwordConfirm);
    var error = _validationUseCase.validatePasswordConfirm(passwordConfirm, _eventCarrier.password);
    _updateViewState(viewState.value.copy(passwordConfirmError: error));
  }

  _register() async {
      if (viewState.value.emailError != ValidationErrors.NONE ||
        viewState.value.nameError != ValidationErrors.NONE ||
        viewState.value.passwordError != ValidationErrors.NONE ||
        viewState.value.passwordConfirmError != ValidationErrors.NONE
      ){
        _businessLogicEvents.add(const ShowErrorDialog("invalid-inputs"));
        return;
      }

      _businessLogicEvents.add(ShowLoadingDialog());
      _businessLogicEvents.add(await _useCase.register(_eventCarrier.email, _eventCarrier.password));
  }
  
  _updateViewState(RegisterViewState newState){
    viewState.value = newState;
  }

  @override
  void onClose() {
    if (_eventListener != null){
      _eventListener!.cancel();
    }
    _eventStream.close();
    viewState.close();
    super.onClose();
  }

}