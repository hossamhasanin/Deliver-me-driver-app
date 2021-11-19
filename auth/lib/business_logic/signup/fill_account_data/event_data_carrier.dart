import 'dart:io';

class FillAccountDataEventDataCarrier {
  final String phone;
  final File photo;
  final String photoUrl;

  FillAccountDataEventDataCarrier({
    required this.phone,
    required this.photo,
    required this.photoUrl
  });

  FillAccountDataEventDataCarrier copy({
    String? phone,
    File? photo,
    String? photoUrl
  }){
    return FillAccountDataEventDataCarrier(
        phone: phone ?? this.phone,
        photo: photo ?? this.photo,
        photoUrl: photoUrl ?? this.photoUrl
    );
  }



}