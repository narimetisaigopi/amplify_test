import 'package:amplify/bloc/internet_bloc.dart';
import 'package:amplify/bloc/sign_in_bloc.dart';
import 'package:amplify/screens/home_screen.dart';
import 'package:amplify/screens/social_sign_up.dart';
import 'package:amplify/utilities/language.dart';
import 'package:amplify/utilities/snacbar.dart';
import 'package:amplify/utilities/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SignInPage extends StatefulWidget {
  final String tag;
  SignInPage({Key key, this.tag}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool offsecureText = true;
  Icon lockIcon = Icon(Icons.lock_outline);
  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();

  var formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool signInStart = false;
  bool signInComplete = false;
  String email;
  String pass;

  void lockPressed() {
    if (offsecureText == true) {
      setState(() {
        offsecureText = false;
        lockIcon = Icon(Icons.lock_outline);
      });
    } else {
      setState(() {
        offsecureText = true;
        lockIcon = Icon(Icons.lock_open);
      });
    }
  }

  handleSignInwithemailPassword() async {
    final InternetBloc ib = Provider.of<InternetBloc>(context, listen: false);
    await ib.checkInternet();

    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      FocusScope.of(context).requestFocus(new FocusNode());

      await ib.checkInternet();
      if (ib.hasInternet == false) {
        openSnacbar(_scaffoldKey, 'no internet'.tr());
      } else {
        setState(() {
          signInStart = true;
        });
        sb.signInwithEmailPassword(email, pass).then((_) async {
          if (sb.hasError == false) {
            sb.getUserDatafromFirebase(sb.uid).then((value) =>
                sb.saveDataToSP().then((value) => sb.setSignIn().then((value) {
                      setState(() {
                        signInComplete = true;
                      });
                      afterSignIn();
                    })));
          } else {
            setState(() {
              signInStart = false;
            });
            openSnacbar(_scaffoldKey, sb.errorCode);
          }
        });
      }
    }
  }

  afterSignIn() {
    if (widget.tag == null) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (cc) => HomeScreen()), (route) => false);
    } else {
      Navigator.pop(context);
    }
  }

  SignInBloc sb;

  @override
  Widget build(BuildContext context) {
    if (sb == null) sb = Provider.of<SignInBloc>(context, listen: false);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              alignment: Alignment.center,
              padding: EdgeInsets.all(0),
              iconSize: 22,
              icon: Icon(
                Icons.language,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (con) => LanguagePopup()));
              },
            ),
          ],
          // leading: InkWell(
          //   onTap: () {
          //     Navigator.of(context).pop();
          //   },
          //   child: Icon(
          //     Icons.arrow_back_ios_sharp,
          //     color: Colors.white,
          //   ),
          // ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                appLogo(),
                Container(
                  // height: textFieldheight,
                  child: TextFormField(
                    decoration: inputDecoration.copyWith(
                        labelText: "Username or Email address".tr(),
                        hintText: "Email".tr()),
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (String value) {
                      if (value.length == 0) return "Email can't be empty".tr();
                      if (!value.contains("@")) return "Enter valid email".tr();
                      return null;
                    },
                    onChanged: (String value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  // height: textFieldheight,
                  child: TextFormField(
                    obscureText: offsecureText,
                    controller: passCtrl,
                    textInputAction: TextInputAction.done,
                    decoration: inputDecoration.copyWith(
                        labelText: "Password".tr(),
                        hintText: "Enter Password".tr(),
                        suffixIcon: IconButton(
                            icon: lockIcon,
                            onPressed: () {
                              lockPressed();
                            })),
                    validator: (String value) {
                      if (value.length == 0)
                        return "Password can't be empty".tr();
                      return null;
                    },
                    onChanged: (String value) {
                      setState(() {
                        pass = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Forgotten Password?".tr(),
                    style: textStyle.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                signInStart
                    ? myCirleBar()
                    : Column(
                        children: [
                          myButton("LOG IN".tr(), () {
                            handleSignInwithemailPassword();
                          }),
                          SizedBox(
                            height: 30,
                          ),
                          myTextIconButton("Continue with Facebook".tr(), null,
                              Colors.white, "assets/icons/facebook.svg", () {
                            setState(() {
                              signInStart = true;
                            });
                            sb.handleFacebbokLogin(_scaffoldKey, context);
                            setState(() {
                              signInStart = false;
                            });
                          }),
                          myTextIconButton(
                              "Continue with Google".tr(),
                              null,
                              Colors.white,
                              "assets/icons/google.svg", () async {
                            setState(() {
                              signInStart = true;
                            });
                            await sb.handleGoogleSignIn(_scaffoldKey, context);
                            setState(() {
                              signInStart = false;
                            });
                          }),
                        ],
                      ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 0.5,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "don't have an account?".tr(),
                      style: textStyle.copyWith(color: Colors.white),
                    ).tr(),
                    TextButton(
                      child: Text('sign up'.tr(),
                              style: textStyle.copyWith(
                                  color: buttonColor,
                                  fontWeight: FontWeight.bold))
                          .tr(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => SocialSignUpScreen()));
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
