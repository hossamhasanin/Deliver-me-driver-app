import 'dart:io';

import 'package:auth/business_logic/signup/fill_account_data/viewstate.dart';
import 'package:auth/business_logic/signup/register/register_viewstate.dart';
import 'package:auth/business_logic/signup/signup_datasource.dart';
import 'package:base/base.dart';

class FillAccountDataUseCase{
  final SignupDataSource _dataSource;

  FillAccountDataUseCase(this._dataSource);

  Future<FillAccountDataViewState> fillData(FillAccountDataViewState viewState , String phone , String imgUrl) async {
    try{
      await _dataSource.fillAccountData(phone , imgUrl);
      return viewState.copy(loading: false , done: true , error: "");
    }catch(e){
      print("koko sign up error : "+e.toString());
      return viewState.copy(error: e.toString() , loading: false);
    }
  }

  Future<List> uploadImage(FillAccountDataViewState viewState , File image) async {
    try{
      var imgUrl =  await _dataSource.upload(image);
      return [viewState.copy(loading: false , error: "" , showImage: true) , imgUrl];
    }catch(e){
      print("koko sign up error : "+e.toString());
      return [viewState.copy(error: e.toString() , loading: false) , ""];
    }
  }

}