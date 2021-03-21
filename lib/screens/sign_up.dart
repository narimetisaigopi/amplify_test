import 'package:amplify/bloc/internet_bloc.dart';
import 'package:amplify/bloc/sign_in_bloc.dart';
import 'package:amplify/screens/home_screen.dart';
import 'package:amplify/utilities/snacbar.dart';
import 'package:amplify/utilities/utilities.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class NewSignUpPage extends StatefulWidget {
  @override
  _NewSignUpPageState createState() => _NewSignUpPageState();
}

class _NewSignUpPageState extends State<NewSignUpPage> {
  int radioSelectedd = 1;
  int progress = 0;
  List<String> dropDownMenuItems = [
    "Once a day",
    "Once a week",
    "Once a month",
    "Once a year"
  ];
  String trainingTime;
  String gender = "Male";

  var formKey = GlobalKey<FormState>();
  bool signUpStarted = false;

  TextEditingController textEditingController = TextEditingController();

  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController2 =
      TextEditingController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool showPassword = true, showPassword2 = true;

  @override
  void initState() {
    trainingTime = dropDownMenuItems[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () {
            if (progress == 0) {
              Navigator.of(context).pop();
            } else {
              setState(() {
                progress = 0;
              });
            }
          },
          child: Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 24, right: 24),
            height: 60,
            width: double.infinity,
            color: Theme.of(context).backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SIGN UP".tr(),
                  style: textStyle.copyWith(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: buttonColor,
                          height: 3,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Container(
                          color: progress == 1 ? buttonColor : Colors.grey[700],
                          height: 3,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 32),
              child: progress == 0
                  ? ListView(shrinkWrap: true, children: [
                      Text(
                        "Whats your email address?".tr(),
                        style: textStyle.copyWith(
                            color: textFromColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          style: textStyle.copyWith(color: Colors.black),
                          controller: textEditingController,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.emailAddress,
                          validator: (str) => str != null
                              ? null
                              : "Enter Valid Email Address".tr(),
                          decoration: formTextFieldInputDecoration),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Whats your gender?".tr(),
                        style: textStyle.copyWith(
                            color: textFromColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   children: [
                      //     Flexible(
                      //       flex: 1,
                      //       child: RadioListTile(
                      //         controlAffinity: ListTileControlAffinity.trailing,
                      //         value: "Male".tr(),
                      //         dense: true,
                      //         groupValue: gender,
                      //         onChanged: (ind) => setState(() => gender = ind),
                      //         title: Text(
                      //           "Male".tr(),
                      //           style: textStyle.copyWith(color: Colors.black),
                      //         ),
                      //       ),
                      //     ),
                      //     Flexible(
                      //       flex: 1,
                      //       child: RadioListTile(
                      //         controlAffinity: ListTileControlAffinity.trailing,
                      //         value: "Female".tr(),
                      //         dense: true,
                      //         groupValue: gender,
                      //         onChanged: (ind) => setState(() => gender = ind),
                      //         title: Text(
                      //           "Female".tr(),
                      //           style: textStyle.copyWith(
                      //               color: Colors.black, fontSize: 14),
                      //         ),
                      //       ),
                      //     ),
                      //     Flexible(
                      //       flex: 1,
                      //       child: RadioListTile(
                      //         controlAffinity: ListTileControlAffinity.trailing,
                      //         value: "N/A".tr(),
                      //         dense: true,
                      //         groupValue: gender,
                      //         onChanged: (ind) => setState(() => gender = ind),
                      //         title: Text(
                      //           "N/A".tr(),
                      //           style: textStyle.copyWith(color: Colors.black),
                      //         ),
                      //       ),
                      //     ),

                      //   ],
                      // ),

                      Row(
                        children: [
                          Flexible(
                              fit: FlexFit.loose,
                              child: customRadio("Male", () {
                                setState(() {
                                  gender = "Male";
                                });
                              })),
                          Flexible(
                              fit: FlexFit.loose,
                              child: customRadio("Female", () {
                                setState(() {
                                  gender = "Female";
                                });
                              })),
                          Flexible(
                              fit: FlexFit.loose,
                              child: customRadio("N/A", () {
                                setState(() {
                                  gender = "N/A";
                                });
                              })),
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "How much do you train?".tr(),
                        style: textStyle.copyWith(
                            color: textFromColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: new BoxDecoration(
                            shape: BoxShape.rectangle, color: bgGreyColor),
                        child: DropdownButtonFormField(
                            dropdownColor: bgGreyColor,
                            hint: Text(
                              trainingTime,
                              style: textStyle.copyWith(color: Colors.black),
                            ).tr(),
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                            icon: Icon(Icons.arrow_drop_down_outlined),
                            items: dropDownMenuItems
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        e,
                                        style: textStyle.copyWith(
                                            color: Colors.black),
                                      ).tr(),
                                    ),
                                    value: e,
                                  ),
                                )
                                .toList(),
                            onChanged: (item) {
                              setState(() => trainingTime = item);
                            }),
                      )
                    ])
                  : Form(
                      key: formKey,
                      child: Column(
                        children: [
                          ListView(shrinkWrap: true, children: [
                            Text(
                              "Choose a password".tr(),
                              style: textStyle.copyWith(
                                  color: textFromColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                style: textStyle.copyWith(color: Colors.black),
                                obscureText: showPassword,
                                controller: passwordTextEditingController,
                                onChanged: (str) {
                                  formKey.currentState.validate();
                                },
                                validator: (str) {
                                  return liveValidation(str);
                                },
                                decoration:
                                    formTextFieldInputDecoration.copyWith(
                                        hintText: "Password".tr(),
                                        labelText: "Password".tr(),
                                        suffixIcon: IconButton(
                                            icon: !showPassword
                                                ? Icon(Icons.visibility)
                                                : Icon(Icons.visibility_off),
                                            onPressed: () => setState(() =>
                                                showPassword =
                                                    !showPassword)))),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                obscureText: showPassword2,
                                style: textStyle.copyWith(color: Colors.black),
                                controller: passwordTextEditingController2,
                                onChanged: (str) {
                                  formKey.currentState.validate();
                                },
                                validator: (str) {
                                  if (str != passwordTextEditingController.text)
                                    return "Both password should match".tr();
                                  else
                                    return null;
                                },
                                decoration:
                                    formTextFieldInputDecoration.copyWith(
                                        hintText: "Confirm Password".tr(),
                                        labelText: "Confirm password".tr(),
                                        suffixIcon: IconButton(
                                            icon: !showPassword2
                                                ? Icon(Icons.visibility)
                                                : Icon(Icons.visibility_off),
                                            onPressed: () => setState(() =>
                                                showPassword2 =
                                                    !showPassword2)))),
                          ]),
                        ],
                      )))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: signUpStarted
          ? CircularProgressIndicator()
          : myButton(progress == 0 ? "Next".tr() : "Continue".tr(), () {
              progress == 0 ? validateTheForm() : validateThePassword();
            }),
    );
  }

