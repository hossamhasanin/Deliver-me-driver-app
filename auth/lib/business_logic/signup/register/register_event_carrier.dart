class RegisterEventCarrier{
  final String email;
  final String name;
  final String password;
  final String passwordConfirm;

  RegisterEventCarrier({
    required this.email,
    required this.name,
    required this.password,
    required this.passwordConfirm,
  });

  RegisterEventCarrier copy({
    String? email,
    String? name,
    String? password,
    String? passwordConfirm,
  }){
      return RegisterEventCarrier(
          email: email ?? this.email,
          name: name ?? this.name,
          password: password ?? this.password,
          passwordConfirm: passwordConfirm ?? this.passwordConfirm
      );
  }

}