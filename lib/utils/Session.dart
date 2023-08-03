import 'dart:async';
import 'dart:math';

import 'package:cabira/utils/widget.dart';
import 'package:connectivity/connectivity.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'Demo_Localization.dart';
import 'colors.dart';
import 'constant.dart';

final String isLogin = appName + 'isLogin';

setPrefrenceBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

shadow() {
  return BoxDecoration(
    boxShadow: [
      BoxShadow(color: Color(0x1a0400ff), offset: Offset(0, 0), blurRadius: 30)
    ],
  );
}

placeHolder(double height) {
  return AssetImage(
    'assets/images/placeholder.png',
  );
}

erroWidget(double size) {
  return Image.asset(
    'assets/images/placeholder.png',
    height: size,
    width: size,
  );
}

errorWidget(double size) {
  return Icon(
    Icons.account_circle,
    color: Colors.grey,
    size: size,
  );
}

noIntImage() {
  return Image.asset(
    'assets/images/no_internet.svg',
    fit: BoxFit.contain,
    color: MyColorName.primaryDark,
  );
}

setSnackbar(String msg, BuildContext context) {
  /*ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    duration: Duration(seconds: 4),
    content: text(
      msg,
      isCentered: true,
      textColor: Colors.white,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: Colors.black,
    elevation: 1.0,
  ));*/
}

String imagePath = 'assets/images/';

noIntText(BuildContext context) {
  return Container(
      child: Text(getTranslated(context, 'NO_INTERNET')!,
          style: Theme.of(context).textTheme.headline5!.copyWith(
              color: MyColorName.primaryDark, fontWeight: FontWeight.normal)));
}

noIntDec(BuildContext context) {
  return Container(
    padding: EdgeInsetsDirectional.only(top: 30.0, start: 30.0, end: 30.0),
    child: Text(getTranslated(context, 'NO_INTERNET_DISC')!,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6!.copyWith(
              color: MyColorName.colorTextSecondary,
              fontWeight: FontWeight.normal,
            )),
  );
}

Widget showCircularProgress(bool _isProgress, Color color) {
  if (_isProgress) {
    return Center(
        child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(color),
    ));
  }
  return Container(
    height: 0.0,
    width: 0.0,
  );
}

imagePlaceHolder(double size, BuildContext context) {
  return new Container(
    height: size,
    width: size,
    child: Icon(
      Icons.account_circle,
      color: Colors.white,
      size: size,
    ),
  );
}

String? validateUserName(String value, String? msg1, String? msg2) {
  if (value.isEmpty) {
    return msg1;
  }
  if (value.length <= 1) {
    return msg2;
  }
  return null;
}

String? validateMob(String value, String? msg1, String? msg2) {
  if (value.isEmpty) {
    return msg1;
  }
  if (value.length != 10) {
    return msg2;
  }
  return null;
}

String? validateCountryCode(String value, String msg1, String msg2) {
  if (value.isEmpty) {
    return msg1;
  }
  if (value.length <= 0) {
    return msg2;
  }
  return null;
}

String? validatePass(String value, String? msg1, String? msg2) {
  if (value.length == 0)
    return msg1;
  else if (value.length <= 5)
    return msg2;
  else
    return null;
}

String? validateAltMob(String value, String? msg) {
  if (value.isNotEmpty) if (value.length < 9) {
    return msg;
  }
  return null;
}

String? validateField(String value, String? msg) {
  if (value.length == 0)
    return msg;
  else
    return null;
}

String? validatePincode(String value, String? msg1) {
  if (value.length == 0)
    return msg1;
  else
    return null;
}

String? validateEmail(String value, String? msg1, String? msg2) {
  if (value.length == 0) {
    return msg1;
  } else if (!RegExp(
          r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)"
          r"*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+"
          r"[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
      .hasMatch(value)) {
    return msg2;
  } else {
    return null;
  }
}

Widget getProgress() {
  return Center(child: CircularProgressIndicator());
}

Widget getNoItem(BuildContext context) {
  return Center(child: Text(getTranslated(context, 'noItem')!));
}

Future<Locale> setLocale(String languageCode1) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(languageCode, languageCode1);
  return _locale(languageCode1);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode1 = _prefs.getString(languageCode) ?? "en";
  return _locale(languageCode1);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case "en":
      return Locale("en", 'US');
    case "ne":
      return Locale("ne", 'NPL');
    default:
      return Locale("en", 'US');
  }
}

String? getTranslated(BuildContext context, String key) {
  return DemoLocalization.of(context)!.translate(key);
}

dialogAnimate(BuildContext context, Widget dialge) {
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(opacity: a1.value, child: dialge),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      // pageBuilder: null
      pageBuilder: (context, animation1, animation2) {
        return Container();
      } //as Widget Function(BuildContext, Animation<double>, Animation<double>)
      );
}

/*String getString(String name){
  String temp ="";
  if(name!=null&&name!=""){
    temp = name[0].toString().toUpperCase()  + name.toString().substring(1).toLowerCase();
  }else{
    temp ="No Data";
  }
  return temp;
}*/
String getString1(String name) {
  String temp = "";
  if (name != null && name != "") {
    temp = name[0].toString().toUpperCase() +
        name.toString().substring(1).toLowerCase();
  } else {
    temp = "No Data";
  }
  return temp;
}

String parseString(name) {
  String temp = "";
  if (name != null && name != "") {
    // temp = parse(name).body!.text.toString();
  } else {
    temp = "No Data";
  }
  return temp;
}

String getDate(date) {
  String temp = "";
  if (date != null && date != "") {
    temp = DateFormat.yMMMMEEEEd().format(DateTime.parse(date.toString()));
    temp += " " + DateFormat.jm().format(DateTime.parse(date.toString()));
  } else {
    temp = "Not Data";
  }
  return temp;
}

String getOrderTime(date) {
  if (date.toString().contains("pm")) {
    date = date.toString().replaceAll("pm", " PM");
  } else {
    date = date.toString().replaceAll("am", " AM");
  }
  DateTime parseDate = new DateFormat("dd-MM-yyyy hh:mm:ss a").parse(date);
  String temp = "";
  if (date != null && date != "") {
    temp = DateFormat.yMMMMEEEEd().format(parseDate) +
        "\n\n" +
        DateFormat('hh:mm a').format(parseDate);
  } else {
    temp = "Not Data";
  }
  return temp;
}

String getTimeDate(date) {
  String temp = "";
  if (date != null && date != "") {
    temp = DateFormat.MMMEd().format(DateTime.parse(date.toString()));
  } else {
    temp = "Not Data";
  }
  return temp;
}

String getDate1(date) {
  String temp = "";
  if (date != null && date != "") {
    temp = DateFormat.yMMMMEEEEd().format(DateTime.parse(date.toString())) +
        " at " +
        DateFormat.Hm().format(DateTime.parse(date.toString()));
  } else {
    temp = "Not Data";
  }
  return temp;
}

String getPercentage(price, disPrice) {
  String temp = "NULL";
  if (price != null && disPrice != null) {
    temp = (100 - (int.parse(disPrice) * 100) / int.parse(price)).toString();
  }
  return temp.split(".")[0] + "% OFF";
}

int parseInt(number) {
  int temp = 0;
  if (number != null) {
    temp = int.parse(number);
  }
  return temp;
}

String parseDouble(number) {
  String temp = "0";
  if (number != null) {
    temp = double.parse(number).toStringAsFixed(1);
  }
  return temp;
}

checkIf(value) {
  if (value != null && value != "" && value.toString() != "null") {
    return true;
  }
  return false;
}
