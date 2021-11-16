import 'dart:async';

import 'package:auth/business_logic/login/controller.dart';
import 'package:auth/business_logic/login/viewstate.dart';
import 'package:auth/business_logic/validation_errors.dart';
import 'package:auth/ui/auth_screen/theme.dart';
import 'package:auth/ui/auth_screen/widgets/snackbar.dart';
import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  bool _obscureTextPassword = true;

  final LoginController _controller = Get.find();

  BuildContext? dialogOverlayContext;

  StreamSubscription<LoginViewState>? viewStateListener;

  @override
  void dispose() {
    focusNodeEmail.dispose();
    focusNodePassword.dispose();

    viewStateListener!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller.listenToEvents();

    viewStateListener = _controller.viewState.stream.distinct().listen((viewstate) {
      if (viewstate.successfulLogin){
        dialogOverlayContext = Get.overlayContext;
        showDialog(context: dialogOverlayContext!, builder: (_){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: SizedBox(
              height: 300.0,
              width: 300.0,
              child: Column(
                children: [
                  const Text("Login successfully"),
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

      if (viewstate.loading){
        dialogOverlayContext = Get.overlayContext;
        showDialog(context: dialogOverlayContext!, builder: (_){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: SizedBox(
              height: 300.0,
              width: 300.0,
              child: Row(
                children: const [
                  Text("Wait ..."),
                  SizedBox(width: 10.0,),
                  CircularProgressIndicator()
                ],
              ),
            ),
          );
        } , barrierDismissible: false);
      } else {
        if (dialogOverlayContext != null){
          Navigator.pop(dialogOverlayContext!);
        }
      }

      if (viewstate.error != ""){
        showDialog(context: context, builder: (_){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: SizedBox(
              height: 300.0,
              width: 300.0,
              child: Text(viewstate.error),
            ),
          );
        });
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
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: Obx(() {
                            return TextField(
                              focusNode: focusNodeEmail,
                              controller: loginEmailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: const Icon(
                                  FontAwesomeIcons.envelope,
                                  color: Colors.black,
                                  size: 22.0,
                                ),
                                hintText: 'Email Address',
                                hintStyle: const TextStyle(
                                    fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
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
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: Obx((){
                            return TextField(
                              focusNode: focusNodePassword,
                              controller: loginPasswordController,
                              obscureText: _obscureTextPassword,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: const Icon(
                                  FontAwesomeIcons.lock,
                                  size: 22.0,
                                  color: Colors.black,
                                ),
                                hintText: 'Password',
                                hintStyle: const TextStyle(
                                    fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleLogin,
                                  child: Icon(
                                    _obscureTextPassword
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 15.0,
                                    color: Colors.black,
                                  ),
                                ),
                                
                                errorText: _viewPasswordErrorMessage(_controller.viewState.value.passwordError)
                              ),
                              onSubmitted: (_) {
                                _toggleSignInButton();
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
              Container(
                margin: const EdgeInsets.only(top: 170.0),
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
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: 'WorkSansBold'),
                    ),
                  ),
                  onPressed: () {
                    _controller.login();
                  }),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansMedium'),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 1.0),
                        stops: <double>[0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    'Or',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansMedium'),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 1.0),
                        stops: <double>[0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 40.0),
                child: GestureDetector(
                  onTap: () => CustomSnackBar(
                      context, const Text('Facebook button pressed')),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.facebookF,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () => CustomSnackBar(
                      context, const Text('Google button pressed')),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.google,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleSignInButton() {
    CustomSnackBar(context, const Text('Login button pressed'));
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
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

  String? _viewPasswordErrorMessage(ValidationErrors passwordError){
    switch(passwordError){
      case ValidationErrors.PASSWORD_SHORT :{
        return "Password is short";
      }
      case ValidationErrors.PASSWORD_EMPTY:{
        return "Password is empty";
      }
      default: {
        return null;
      }
    }
  }
}
