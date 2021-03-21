import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

Color buttonColor = Color(0xfff2d493);
Color bgGreyColor = Color(0xfff5f5f5);

Color textFromColor = Color(0xff292929);

double textFieldheight = 44;

final List<String> languages = ['English', 'Arabic'];

Widget myButton(String label, Function onPressed) {
  return Container(
    height: 42,
    width: 325,
    child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Text(
          label,
          style: textStyle.copyWith(
              fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
        ).tr(),
        color: buttonColor,
        onPressed: onPressed),
  );
}

Widget backArrow(BuildContext buildContext) {
  return AppBar(
    backgroundColor: Colors.black,
    leading: InkWell(
      onTap: () {
        Navigator.of(buildContext).pop();
      },
      child: Icon(
        Icons.arrow_back_ios_sharp,
        color: Colors.white,
      ),
    ),
  );
}

Widget myButtonIcon(String label, IconData icon, Function onPressed,
    Color bgcolor, Color textcolor, String svgPath) {
  return Container(
    height: 42,
    width: double.infinity,
    child: RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      onPressed: onPressed,
      color: bgcolor,
      child: myTextIconButton(label, null, textcolor, svgPath, null,
          textbold: true),
    ),
  );
}

Widget myTextIconButton(String label, IconData icon, Color textcolor,
    String assetPath, Function onPressed,
    {bool textbold = false}) {
  return TextButton.icon(
      onPressed: onPressed,
      icon: icon != null
          ? Icon(icon)
          : SvgPicture.asset(
              assetPath,
              height: 16,
              width: 16,
            ),
      label: Text(
        label,
        style: textStyle.copyWith(
            fontSize: 14,
            color: textcolor,
            fontWeight: textbold ? FontWeight.bold : FontWeight.normal),
      ).tr());
}

InputDecoration inputDecoration = InputDecoration(
  hintStyle: textStyle.copyWith(color: Colors.white),
  labelStyle: textStyle.copyWith(color: Colors.white),
  fillColor: Colors.white,
  focusColor: Colors.white,
  border: new OutlineInputBorder(
      borderSide: new BorderSide(
        color: bgGreyColor,
      ),
      borderRadius: BorderRadius.all(
        const Radius.circular(10.0),
      )),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: bgGreyColor, width: 1),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: bgGreyColor, width: 1),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: bgGreyColor, width: 1),
  ),
);

TextStyle textStyle = TextStyle(
    color: buttonColor,
    fontSize: 14,
    letterSpacing: 1,
    fontStyle: FontStyle.normal,
    fontFamily: "Poppins-Regular",
    fontWeight: FontWeight.normal);

Widget appLogo() {
  return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Image.asset("assets/icons/logo.png"));
}

InputDecoration formTextFieldInputDecoration = inputDecoration.copyWith(
  labelText: "Email".tr(),
  hintText: "Email".tr(),
  hintStyle: textStyle.copyWith(color: Colors.black, fontSize: 14),
  labelStyle: textStyle.copyWith(color: Colors.black, fontSize: 14),
  fillColor: bgGreyColor,
  filled: true,
  border: new OutlineInputBorder(
    borderSide: new BorderSide(color: Colors.green, width: 5),
    borderRadius: BorderRadius.circular(12),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 0.3),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 0.3),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 0.3),
  ),
);

Widget myCirleBar() {
  return SizedBox(
    child: CircularProgressIndicator(),
    height: 10.0,
    width: 10.0,
  );
}

saveSelectedLanguage(String str) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("lang", str);
}

Future<String> getSelectedLanguage() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("lang") ?? "en";
}
