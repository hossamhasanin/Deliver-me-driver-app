import 'package:auth/business_logic/validation_errors.dart';

class LoginViewState{
  final ValidationErrors emailError;
  final ValidationErrors passwordError;


  LoginViewState({
    required this.emailError,
    required this.passwordError,
  });

  LoginViewState copy({
    ValidationErrors? emailError,
    ValidationErrors? passwordError
  }){
    return LoginViewState(
        emailError: emailError ?? this.emailError,
        passwordError: passwordError ?? this.passwordError
    );
  }

}