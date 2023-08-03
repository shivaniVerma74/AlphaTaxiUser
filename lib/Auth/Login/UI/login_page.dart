import 'package:cabira/BookRide/search_location_page.dart';
import 'package:cabira/utils/PushNotificationService.dart';
import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:cabira/utils/location_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import '../../../utils/referCodeService.dart';
import '../../login_navigator.dart';
import 'login_interactor.dart';
import 'login_ui.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginInteractor {
  void listenDeepLinkData(BuildContext context) async {
    FlutterBranchSdk.initSession().listen((data) {
      //print("data"+data.toString());
      if (data['refer_code'] != null) {
        tempRefer = data['refer_code'];
      }
      //print("temp = $tempRefer");
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      //print('${platformException.code} - ${platformException.message}');
    });
    changePage();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PushNotificationService notificationService =
        new PushNotificationService(context: context, onResult: (result) {});
    notificationService.initialise();
    //listenDeepLinkData(context);
    changePage();
  }

  changePage() async {
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
          MaterialPageRoute(builder: (context) => SearchLocationPage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginUI(this);
  }

  @override
  void loginWithMobile(String isoCode, String mobileNumber) {
    Navigator.pushNamed(context, LoginRoutes.registration,
        arguments: isoCode + mobileNumber);
  }
}
