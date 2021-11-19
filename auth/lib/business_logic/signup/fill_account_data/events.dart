import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class Event extends Equatable{

  const Event();

  @override
  List<Object?> get props => [];
}

class UploadEvent extends Event{
  final File image;

  const UploadEvent(this.image);
  
  @override
  List<Object?> get props => [image];
}
class PhoneTypingEvent extends Event{
  final String phone;

  const PhoneTypingEvent(this.phone);
  @override
  List<Object?> get props => [phone];
}

class DoneEvent extends Event{}

