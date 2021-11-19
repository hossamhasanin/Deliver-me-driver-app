import 'package:auth/business_logic/validation_errors.dart';

class InputsValidationUseCase{

  RegExp _emailReg = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  
  ValidationErrors validateEmail(String email){
    if (email == ""){
      return ValidationErrors.EMAIL_EMPTY;
    }
    
    if (!_emailReg.hasMatch(email)){
      return ValidationErrors.EMAIL_NOT_VALID;
    }
    return ValidationErrors.NONE;
  }
  
  ValidationErrors validatePassword(String password){
    if (password == ""){
      return ValidationErrors.PASSWORD_EMPTY;
    }
    
    if (password.length < 5){
      return ValidationErrors.PASSWORD_SHORT;
    }
    return ValidationErrors.NONE;
  }

  ValidationErrors validateName(String name){
     if (name.isEmpty){
        return ValidationErrors.NAME_EMPTY;
     }

     return ValidationErrors.NONE;
  }

  ValidationErrors validatePasswordConfirm(String passwordConfirm , String password){
     if (password.isEmpty){
        return ValidationErrors.PASSWORD_EMPTY;
     }

     if (password != passwordConfirm){
       return ValidationErrors.PASSWORDS_DIFFERENT;
     }

     return ValidationErrors.NONE;
  }

  ValidationErrors validatePhone(String phone){
     if (phone.isEmpty){
        return ValidationErrors.PHONE_EMPTY;
     }

     if (phone.length < 5){
       return ValidationErrors.PHONE_NOT_VALID;
     }

     return ValidationErrors.NONE;
  }
  
  
}