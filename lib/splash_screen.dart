import 'dart:async';

import 'package:cabira/Assets/assets.dart';
import 'package:cabira/Auth/Login/UI/login_page.dart';
import 'package:cabira/BookRide/search_location_page.dart';
import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:cabira/utils/widget.dart';
import 'package:cabira/welcome_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double value = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    determinateIndicator();
  }

  void determinateIndicator() {
    Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        if (value > 1) {
          print(value);
          timer.cancel();
          width = 80.w;
        } else {
          value = value + 0.05;
        }
      });
    });
  }

  double width = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              boxHeight(40),
              width == 0
                  ? Container(
                      width: getWidth(180),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          color: Colors.red,
                          minHeight: 10,
                          value: value,
                        ),
                      ),
                    )
                  : SizedBox(),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: width,
                height: 6.h,
                decoration: boxDecoration(
                    radius: 10, bgColor: Theme.of(context).primaryColor),
                child: Center(
                  child: text('your only way to "go"',
                      fontFamily: fontMedium,
                      fontSize: 20.sp,
                      textColor: Colors.white),
                ),
              ),
              boxHeight(100),
              Container(
                  height: getHeight(150),
                  width: getWidth(150),
                  child: Image.asset(
                    Assets.Logo,
                    fit: BoxFit.fill,
                  )),
              // AnimatedContainer(
              //   duration: Duration(milliseconds: 500),
              //   width: width,
              //   height: 6.h,
              //   decoration: boxDecoration(
              //       radius: 10, bgColor: Theme.of(context).primaryColor),
              //   child: Center(
              //     child: text("AlphaTaxi",
              //         fontFamily: fontMedium,
              //         fontSize: 28.sp,
              //         textColor: Colors.white),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
            horizontal: getWidth(10), vertical: getHeight(25)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            privacyPolicyLinkAndTermsOfService(),
            boxHeight(20),
            InkWell(
              onTap: () async {
                await App.init();
                if (App.localStorage.getString("userId") != null) {
                  curUserId = App.localStorage.getString("userId").toString();
                  /*  GetLocation location = new GetLocation((result){
        address = result.first.addressLine;
        latitude = result.first.coordinates.latitude;
        longitude = result.first.coordinates.longitude;
      });
      location.getLoc();*/
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchLocationPage()),
                      (route) => false);
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => WelComeScreen()));
                } else {
                  if (App.localStorage.getBool("first") != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WelComeScreen()));
                  }
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: width,
                height: 6.h,
                decoration: boxDecoration(radius: 10, bgColor: Colors.white),
                child: Center(
                  child: text("Continue",
                      fontFamily: fontMedium,
                      fontSize: 12.sp,
                      textColor: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text.rich(
          TextSpan(
              text: 'By continuing, you agree to our\n',
              style: TextStyle(fontSize: 16, color: Colors.white),
              children: <TextSpan>[
                TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff722BEA),
                      decorationColor: Color(0xff722BEA),
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // code to open / launch terms of service link here
                      }),
                TextSpan(
                    text: 'and ',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff722BEA),
                              decorationColor: Color(0xff722BEA),
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // code to open / launch privacy policy link here
                            })
                    ])
              ]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
