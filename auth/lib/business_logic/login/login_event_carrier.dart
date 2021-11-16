class LoginEventCarrier{
  final String email;
  final String password;
  final bool login;

  LoginEventCarrier({
    required this.email,
    required this.password,
    required this.login
  });

  LoginEventCarrier copy({
    String? email,
    String? password,
    bool? login
  }){
    return LoginEventCarrier(
      email: email ?? this.email,
      password: password ?? this.password,
      login: login ?? this.login
    );
  }

}