import 'dart:async';

import 'package:auth/business_logic/login/busuness_logic_events.dart';
import 'package:auth/business_logic/login/events.dart';
import 'package:auth/business_logic/login/login_datasource.dart';
import 'package:auth/business_logic/login/login_event_carrier.dart';
import 'package:auth/business_logic/login/usecase.dart';
import 'package:auth/business_logic/login/viewstate.dart';
import 'package:auth/business_logic/validation_errors.dart';
import 'package:auth/business_logic/validation_usecase.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{
  late final LoginUseCase _useCase;
  final InputsValidationUseCase _validationUseCase = InputsValidationUseCase();
  final Rx<LoginViewState> viewState = LoginViewState(
      emailError: ValidationErrors.NONE,
      passwordError: ValidationErrors.NONE
  ).obs;

  LoginEventCarrier _eventCarrier = LoginEventCarrier(
    email: "",
    password: ""
  );

  StreamSubscription? _eventCarrierListener;
  final StreamController<LoginEvents> _eventsStream = StreamController.broadcast();
  final StreamController<BusinessLogicEvents> _businessLogicEvents = StreamController.broadcast();


  Stream<BusinessLogicEvents> get businessLogicEventsStream => _businessLogicEvents.stream;


  LoginController(LoginDataSource dataSource){
    _useCase = LoginUseCase(dataSource);
  }

  listenToEvents(){
    _eventCarrierListener = _eventsStream.stream.distinct().listen((event) {
      if (event is EnterEmail){
        // validate the email
        _validateEmail(event.email);
      } else if (event is EnterPassword){
        // validate the password
        _validatePassword(event.password);
      } else if (event is Login){
        // do login process
        _login();
      }
    });
  }

  login() async {
    _eventsStream.add(Login());
  }

  enterEmail(String email){
    _eventsStream.add(EnterEmail(email));
  }

  enterPassword(String password){
    _eventsStream.add(EnterPassword(password));
  }

  _validateEmail(String email){
    _eventCarrier = _eventCarrier.copy(email: email);

    var error = _validationUseCase.validateEmail(email);
    
    _updateViewState(viewState.value.copy(emailError: error));

  }
  
  _validatePassword(String password){
    _eventCarrier = _eventCarrier.copy(password: password);

    var error = _validationUseCase.validatePassword(password);
    
    _updateViewState(viewState.value.copy(passwordError: error));

  }

  _login() async {
    if (viewState.value.passwordError != ValidationErrors.NONE || viewState.value.emailError != ValidationErrors.NONE){
      _businessLogicEvents.add(const ShowErrorDialog("invalid-inputs"));
      return;
    }
    _businessLogicEvents.add(ShowLoadingDialog());
    _businessLogicEvents.add(await _useCase.login(_eventCarrier.email, _eventCarrier.password));
  }

  _updateViewState(LoginViewState loginViewState){
    viewState.value = loginViewState;
  }


  @override
  void onClose() {
    viewState.close();
    if (_eventCarrierListener != null){
      _eventCarrierListener!.cancel();
    }
    _eventsStream.close();
    super.onClose();
  }

}