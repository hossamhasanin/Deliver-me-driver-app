import 'package:equatable/equatable.dart';

class LoginEvents extends Equatable{
  const LoginEvents();
  
  @override
  List<Object?> get props => [];
}

class EnterEmail extends LoginEvents{
  final String email;

  const EnterEmail(this.email);

  @override
  List<Object?> get props => [email];
}

class EnterPassword extends LoginEvents{
  final String password;

  const EnterPassword(this.password);
  
  @override
  List<Object?> get props => [password];
}

class Login extends LoginEvents{}