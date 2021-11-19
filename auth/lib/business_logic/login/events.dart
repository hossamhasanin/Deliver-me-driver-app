import 'package:equatable/equatable.dart';

class Events extends Equatable{
  const Events();
  
  @override
  List<Object?> get props => [];
}

class EnterEmail extends Events{
  final String email;

  const EnterEmail(this.email);

  @override
  List<Object?> get props => [email];
}

class EnterPassword extends Events{
  final String password;

  const EnterPassword(this.password);
  
  @override
  List<Object?> get props => [password];
}

class Login extends Events{}