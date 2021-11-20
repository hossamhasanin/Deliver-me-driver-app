import 'dart:async';
import 'dart:io';

import 'package:auth/business_logic/signup/fill_account_data/busuness_logic_events.dart';
import 'package:auth/business_logic/signup/fill_account_data/controller.dart';
import 'package:auth/business_logic/signup/fill_account_data/viewstate.dart';
import 'package:auth/business_logic/validation_errors.dart';
import 'package:auth/ui/auth_screen/theme.dart';
import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FillAccountForm extends StatefulWidget {
  const FillAccountForm({Key? key}) : super(key: key);

  @override
  State<FillAccountForm> createState() => _FillAccountFormState();
}

class _FillAccountFormState extends State<FillAccountForm> {
  TextEditingController signupPhoneController = TextEditingController();

  final FillAccountDataController _controller = Get.find();

  BuildContext? dialogOverlayContext;

  StreamSubscription<FillAccountDataViewState>? _viewStateListener;

  StreamSubscription<BusinessLogicEvents>? businessLogicEventsListener;

  @override
  void initState() {
    super.initState();

    _controller.listenToEvents();

    businessLogicEventsListener = _controller.businessLogicEventsStream.distinct().listen((event) {
      if (dialogOverlayContext != null){
        Navigator.pop(dialogOverlayContext!);
        dialogOverlayContext = null;
      }

      if (event is ShowLoadingDialog){
        dialogOverlayContext = Get.overlayContext;
        showDialog(context: dialogOverlayContext!, builder: (_){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: SizedBox(
              height: 300.0,
              width: 300.0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: const [
                      Text("Wait ..."),
                      SizedBox(width: 10.0,),
                      CircularProgressIndicator()
                    ],
                  ),
                ),
              ),
            ),
          );
        } , barrierDismissible: false);
      }

      if (event is ShowDoneFillingDataDialog){
        dialogOverlayContext = Get.overlayContext;
        showDialog(context: dialogOverlayContext!, builder: (_){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              height: 300.0,
              width: 300.0,
              padding: const EdgeInsets.all(14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Saved successfully"),
                  const SizedBox(height: 20.0,),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.pop(dialogOverlayContext!);
                        Get.offNamed(MAP_SCREEN);
                        dialogOverlayContext = null;
                      }, child: const Text("Done"))
                ],
              ),
            ),
          );
        } , barrierDismissible: false);
      }

      if (event is ShowErrorDialog){
        showDialog(context: context, builder: (_){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              height: 300.0,
              width: 300.0,
              padding: const EdgeInsets.all(14.0),
              child: Center(
                child: Text(_viewServerErrorMessage(event.error) ,
                    style: const TextStyle(fontWeight: FontWeight.bold , fontSize: 18.0)),
              ),
            ),
          );
        });
      }
    });


  }
  @override
  void dispose() {
    businessLogicEventsListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 150.0,),
            const Text(
            'Finish profile',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontFamily: 'WorkSansBold'),
          ),
          const SizedBox(height: 50.0,),
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 230.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: Obx(() {
                            return TextField(
                              controller: signupPhoneController,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              autocorrect: false,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: const Icon(
                                    FontAwesomeIcons.user,
                                    color: Colors.black,
                                  ),
                                  hintText: 'Phone number',
                                  hintStyle: const TextStyle(
                                      fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
                                  errorText: _viewPhoneNumberError(_controller.viewState.value.phoneError)
                              ),
                              onChanged: (text){
                                _controller.enterPhone(text);
                              },
                            );
                          }
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Obx(() {
                                return CircleAvatar(
                                  child: _controller.viewState.value.showImage ?
                                     Container() : const Text("T"),
                                  backgroundColor: _controller.viewState.value.showImage ? null : Colors.blue,
                                  backgroundImage: _controller.viewState.value.showImage ? FileImage(_controller.eventDataCarrier.photo) : null,
                                  radius: 25.0,
                                );
                              }
                            ),
                            TextButton(
                                onPressed: () async {
                                  ImagePicker picker = ImagePicker();
                                  XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                  if (image != null) {
                                    _controller.upload(File(image.path));
                                  }
                                },
                                child: const Text("Upload")
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 210.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CustomTheme.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: CustomTheme.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: LinearGradient(
                      colors: <Color>[
                        CustomTheme.loginGradientEnd,
                        CustomTheme.loginGradientStart
                      ],
                      begin: FractionalOffset(0.2, 0.2),
                      end: FractionalOffset(1.0, 1.0),
                      stops: <double>[0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: CustomTheme.loginGradientEnd,
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: const Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      'DONE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: 'WorkSansBold'),
                    ),
                  ),
                  onPressed: (){
                    _controller.done();
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  String? _viewPhoneNumberError(ValidationErrors phoneError){
    switch(phoneError){
      case ValidationErrors.PHONE_NOT_VALID :{
        return "Phone is not valid";
      }
      case ValidationErrors.PHONE_EMPTY :{
        return "Phone number can't be left empty";
      }

      default: {
        return null;
      }
    }
  }

  String _viewServerErrorMessage(String errorCode){
    switch(errorCode){
      case "network-request-failed":{
        return "Sorry but no internet connection";
      }
      case "invalid-inputs":{
        return "Correct the input errors first";
      }
      default:{
        throw "Error code not defined";
      }
    }
  }

}
