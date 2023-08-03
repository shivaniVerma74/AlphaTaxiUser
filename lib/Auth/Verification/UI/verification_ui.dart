import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cabira/Auth/AddMoney/UI/add_money_page.dart';
import 'package:cabira/Auth/login_navigator.dart';
import 'package:cabira/BookRide/search_location_page.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/colors.dart';
import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:cabira/utils/widget.dart';
import 'package:flutter/material.dart';
import 'package:cabira/Components/custom_button.dart';
import 'package:cabira/Components/entry_field.dart';
import 'package:cabira/Locale/strings_enum.dart';
import 'verification_interactor.dart';
import 'package:cabira/Locale/locale.dart';

class VerificationUI extends StatefulWidget {
  final VerificationInteractor verificationInteractor;
  String mobile, otp;

  VerificationUI(this.verificationInteractor, this.mobile, this.otp);

  @override
  _VerificationUIState createState() => _VerificationUIState();
}

class _VerificationUIState extends State<VerificationUI> {
  final TextEditingController _otpController = TextEditingController();
  String errorText = "";
  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 60,
        leading: Container(
          margin: EdgeInsets.all(5),
          decoration: boxDecoration(color: Colors.grey, radius: 100),
          child: Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(getWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "We've sent you on SMS with code to ${widget.otp}",
              style: theme.textTheme.headline4!
                  .copyWith(fontSize: 24, color: Colors.black),
            ),
            Text(
              "+91 ${widget.mobile}",
              style: theme.textTheme.headline4!
                  .copyWith(fontSize: 24, color: MyColorName.colorView),
            ),
            boxHeight(20),
            Container(
              width: getWidth(150),
              child: TextFormField(
                maxLength: 4,
                autofocus: true,
                controller: _otpController,
                keyboardType: TextInputType.phone,
                onChanged: (val) {
                  setState(() {
                    if (val.length > 3 && widget.otp != val) {
                      errorText = "Error Incorrect OTP";
                    } else {
                      if (val.length > 3) {
                        setState(() {
                          loading = true;
                        });
                        loginUser();
                      }
                      errorText = "";
                    }
                  });
                },
                onFieldSubmitted: (val) {},
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: MyColorName.primaryLite,
                    fontWeight: FontWeight.w500,
                    fontSize: 38.0),
                decoration: InputDecoration(
                    counterText: '',
                    hintText: 'XXXX',
                    errorText: errorText,
                    hintStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: MyColorName.primaryLite,
                        fontWeight: FontWeight.w500,
                        fontSize: 38.0),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: MyColorName.colorView, width: 2)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: MyColorName.colorView, width: 2))),
              ),
            ),
          ],
        ),
      ),
      /*bottomNavigationBar: !loading
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: getTranslated(context, 'NOT_RECEIVED'),
                        onTap: () =>
                            widget.verificationInteractor.notReceived(),
                        color: theme.scaffoldBackgroundColor,
                        textColor: theme.primaryColor,
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          if (_otpController.text == "" ||
                              _otpController.text.length != 4) {
                            setSnackbar("Please Enter Valid Otp", context);
                            return;
                          }
                          if (_otpController.text != widget.otp) {
                            setSnackbar("Wrong Otp", context);
                            return;
                          }
                          setState(() {
                            loading = true;
                          });
                          loginUser();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Container(
              width: 50, child: Center(child: CircularProgressIndicator())),*/
    );
  }

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool loading = false;
  loginUser() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "user_phone": widget.mobile.trim().toString(),
          "otp": widget.otp.toString(),
        };
        Map response =
            await apiBase.postAPICall(Uri.parse(baseUrl + "login"), data);
        print(response);
        bool status = true;
        String msg = response['message'];
        setState(() {
          loading = false;
        });

        if (response['status']) {
          App.localStorage
              .setString("userId", response['data']['id'].toString());
          curUserId = response['data']['id'].toString();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SearchLocationPage()),
              (route) => false);
        } else {
          setSnackbar(msg, context);
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, "WRONG")!, context);
        setState(() {
          loading = false;
        });
      }
    } else {
      setSnackbar(getTranslated(context, "NO_INTERNET")!, context);
      setState(() {
        loading = false;
      });
    }
  }
}
