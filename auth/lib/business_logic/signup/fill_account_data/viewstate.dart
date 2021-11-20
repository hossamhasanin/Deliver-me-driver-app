import 'package:auth/business_logic/validation_errors.dart';

class FillAccountDataViewState{
  final ValidationErrors phoneError;
  final bool showImage;

  FillAccountDataViewState({
    required this.phoneError,
    required this.showImage
  });

  FillAccountDataViewState copy({
    ValidationErrors? phoneError,
    bool? showImage
  }){
    return FillAccountDataViewState(
        phoneError: phoneError ?? this.phoneError,
        showImage: showImage ?? this.showImage
    );
  }
}