import 'package:auth/business_logic/validation_errors.dart';

class RegisterViewState{
  final ValidationErrors emailError;
  final ValidationErrors nameError;
  final ValidationErrors passwordError;
  final ValidationErrors passwordConfirmError;

  RegisterViewState({
    required this.emailError,
    required this.passwordError,
    required this.nameError,
    required this.passwordConfirmError
  });

  RegisterViewState copy({
    ValidationErrors? emailError,
    ValidationErrors? nameError,
    ValidationErrors? passwordError,
    ValidationErrors? passwordConfirmError
  }){
    return RegisterViewState(
        emailError: emailError ?? this.emailError,
        nameError: nameError ?? this.nameError,
        passwordError: passwordError ?? this.passwordError,
        passwordConfirmError: passwordConfirmError ?? this.passwordConfirmError
    );
  }
}