import 'package:auth/business_logic/validation_errors.dart';

class LoginViewState{
  final bool loading;
  final bool successfulLogin;
  final String error;
  final ValidationErrors emailError;
  final ValidationErrors passwordError;

  LoginViewState({
    required this.loading,
    required this.error,
    required this.successfulLogin,
    required this.emailError,
    required this.passwordError
  });

  LoginViewState copy({
    bool? loading,
    bool? successfulLogin,
    String? error,
    ValidationErrors? emailError,
    ValidationErrors? passwordError
  }){
    return LoginViewState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        successfulLogin: successfulLogin ?? this.successfulLogin,
        emailError: emailError ?? this.emailError,
        passwordError: passwordError ?? this.passwordError
    );
  }

}