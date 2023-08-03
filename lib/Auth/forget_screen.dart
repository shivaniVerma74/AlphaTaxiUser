import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cabira/Auth/Login/UI/login_page.dart';
import 'package:cabira/Auth/Registration/UI/registration_page.dart';
import 'package:cabira/Auth/Registration/UI/registration_ui.dart';
import 'package:cabira/Auth/Verification/UI/verification_page.dart';
import 'package:cabira/Auth/login_navigator.dart';
import 'package:cabira/BookRide/search_location_page.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/colors.dart';
import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:cabira/utils/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cabira/Components/custom_button.dart';
import 'package:cabira/Components/entry_field.dart';
import 'package:cabira/Locale/strings_enum.dart';
import 'package:cabira/Locale/locale.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';


class ForgetScreen extends StatefulWidget {


  @override
  _ForgetScreenState createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final TextEditingController _numberController = TextEditingController();
  TextEditingController emailCon = new TextEditingController();
  TextEditingController passCon = new TextEditingController();
  String isoCode = '';

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: FadedSlideAnimation(
        SingleChildScrollView(
          child: Container(
            color: MyColorName.primaryLite,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(flex: 2),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                      getTranslated(context,'ENTER_YOUR')! +
                          '\n' +
                          getTranslated(context, "EMAIL")!,
                      style: theme.textTheme.headline4!.copyWith(fontSize: 20)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    "we'll send reset password link",
                    style: theme.textTheme.bodyText2!
                        .copyWith(color: theme.hintColor, fontSize: 12),
                  ),
                ),
                Spacer(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  color: theme.backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      EntryField(
                        controller: emailCon,
                        keyboardType: TextInputType.emailAddress,
                        label:getTranslated(context,'EMAIL_ADD'),
                      ),
                      Spacer(flex: 1),
                      InkWell(
                        onTap: () async {
                          /*if (_numberController.text == "" ||
                              _numberController.text.length != 10) {
                            setSnackbar(
                                "Please Enter Valid Mobile Number",
                                context);
                            return;
                          }*/
                          if(validateEmail(emailCon.text, getTranslated(context, "VALID_EMAIL")!,getTranslated(context, "VALID_EMAIL")!)!=null){
                            setSnackbar(validateEmail(emailCon.text, getTranslated(context, "VALID_EMAIL")!,getTranslated(context, "VALID_EMAIL")!).toString(), context);
                            return;
                          }
                          setState(() {
                            loading = true;
                          });
                          loginUser();
                        },
                        child: Container(
                          width: 75.w,
                          height: 6.h,
                          decoration: boxDecoration(
                              radius: 10,
                              bgColor: Theme.of(context).primaryColor),
                          child: Center(
                              child: !loading
                                  ?text(getTranslated(context, "SEND")!,
                                  fontFamily: fontMedium,
                                  fontSize: 12.sp,
                                  textColor: Colors.white):CircularProgressIndicator()),
                        ),
                      ),
                      Spacer(flex: 1),
                      Spacer(flex: 1),
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
                                  Center(child: CircularProgressIndicator())),*/
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
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
          "user_email": emailCon.text.trim().toString(),
          "pass": passCon.text.trim().toString(),
          "fcm_id": fcmToken.toString(),
        };
        Map response =
        await apiBase.postAPICall(Uri.parse(baseUrl + "forgotPassword"), data);
        print(response);
        bool status = true;
        String msg = response['message'];
        setState(() {
          loading = false;
        });
        setSnackbar(msg, context);
        if (response['status']) {

        } else {

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
        App.localStorage.setString("userId", response['data'][0]['id'].toString());
        curUserId = response['data'][0]['id'].toString();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> SearchLocationPage()), (route) => false);
      } else {
        navigateScreen(
            context, RegistrationUI("",myName,myEmail));
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
