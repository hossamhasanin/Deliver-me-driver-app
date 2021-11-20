import 'dart:async';
import 'dart:io';

import 'package:auth/business_logic/signup/fill_account_data/busuness_logic_events.dart';
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
      showImage: false,
      phoneError: ValidationErrors.NONE
  ).obs;
  
  late final FillAccountDataUseCase _useCase;
  final InputsValidationUseCase _validationUseCase = InputsValidationUseCase();
  
  final StreamController<Event> _eventStream = StreamController.broadcast();
  final StreamController<BusinessLogicEvents> _businessLogicEvents = StreamController.broadcast();

  Stream<BusinessLogicEvents> get businessLogicEventsStream  => _businessLogicEvents.stream;

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
    _businessLogicEvents.add(ShowLoadingDialog());
    var results = await _useCase.uploadImage(viewState.value, image);
    _businessLogicEvents.add(results[0] as DoneLoadingTheImageDialog);
    eventDataCarrier = eventDataCarrier.copy(photo: image , photoUrl: results[1] as String);
    _updateViewState(results[2] as FillAccountDataViewState);
  }
  
  _enterPhone(String phone){
    eventDataCarrier = eventDataCarrier.copy(phone: phone);
    var error = _validationUseCase.validatePhone(phone);
    _updateViewState(viewState.value.copy(phoneError: error));
  }
  
  _fillAccountData() async {
    if (viewState.value.phoneError != ValidationErrors.NONE){
      _businessLogicEvents.add(const ShowErrorDialog("invalid-inputs"));
      return;
    }
    _businessLogicEvents.add(ShowLoadingDialog());
    _businessLogicEvents.add(await _useCase.fillData(eventDataCarrier.phone , eventDataCarrier.photoUrl));
  }
  
  _updateViewState(FillAccountDataViewState newState){
    viewState.value = newState;
  }

}