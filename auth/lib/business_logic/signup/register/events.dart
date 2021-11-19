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
class EnterName extends Events{
  final String name;

  const EnterName(this.name);
  @override
  List<Object?> get props => [name];
}

class EnterPassword extends Events{
  final String password;

  const EnterPassword(this.password);
  @override
  List<Object?> get props => [password];
}

class EnterPasswordConfirm extends Events{
  final String passwordConfirm;

  const EnterPasswordConfirm(this.passwordConfirm);
  @override
  List<Object?> get props => [passwordConfirm];
}

class Register extends Events{}

