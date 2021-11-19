import 'package:auth/ui/auth_screen/theme.dart';
import 'package:auth/ui/fill_account_data/components/fill_account_form.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: <Color>[
              CustomTheme.loginGradientStart,
              CustomTheme.loginGradientEnd
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 1.0),
            stops: <double>[0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: FillAccountForm(),
            ),
          ),
        ],
      ),
    );
  }
}
