import 'dart:async';
import 'dart:io';

import 'package:auth/business_logic/signup/fill_account_data/event_data_carrier.dart';
import 'package:auth/business_logic/signup/fill_account_data/events.dart';
import 'package:auth/business_logic/signup/fill_account_data/usecase.dart';
import 'package:auth/business_logic/signup/fill_account_data/viewstate.dart';
import 'package:auth/business_logic/signup/register/register_viewstate.dart';
import 'package:auth/business_logic/signup/signup_datasource.dart';
import 'package:auth/business_logic/signup/register/register_usecase.dart';
import 'package:auth/business_logic/validation_errors.dart';
import 'package:auth/business_logic/validation_usecase.dart';
import 'package:base/base.dart';
import 'package:get/get.dart';

class FillAccountDataController extends GetxController{

  final Rx<FillAccountDataViewState> viewState = FillAccountDataViewState(
      loading: false,
      error: "",
      done: false,
      showImage: false,
      phoneError: ValidationErrors.NONE
  ).obs;
  
  late final FillAccountDataUseCase _useCase;
  final InputsValidationUseCase _validationUseCase = InputsValidationUseCase();
  
  final StreamController<Event> _eventStream = StreamController();
  StreamSubscription? _eventListener;
  
  FillAccountDataController(SignupDataSource dataSource){
    _useCase = FillAccountDataUseCase(dataSource);
  }
  
  FillAccountDataEventDataCarrier eventDataCarrier = FillAccountDataEventDataCarrier(
      phone: "",
      photo: File(""),
      photoUrl: ""
  );
  
  listenToEvents(){
    _eventListener = _eventStream.stream.distinct().listen((event) {
      if (event is UploadEvent){
        _upload(event.image);
      } else if (event is PhoneTypingEvent){
        _enterPhone(event.phone);
      } else if (event is DoneEvent){
        _fillAccountData();
      }
    });
  }

  upload(File image){
    _eventStream.add(UploadEvent(image));
  }

  enterPhone(String phone){
    _eventStream.add(PhoneTypingEvent(phone));
  }

  done(){
    _eventStream.add(DoneEvent());
  }

  _upload(File image) async {
    _updateViewState(viewState.value.copy(loading: true));
    var results = await _useCase.uploadImage(viewState.value, image);
    _updateViewState(results[0] as FillAccountDataViewState);
    resetViewState();
    eventDataCarrier = eventDataCarrier.copy(photo: image , photoUrl: results[1] as String);
  }
  
  _enterPhone(String phone){
    eventDataCarrier = eventDataCarrier.copy(phone: phone);
    var error = _validationUseCase.validatePhone(phone);
    _updateViewState(viewState.value.copy(phoneError: error));
  }
  
  _fillAccountData() async {
    if (viewState.value.phoneError != ValidationErrors.NONE){
      _updateViewState(viewState.value.copy(error: "Correct the inputs first"));
      resetViewState();
    }
    _updateViewState(viewState.value.copy(loading: true));
    _updateViewState(await _useCase.fillData(viewState.value, eventDataCarrier.phone , eventDataCarrier.photoUrl));
    resetViewState();
  }
  
  _updateViewState(FillAccountDataViewState newState){
    viewState.value = newState;
  }

  resetViewState(){
    viewState.value = viewState.value.copy(
        error: ""
    );
  }

}