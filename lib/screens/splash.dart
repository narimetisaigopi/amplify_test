import 'package:amplify/bloc/sign_in_bloc.dart';
import 'package:amplify/screens/sign_in.dart';
import 'package:amplify/utilities/utilities.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'home_screen.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  afterSplash() {
    final SignInBloc sb = context.read<SignInBloc>();
    Future.delayed(Duration(milliseconds: 1500)).then((value) {
      sb.isSignedIn == true ? gotoHomePage() : gotoSignInPage();
    });
  }

  gotoHomePage() {
    final SignInBloc sb = context.read<SignInBloc>();
    if (sb.isSignedIn == true) {
      sb.getDataFromSp();
    }
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (cc) => HomeScreen()), (route) => false);
  }

  gotoSignInPage() {
    Navigator.push(context, MaterialPageRoute(builder: (cc) => SignInPage()));
  }

  @override
  void initState() {
    afterSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _keyLoader,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(child: appLogo()));
  }
}
