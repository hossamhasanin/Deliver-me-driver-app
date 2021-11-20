import 'dart:async';

import 'package:auth/business_logic/signup/register/busuness_logic_events.dart';
import 'package:auth/business_logic/signup/register/register_controller.dart';
import 'package:auth/business_logic/validation_errors.dart';
import 'package:auth/ui/auth_screen/theme.dart';
import 'package:auth/ui/auth_screen/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeName = FocusNode();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController =
      TextEditingController();

  final RegisterController _controller = Get.find();

  BuildContext? dialogOverlayContext;

  StreamSubscription<BusinessLogicEvents>? businessLogicEventsListener;


  @override
  void dispose() {
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
    focusNodeEmail.dispose();
    focusNodeName.dispose();

    businessLogicEventsListener!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller.listenToEvents();

    businessLogicEventsListener = _controller.businessLogicEventStream.distinct().listen((event) {
      if (dialogOverlayContext != null){
        Navigator.pop(dialogOverlayContext!);
        dialogOverlayContext = null;
      }

      if (event is ShowLoadingDialog){
        dialogOverlayContext = Get.context;
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

      if (event is ShowErrorDialog){
        dialogOverlayContext = Get.overlayContext;
        showDialog(context: dialogOverlayContext!, builder: (_){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: SizedBox(
              height: 300.0,
              width: 300.0,
              child: Center(child: Text(_viewSignUpErrorMessage(event.error) ,
                  style: const TextStyle(fontWeight: FontWeight.bold , fontSize: 18.0))),
            ),
          );
        });
      }

      if (event is ShowDoneRegistrationDialog){
        dialogOverlayContext = Get.overlayContext;
        showDialog(context: dialogOverlayContext!, builder: (_){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: SizedBox(
              height: 300.0,
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Created account successfully , the activation email sent to you "
                      " activate the email then login please"),
                  const SizedBox(height: 20.0,),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.pop(dialogOverlayContext!);
                        dialogOverlayContext = null;
                      }, child: const Text("Done"))
                ],
              ),
            ),
          );
        } , barrierDismissible: false);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
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
                  height: 360.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                          child: Obx((){
                              return TextField(
                                focusNode: focusNodeName,
                                controller: signupNameController,
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
                                  hintText: 'Name',
                                  hintStyle: const TextStyle(
                                      fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
                                  errorText: _viewNameErrorMessage(_controller.viewState.value.nameError)
                                ),
                                onSubmitted: (_) {
                                  focusNodeEmail.requestFocus();
                                },
                                onChanged: (text){
                                  _controller.enterName(text);
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
                              top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                          child: Obx(() {
                              return TextField(
                                focusNode: focusNodeEmail,
                                controller: signupEmailController,
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                style: const TextStyle(
                                    fontFamily: 'WorkSansSemiBold',
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: const Icon(
                                    FontAwesomeIcons.envelope,
                                    color: Colors.black,
                                  ),
                                  hintText: 'Email Address',
                                  hintStyle: const TextStyle(
                                      fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
                                  errorText: _viewEmailErrorMessage(_controller.viewState.value.emailError)
                                ),
                                onSubmitted: (_) {
                                  focusNodePassword.requestFocus();
                                },
                                onChanged: (text){
                                  _controller.enterEmail(text);
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
                              top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                          child: Obx(() {
                              return TextField(
                                focusNode: focusNodePassword,
                                controller: signupPasswordController,
                                obscureText: _obscureTextPassword,
                                autocorrect: false,
                                style: const TextStyle(
                                    fontFamily: 'WorkSansSemiBold',
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: const Icon(
                                    FontAwesomeIcons.lock,
                                    color: Colors.black,
                                  ),
                                  hintText: 'Password',
                                  hintStyle: const TextStyle(
                                      fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
                                  errorText: _viewPasswordErrorMessage(_controller.viewState.value.passwordError),
                                  suffixIcon: GestureDetector(
                                    onTap: _toggleSignup,
                                    child: Icon(
                                      _obscureTextPassword
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                onSubmitted: (_) {
                                  focusNodeConfirmPassword.requestFocus();
                                },
                                onChanged: (text){
                                  _controller.enterPassword(text);
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
                              top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                          child: Obx((){
                              return TextField(
                                focusNode: focusNodeConfirmPassword,
                                controller: signupConfirmPasswordController,
                                obscureText: _obscureTextConfirmPassword,
                                autocorrect: false,
                                style: const TextStyle(
                                    fontFamily: 'WorkSansSemiBold',
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: const Icon(
                                    FontAwesomeIcons.lock,
                                    color: Colors.black,
                                  ),
                                  hintText: 'Confirmation',
                                  hintStyle: const TextStyle(
                                      fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
                                  errorText: _viewPasswordConfirmErrorMessage(_controller.viewState.value.passwordConfirmError),
                                  suffixIcon: GestureDetector(
                                    onTap: _toggleSignupConfirm,
                                    child: Icon(
                                      _obscureTextConfirmPassword
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                onChanged: (text){
                                  _controller.enterPasswordConfirm(text);
                                },
                                textInputAction: TextInputAction.go,
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 340.0),
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
                      'SIGN UP',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: 'WorkSansBold'),
                    ),
                  ),
                  onPressed: () {
                    _controller.register();
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  String? _viewEmailErrorMessage(ValidationErrors emailError){
    switch(emailError){
      case ValidationErrors.EMAIL_NOT_VALID :{
        return "Email not valid";
      }
      case ValidationErrors.EMAIL_EMPTY:{
        return "Email is empty";
      }
      default: {
        return null;
      }
    }
  }

  String? _viewNameErrorMessage(ValidationErrors nameError){
    switch(nameError){
      case ValidationErrors.NAME_EMPTY :{
        return "Name is empty";
      }
      default: {
        return null;
      }
    }
  }

  String? _viewPasswordErrorMessage(ValidationErrors passwordError){
    switch(passwordError){
      case ValidationErrors.PASSWORD_EMPTY :{
        return "Password is empty";
      }
      case ValidationErrors.PASSWORD_SHORT:{
        return "Password is short";
      }
      default: {
        return null;
      }
    }
  }

  String? _viewPasswordConfirmErrorMessage(ValidationErrors passwordConfirmError){
    switch(passwordConfirmError){
      case ValidationErrors.PASSWORDS_DIFFERENT :{
        return "Passwords doesn't match";
      }

      default: {
        return null;
      }
    }
  }

  String _viewSignUpErrorMessage(String errorCode){
    switch(errorCode){
      case "email-already-in-use":{
        return "Your email is already in use";
      }
      case "invalid-email":{
        return "This is not a valid email buddy";
      }
      case "operation-not-allowed":{
        return "Sorry for now signing up with email and password is not available";
      }
      case "weak-password":{
        return "Your password is very weak";
      }
      case "network-request-failed":{
        return "No internet";
      }
      case "invalid-inputs":{
        return "Correct the input errors first";
      }
      default:{
        throw "Error code not defined";
      }
    }
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }
}
