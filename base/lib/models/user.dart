import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? img;

  User({required this.id , required this.name, required this.email, required this.phone, required this.img});

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    img
  ];

  Map<String , dynamic> toMap(){
    return {
      "id" : id,
      "name" : name,
      "email" : email,
      "phone" : phone,
      "img" : img
    };
  }

  static User fromMap(Map<String , dynamic> map){
    return User(id: map["id"], name: map["name"], email: map["email"], phone: map["phone"], img: map["img"]);  }

}