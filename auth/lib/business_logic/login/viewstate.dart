import 'package:auth/business_logic/validation_errors.dart';

class LoginViewState{
  final bool loading;
  final bool successfulLogin;
  final String error;
  final ValidationErrors emailError;
  final ValidationErrors passwordError;
  final bool fillAccountData;
  final bool isEmailNotVerified;

  LoginViewState({
    required this.loading,
    required this.error,
    required this.successfulLogin,
    required this.emailError,
    required this.passwordError,
    required this.fillAccountData,
    required this.isEmailNotVerified
  });

  LoginViewState copy({
    bool? loading,
    bool? successfulLogin,
    String? error,
    ValidationErrors? emailError,
    ValidationErrors? passwordError,
    bool? fillAccountData,
    bool? isEmailNotVerified
  }){
    return LoginViewState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        successfulLogin: successfulLogin ?? this.successfulLogin,
        emailError: emailError ?? this.emailError,
        passwordError: passwordError ?? this.passwordError,
        fillAccountData: fillAccountData ?? this.fillAccountData,
        isEmailNotVerified: isEmailNotVerified ?? this.isEmailNotVerified
    );
  }

}