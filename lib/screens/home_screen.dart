import 'package:amplify/bloc/sign_in_bloc.dart';
import 'package:amplify/bloc/theme_bloc.dart';
import 'package:amplify/screens/splash.dart';
import 'package:amplify/utilities/language.dart';
import 'package:amplify/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatelessWidget {
  SignInBloc sb;
  @override
  Widget build(BuildContext context) {
    sb = context.read<SignInBloc>();
    return Scaffold(
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
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              sb.email,
              style: textStyle.copyWith(fontSize: 24),
            ),
            SizedBox(
              height: 20,
            ),
            myButton("Logout", () {
              openLogoutDialog(context);
            })
          ],
        ),
      ),
    );
  }

  void openLogoutDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('logout title').tr(),
            actions: [
              TextButton(
                child: Text('no').tr(),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('yes').tr(),
                onPressed: () async {
                  Navigator.pop(context);
                  await context
                      .read<SignInBloc>()
                      .userSignout()
                      .then((value) =>
                          context.read<SignInBloc>().afterUserSignOut())
                      .then((value) {
                    if (context.read<ThemeBloc>().darkTheme == true) {
                      context.read<ThemeBloc>().toggleTheme();
                    }
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (contex) => SplashPage()),
                        (route) => false);
                  });
                },
              )
            ],
          );
        });
  }
}
