import 'package:auth/business_logic/validation_errors.dart';

class RegisterViewState{
  final bool loading;
  final String error;
  final bool done;
  final ValidationErrors emailError;
  final ValidationErrors nameError;
  final ValidationErrors passwordError;
  final ValidationErrors passwordConfirmError;

  RegisterViewState({
    required this.loading,
    required this.error,
    required this.done,
    required this.emailError,
    required this.passwordError,
    required this.nameError,
    required this.passwordConfirmError
  });

  RegisterViewState copy({
    bool? loading,
    String? error,
    bool? done,
    ValidationErrors? emailError,
    ValidationErrors? nameError,
    ValidationErrors? passwordError,
    ValidationErrors? passwordConfirmError
  }){
    return RegisterViewState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        done: done ?? this.done,
        emailError: emailError ?? this.emailError,
        nameError: nameError ?? this.nameError,
        passwordError: passwordError ?? this.passwordError,
        passwordConfirmError: passwordConfirmError ?? this.passwordConfirmError
    );
  }
}