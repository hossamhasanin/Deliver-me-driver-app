import 'package:auth/business_logic/validation_errors.dart';

class FillAccountDataViewState{
  final bool loading;
  final String error;
  final bool done;
  final ValidationErrors phoneError;
  final bool showImage;

  FillAccountDataViewState({
    required this.loading,
    required this.error,
    required this.done,
    required this.phoneError,
    required this.showImage
  });

  FillAccountDataViewState copy({
    bool? loading,
    String? error,
    bool? done,
    ValidationErrors? phoneError,
    bool? showImage
  }){
    return FillAccountDataViewState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        done: done ?? this.done,
        phoneError: phoneError ?? this.phoneError,
        showImage: showImage ?? this.showImage
    );
  }
}