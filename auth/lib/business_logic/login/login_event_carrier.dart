class LoginEventCarrier{
  final String email;
  final String password;

  LoginEventCarrier({
    required this.email,
    required this.password
  });

  LoginEventCarrier copy({
    String? email,
    String? password
  }){
    return LoginEventCarrier(
      email: email ?? this.email,
      password: password ?? this.password
    );
  }

}