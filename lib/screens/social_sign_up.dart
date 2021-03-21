import 'package:amplify/bloc/sign_in_bloc.dart';
import 'package:amplify/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'sign_up.dart';

class SocialSignUpScreen extends StatefulWidget {
  @override
  _SocialSignUpScreenState createState() => _SocialSignUpScreenState();
}

class _SocialSignUpScreenState extends State<SocialSignUpScreen> {
  SignInBloc sb;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool signInStart = false;

  @override
  Widget build(BuildContext context) {
    if (sb == null) sb = Provider.of<SignInBloc>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: backArrow(context),
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
        child: ListView(
          children: [
            appLogo(),
            Text(
              "GAIN BACK CONTROL \nOF YOUR LIFE".tr(),
              textAlign: TextAlign.center,
              style: textStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.white),
            ),
            SizedBox(
              height: 50,
            ),
            signInStart
                ? myCirleBar()
                : Column(
                    children: [
                      myButtonIcon("SIGN UP WITH FACEBOOK".tr(),
                          FontAwesomeIcons.facebook, () async {
                        setState(() {
                          signInStart = true;
                        });
                        await sb.handleFacebbokLogin(_scaffoldKey, context);
                        setState(() {
                          signInStart = false;
                        });
                      }, Color(0xff266ff1), Colors.white,
                          "assets/icons/facebook.svg"),
                      SizedBox(
                        height: 20,
                      ),
                      myButtonIcon(
                          "SIGN UP WITH GOOGLE".tr(), FontAwesomeIcons.google,
                          () async {
                        setState(() {
                          signInStart = true;
                        });
                        await sb.handleGoogleSignIn(_scaffoldKey, context);
                        setState(() {
                          signInStart = false;
                        });
                      }, Color(0xffffffff), Colors.black,
                          "assets/icons/google.svg"),
                    ],
                  ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              child: Text('Sign up with Email Address'.tr(), style: textStyle),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (cc) => NewSignUpPage()));
              },
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Already have an account?".tr(),
                  style: textStyle.copyWith(color: Colors.white),
                ),
                TextButton(
                  child: Text('sign in'.tr(),
                      style: textStyle.copyWith(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
