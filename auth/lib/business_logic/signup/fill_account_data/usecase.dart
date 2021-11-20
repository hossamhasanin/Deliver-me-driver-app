import 'dart:io';

import 'package:auth/business_logic/signup/fill_account_data/busuness_logic_events.dart';
import 'package:auth/business_logic/signup/fill_account_data/viewstate.dart';
import 'package:auth/business_logic/signup/register/register_viewstate.dart';
import 'package:auth/business_logic/signup/signup_datasource.dart';
import 'package:base/base.dart';

class FillAccountDataUseCase{
  final SignupDataSource _dataSource;

  FillAccountDataUseCase(this._dataSource);

  Future<BusinessLogicEvents> fillData(String phone , String imgUrl) async {
    try{
      await _dataSource.fillAccountData(phone , imgUrl);
      return ShowDoneFillingDataDialog();
    } on AuthException catch(e){
      print("koko sign up error : "+e.code);
      return ShowErrorDialog(e.code);
    }
  }

  Future<List> uploadImage(FillAccountDataViewState viewState , File image) async {
    try{
      var imgUrl =  await _dataSource.upload(image);
      return [DoneLoadingTheImageDialog() , imgUrl , viewState.copy(showImage: true)];
    } on AuthException catch(e){
      print("koko sign up error : "+e.code);
      return [ShowErrorDialog(e.code) , ""];
    }
  }

}