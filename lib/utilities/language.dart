import 'package:amplify/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguagePopup extends StatefulWidget {
  const LanguagePopup({Key key}) : super(key: key);

  @override
  _LanguagePopupState createState() => _LanguagePopupState();
}

class _LanguagePopupState extends State<LanguagePopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Choose Language",
          style: textStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: languages.length,
        itemBuilder: (BuildContext context, int index) {
          return _itemList(languages[index], index);
        },
      ),
    );
  }

  Widget _itemList(d, index) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.language,
            color: Colors.white,
          ),
          title: Text(d),
          onTap: () async {
            if (d == 'English') {
              context.locale = Locale('en');
            } else if (d == 'Arabic') {
              context.locale = Locale('ar');
            }

            Navigator.pop(context);
          },
        ),
        Divider(
          height: 3,
          color: Colors.grey[400],
        )
      ],
    );
  }
}
