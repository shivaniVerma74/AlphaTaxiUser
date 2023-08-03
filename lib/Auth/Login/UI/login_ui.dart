import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cabira/Auth/Login/UI/login_page.dart';
import 'package:cabira/Auth/Registration/UI/registration_page.dart';
import 'package:cabira/Auth/Registration/UI/registration_ui.dart';
import 'package:cabira/Auth/Verification/UI/verification_page.dart';
import 'package:cabira/Auth/forget_screen.dart';
import 'package:cabira/Auth/login_navigator.dart';
import 'package:cabira/BookRide/search_location_page.dart';
import 'package:cabira/generated/assets.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/colors.dart';
import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:cabira/utils/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cabira/Components/custom_button.dart';
import 'package:cabira/Components/entry_field.dart';
import 'package:cabira/Locale/strings_enum.dart';
import 'package:cabira/Locale/locale.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';
import 'login_interactor.dart';

class LoginUI extends StatefulWidget {
  final LoginInteractor loginInteractor;

  LoginUI(this.loginInteractor);

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final TextEditingController _numberController = TextEditingController();
  TextEditingController emailCon = new TextEditingController();
  TextEditingController passCon = new TextEditingController();
  String isoCode = '';
  bool otpOnOff = false;
  dynamic choose = "pass";
  bool obscure = true;
  bool agree = false;
  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(getWidth(15)),
          color: MyColorName.colorBg1,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              boxHeight(20),
              Text(
                "Enter your phone number to\nStart",
                style: theme.textTheme.headline4!
                    .copyWith(fontSize: 20, color: Colors.black),
              ),
              boxHeight(20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      height: getHeight(40),
                      decoration: boxDecoration(
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.all(getWidth(8)),
                      child: Row(
                        children: [
                          Image.asset(Assets.assetsImg1),
                          boxWidth(5),
                          Text(
                            "+91",
                            style: theme.textTheme.titleLarge!
                                .copyWith(fontSize: 20, color: Colors.black),
                          ),
                        ],
                      )),
                  boxWidth(10),
                  Expanded(
                    child: TextFormField(
                      maxLength: 10,
                      autofocus: true,
                      controller: _numberController,
                      keyboardType: TextInputType.phone,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: MyColorName.primaryLite,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                          ),
                      decoration: InputDecoration(
                          counterText: '',
                          labelText: 'Phone Number',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          labelStyle: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: MyColorName.colorView,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyColorName.colorView, width: 2)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyColorName.colorView, width: 2))),
                    ),
                  ),
                ],
              ),
              Spacer(),
              /*Container(
                height: MediaQuery.of(context).size.height * 0.7,
                color: theme.backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    // chooseType(),
                    // EntryField(
                    //   controller: emailCon,
                    //   keyboardType: TextInputType.emailAddress,
                    //   label: getTranslated(context,'EMAIL_ADD'),
                    // ),
                    EntryField(
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      controller: _numberController,
                      label: getTranslated(context, 'ENTER_PHONE'),
                    ),
                    EntryField(
                      //  initialValue: name.toString(),
                      controller: passCon,
                      keyboardType: TextInputType.visiblePassword,
                      label: getTranslated(context, "PASSWORD")!,
                      obscureText: obscure,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility : Icons.visibility_off,
                          color: MyColorName.primaryLite,
                        ),
                        onPressed: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            navigateScreen(context, ForgetScreen());
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5),
                            child: text(getTranslated(context, "FORGOT")!,
                                fontFamily: fontMedium,
                                fontSize: 12.sp,
                                textColor: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Spacer(flex: 1),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              // if(validateEmail(emailCon.text, getTranslated(context, "VALID_EMAIL")!,getTranslated(context, "VALID_EMAIL")!)!=null){
                              //   setSnackbar(validateEmail(emailCon.text, getTranslated(context, "VALID_EMAIL")!,getTranslated(context, "VALID_EMAIL")!).toString(), context);
                              //   return;
                              // }
                              if (_numberController.text == "" ||
                                  _numberController.text.length != 10) {
                                setSnackbar("Please Enter Valid Mobile Number",
                                    context);
                                return;
                              }
                              if (passCon.text == "" ||
                                  passCon.text.length < 8) {
                                setSnackbar(
                                    getTranslated(context, "ENTER_PASSWORD")!,
                                    context);
                                return;
                              }
                              setState(() {
                                loading = true;
                              });
                              loginUser();
                            },
                            child: Container(
                              width: 50.w - 30,
                              height: 6.h,
                              decoration: boxDecoration(
                                  radius: 10,
                                  bgColor: Theme.of(context).primaryColor),
                              child: Center(
                                  child: !loading
                                      ? text("LOGIN",
                                          // getTranslated(context, "CONTINUE")!,
                                          fontFamily: fontMedium,
                                          fontSize: 12.sp,
                                          textColor: Colors.white)
                                      : CircularProgressIndicator()),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              navigateScreen(
                                  context, RegistrationUI("", "", ""));
                            },
                            child: Container(
                              width: 50.w - 30,
                              height: 6.h,
                              decoration: boxDecoration(
                                  radius: 10,
                                  bgColor: Theme.of(context).primaryColor),
                              child: Center(
                                  child: !loading
                                      ? text("REGISTER",
                                          // getTranslated(context, "CONTINUE")!,
                                          fontFamily: fontMedium,
                                          fontSize: 12.sp,
                                          textColor: Colors.white)
                                      : CircularProgressIndicator()),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(flex: 1),
                    */
              /* Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            boxWidth(40),
                            Expanded(child: Divider()),
                            boxWidth(10),
                            text(getTranslated(context, "OR")!,
                                fontFamily: fontMedium,
                                fontSize: 12.sp,
                                textColor: Colors.black),
                            boxWidth(10),
                            Expanded(child: Divider()),
                            boxWidth(40),
                          ],
                        ),
                        Spacer(flex: 1),
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  loginFb();
                                },
                                child: Image.asset(
                                  "assets/fb.png",
                                  width: 8.h,
                                  height: 8.h,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              InkWell(
                                onTap: () {
                                  googleLogin();
                                },
                                child: Image.asset(
                                  "assets/google.png",
                                  width: 8.h,
                                  height: 8.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(flex: 1),*/
              /*
                    // InkWell(
                    //   onTap: (){
                    //     navigateScreen(
                    //         context, RegistrationUI("","",""));
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 5),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         text(getTranslated(context, "ACCOUNT")!,
                    //             fontFamily: fontMedium,
                    //             fontSize: 12.sp,
                    //             textColor: Colors.black),
                    //         text(getTranslated(context, "REGISTER")!,
                    //             fontFamily: fontMedium,
                    //             fontSize: 12.sp,
                    //             under: true,
                    //             textColor: Colors.black),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Spacer(flex: 1),
                    */
              /*      !loading
                          ? CustomButton(
                              onTap: () {
                                if (_numberController.text == "" ||
                                    _numberController.text.length != 10) {
                                  setSnackbar(
                                      "Please Enter Valid Mobile Number",
                                      context);
                                  return;
                                }
                                setState(() {
                                  loading = true;
                                });
                                loginUser();
                              },
                            )
                          : Container(
                              width: 50,
                              child:
                                  Center(child: CircularProgressIndicator())),*/ /*
                  ],
                ),
              ),*/
            ],
          ),
          //     : Column(
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
          //   children: [
          //     Spacer(flex: 2),
          //     Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 24),
          //       child: Text(
          //           getTranslated(context,'ENTER_YOUR')! +
          //               '\n' +
          //               "Mobile Number",
          //           style: theme.textTheme.headline4!.copyWith(fontSize: 20)),
          //     ),
          //     Spacer(),
          //     Container(
          //       height: MediaQuery.of(context).size.height * 0.7,
          //       color: theme.backgroundColor,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           Spacer(),
          //           chooseType(),
          //           EntryField(
          //             maxLength: 10,
          //             keyboardType: TextInputType.phone,
          //             controller: _numberController,
          //             label: getTranslated(context,'ENTER_PHONE'),
          //           ),
          //           Spacer(flex: 1),
          //           InkWell(
          //             onTap: () async {
          //                 if (_numberController.text == "" ||
          //                   _numberController.text.length != 10) {
          //                 setSnackbar("Please Enter Valid Mobile Number", context);
          //                 return;
          //                   }
          //                 setState(() {
          //                   loading = true;
          //                 });
          //                 loginWithMobile();
          //             },
          //             child: Container(
          //               width: 75.w,
          //               height: 6.h,
          //               decoration: boxDecoration(
          //                   radius: 10,
          //                   bgColor: Theme.of(context).primaryColor),
          //               child: Center(
          //                   child: !loading
          //                       ?text(getTranslated(context, "GET_OTP")!,
          //                       fontFamily: fontMedium,
          //                       fontSize: 12.sp,
          //                       textColor: Colors.white):CircularProgressIndicator()),
          //             ),
          //           ),
          //           Spacer(flex: 1),
          //           Row(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               boxWidth(40),
          //               Expanded(child: Divider()),
          //               boxWidth(10),
          //               text(getTranslated(context, "OR")!,
          //                   fontFamily: fontMedium,
          //                   fontSize: 12.sp,
          //                   textColor: Colors.black),
          //               boxWidth(10),
          //               Expanded(child: Divider()),
          //               boxWidth(40),
          //             ],
          //           ),
          //           Spacer(flex: 1),
          //           Container(
          //             child: Row(
          //               mainAxisSize: MainAxisSize.max,
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 InkWell(
          //                   onTap: () {
          //                     loginFb();
          //                   },
          //                   child: Image.asset(
          //                     "assets/fb.png",
          //                     width: 8.h,
          //                     height: 8.h,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: 5.w,
          //                 ),
          //                 InkWell(
          //                   onTap: () {
          //                     googleLogin();
          //                   },
          //                   child: Image.asset(
          //                     "assets/google.png",
          //                     width: 8.h,
          //                     height: 8.h,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Spacer(flex: 1),
          //           InkWell(
          //             onTap: (){
          //               navigateScreen(
          //                   context, RegistrationUI("","",""));
          //             },
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 5),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   text(getTranslated(context, "ACCOUNT")!,
          //                       fontFamily: fontMedium,
          //                       fontSize: 12.sp,
          //                       textColor: Colors.black),
          //                   text(getTranslated(context, "REGISTER")!,
          //                       fontFamily: fontMedium,
          //                       fontSize: 12.sp,
          //                       under: true,
          //                       textColor: Colors.black),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           Spacer(flex: 1),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  child: Checkbox(
                    value: agree,
                    activeColor: Color(0xff722BEA),
                    onChanged: (value) {
                      setState(() {
                        agree = value ?? false;
                      });
                    },
                  ),
                ),
                Text.rich(
                  TextSpan(
                      text: 'I agree to ',
                      style: TextStyle(fontSize: 16, color: Colors.black),
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
                      ]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            boxHeight(20),
            InkWell(
              onTap: () async {
                if (_numberController.text == "" ||
                    _numberController.text.length != 10) {
                  setSnackbar("Please Enter Valid Mobile Number", context);
                  return;
                }
                if (!agree) {
                  setSnackbar("Please accept terms and conditions", context);
                  return;
                }
                /*if (passCon.text == "" ||
                    passCon.text.length < 8) {
                  setSnackbar(
                      getTranslated(context, "ENTER_PASSWORD")!,
                      context);
                  return;
                }*/
                setState(() {
                  loading = true;
                });
                loginWithMobile();
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: 90.w,
                height: 6.h,
                decoration: boxDecoration(radius: 10, bgColor: Colors.black),
                child: Center(
                  child: !loading
                      ? text("Continue",
                          fontFamily: fontMedium,
                          fontSize: 12.sp,
                          textColor: Colors.white)
                      : CircularProgressIndicator(
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chooseType() {
    return Row(
      children: [
        Row(
          children: [
            Radio(
                value: "pass",
                groupValue: choose,
                onChanged: (val) {
                  setState(() {
                    choose = val;
                  });
                }),
            Text(getTranslated(context, "EMAIL")!),
          ],
        ),
        Row(
          children: [
            Radio(
                value: "otp",
                groupValue: choose,
                onChanged: (val) {
                  setState(() {
                    choose = val;
                    otpOnOff = true;
                  });
                }),
            Text(getTranslated(context, "MOBILE")!),
          ],
        )
      ],
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
        print("temp = $tempRefer");
        Map data;
        data = {
          "user_email": _numberController.text.toString(),
          "pass": passCon.text.trim().toString(),
          "fcm_id": fcmToken.toString(),
        };
        Map response =
            await apiBase.postAPICall(Uri.parse(baseUrl + "userlogin"), data);
        print(response);
        bool status = true;
        String msg = response['message'];
        setState(() {
          loading = false;
        });
        setSnackbar(msg, context);
        if (response['status']) {
          App.localStorage
              .setString("userId", response['data']['id'].toString());
          curUserId = response['data']['id'].toString();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SearchLocationPage()),
              (route) => false);
        } else {}
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

  loginWithMobile() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        print("temp = $tempRefer");
        Map data;
        data = {
          "user_phone": _numberController.text.trim().toString(),
          "fcm_id": fcmToken.toString(),
        };
        Map response =
            await apiBase.postAPICall(Uri.parse(baseUrl + "user_login"), data);
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
          print("OTP ==== ${response['data']['otp'].toString()}");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerificationPage(
                      _numberController.text.trim().toString(),
                      response['data']['otp'].toString())));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterPage(
                        _numberController.text.trim().toString(),
                      )));
          //    setSnackbar(msg, context);
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

  loginFb() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signOut();
      print("login out fun");
      UserCredential data = await signInWithFacebook();
      print("login fun");
      print(data.additionalUserInfo!.profile.toString());
      print(data.user!.uid);
      var newData = data.additionalUserInfo!.profile;
      String myName = newData!["given_name"].toString();
      String myEmail = newData["email"].toString();
      Map params = {
        "name": myName,
        "email": myEmail,
        "app_id": packageName,
        "google_login": "1",
      };
      var response = await apiBase.postAPICall(
          Uri.parse(baseUrl + "social_login"), params);
      setState(() {
        selected = !selected;
      });
      bool error = response["error"];
      String? msg = response["message"];
      setSnackbar("Google Login Successfully", context);
      if (!error) {
      } else {}
    } else {
      setSnackbar("No Internet", context);
    }
  }

  GoogleSignIn googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>[
      'email',
    ],
  );
  bool selected = true;
  googleLogin() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signOut();
      print("login out fun");
      UserCredential data = await signInWithGoogle();
      print("login fun");
      print(data.additionalUserInfo!.profile.toString());
      print(data.user!.uid);
      var newData = data.additionalUserInfo!.profile;
      String myName = newData!["given_name"].toString();
      String myEmail = newData["email"].toString();
      Map params = {
        "name": myName,
        "email": myEmail,
        "app_id": packageName,
        "google_login": "1",
      };
      var response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Authentication/social_login"), params);
      setState(() {
        selected = !selected;
      });
      bool error = response["status"];
      String? msg = response["message"];

      if (error) {
        setSnackbar("Google Login Successfully", context);
        App.localStorage
            .setString("userId", response['data'][0]['id'].toString());
        curUserId = response['data'][0]['id'].toString();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SearchLocationPage()),
            (route) => false);
      } else {
        navigateScreen(context, RegistrationUI("", myName, myEmail));
      }
    } else {
      setSnackbar("No Internet", context);
    }
  }

  final fbLogin = FacebookLogin();
  final _firebaseAuth = FirebaseAuth.instance;
  Future<UserCredential> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final userCredential = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken!.token),
        );
        return userCredential;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: response.error!.developerMessage!,
        );
      default:
        throw UnimplementedError();
    }
  }
/*   Future signInFB() async {
    final FacebookLoginResult result = await fbLogin.logIn(["email","public_profile"]);
    print(result.errorMessage);
    print(result.status);
    print(result.accessToken);
    final String token = result.accessToken!.token;
    final response = await     get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));
    final profile = jsonDecode(response.body);
    print(profile);
    return profile;
  }*/

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print(googleAuth?.idToken);
    // Once signed in, return the UserCredential
    var data = await FirebaseAuth.instance.signInWithCredential(credential);
    return data;
  }
}