  customRadio(String text, Function tap) {
    return InkWell(
      onTap: tap,
      child: Row(
        children: [
          Text(text, style: textStyle.copyWith(color: Colors.black)),
          Radio(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = text;
              });
            },
            value: text,
          ),
        ],
      ),
    );
  }

  Future handleSignUpwithEmailPassword() async {
    final InternetBloc ib = Provider.of<InternetBloc>(context, listen: false);
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    await ib.checkInternet();
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      await ib.checkInternet();
      if (ib.hasInternet == false) {
        openSnacbar(_scaffoldKey, 'no internet'.tr());
      } else {
        setState(() {
          signUpStarted = true;
        });
        sb
            .signUpwithEmailPassword(gender, trainingTime,
                textEditingController.text, passwordTextEditingController.text)
            .then((_) async {
          if (sb.hasError == false) {
            sb.saveToFirebase().then((value) =>
                sb.saveDataToSP().then((value) => sb.setSignIn().then((value) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false);
                    })));
          } else {
            setState(() {
              signUpStarted = false;
            });
            openSnacbar(_scaffoldKey, sb.errorCode);
          }
        });
      }
    }
  }

  validateTheForm() {
    if (textEditingController.text == null) {
      openSnacbar(_scaffoldKey, "Email can't be empty".tr());
      return;
    }
    if (!textEditingController.text.contains("@")) {
      openSnacbar(_scaffoldKey, "Enter valid email".tr());
      return;
    }
    setState(() {
      progress = 1;
    });
  }

  String liveValidation(String password) {
    if (password == null) return "Password should not be empty".tr();
    if (password.length < 8) return "Password atleast 8 characters".tr();
    if (!password.contains(RegExp(r'[A-Z]')))
      return "should contains atleast captial letter".tr();
    if (!password.contains(RegExp(r'[a-z]')))
      return "should contains atleast small letter".tr();
    if (!password.contains(RegExp(r'[0-9]')))
      return "should contains atleast number letter".tr();

    return null;
  }

  validateThePassword() {
    if (formKey.currentState.validate()) {
      try {
        handleSignUpwithEmailPassword();
      } catch (e) {
        openSnacbar(_scaffoldKey, "sign up failed " + e.toString().tr());
      }
    }
    // if (passwordTextEditingController.text == null) {
    //   openSnacbar(_scaffoldKey, "Enter password".tr());
    // }
    // if (passwordTextEditingController2.text == null) {
    //   openSnacbar(_scaffoldKey, "Enter confirm password".tr());
    // }
    // if (passwordTextEditingController.text ==
    //     passwordTextEditingController2.text) {

    // } else {
    //   openSnacbar(_scaffoldKey, "Both passwords are not matched".tr());
    // }
  }
}
