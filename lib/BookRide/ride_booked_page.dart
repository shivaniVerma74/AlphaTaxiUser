import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cabira/BookRide/finding_ride_page.dart';
import 'package:cabira/BookRide/map.dart';
import 'package:cabira/BookRide/search_location_page.dart';
import 'package:cabira/Model/my_ride_model.dart';
import 'package:cabira/Model/reason_model.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/PushNotificationService.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/colors.dart';
import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:cabira/utils/widget.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:cabira/Theme/style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'rate_ride_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class RideBookedPage extends StatefulWidget {
  MyRideModel model;
  bool from;
  RideBookedPage(this.model, {this.from = false});

  @override
  _RideBookedPageState createState() => _RideBookedPageState();
}

class _RideBookedPageState extends State<RideBookedPage> {
  bool isOpened = false;
  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool acceptStatus = false;
  List<ReasonModel> reasonList = [];
  bool change = false;

  getReason() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "type": "User",
        };
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "payment/cancel_ride_reason"), data);
        print(response);
        print(response);
        bool status = true;
        String msg = response['message'];
        setSnackbar(msg, context);
        if (response['status']) {
          for (var v in response['data']) {
            setState(() {
              reasonList.add(new ReasonModel.fromJson(v));
            });
          }
          //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> OfflinePage("")), (route) => false);
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, "WRONG")!, context);
      }
    } else {
      setSnackbar(getTranslated(context, "NO_INTERNET")!, context);
    }
  }

  String totalTime = "0".toString();
  String distance = "0".toString();
  getTime1(lat1, lon1, lat2, lon2) async {
    if (lat1 != "" &&
        lat1 != null &&
        lon1 != "" &&
        lon1 != null &&
        lat2 != "" &&
        lat2 != null &&
        lon2 != "" &&
        lon2 != null) {
      print("check1");
      http.Response response = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${lat1},${lon1}&destinations=${lat2},${lon2}&key=AIzaSyBRnd5Bpqec-SYN-wAYFECRw3OHd4vkfSA"));
      print(response.body);
      Map res = jsonDecode(response.body);
      List<dynamic> data = res['rows'][0]['elements'];
      //  String totalTime = "0 Mins".toString();
      if (response.body.contains("text")) {
        totalTime = (int.parse(data[0]['duration']['value'].toString()) / 60)
            .round()
            .toString();
        distance =
            (double.parse(data[0]['distance']['value'].toString()) / 1000)
                .toStringAsFixed(2);
      }
      print(totalTime);
      updateLocation(widget.model.bookingId.toString());
    } else {}
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    try {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    } on Exception catch (exception) {
      return 0; // only executed if error is of type Exception
    } catch (error) {
      return 0; // executed for errors of all types other than Exception
    }
  }

  updateLocation(
    String bookingId,
  ) async {
    await App.init();

    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "user_id": curUserId,
          "drop_address": widget.model.dropAddress,
          "booking_id": bookingId,
          "update_kilometer": widget.model.acceptReject == "6"
              ? calculateDistance(
                      double.parse(widget.model.latitude.toString()),
                      double.parse(widget.model.longitude.toString()),
                      driveLat,
                      driveLng)
                  .toStringAsFixed(2)
              : "0",
          "distance": distance,
          "drop_latitude": widget.model.dropLatitude,
          "drop_longitude": widget.model.dropLongitude,
          "taxi_id": widget.model.taxiId,
          "time": totalTime,
          "surge_amount": widget.model.surgeAmount,
        };
        print("this is our updated request **** ${data.toString()}");
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "Payment/update_change_location"), data);
        print(
            "this is new updated response &&&&& ^^^^^^ ${response.toString()}");
        print(response);
        setState(() {
          acceptStatus = false;
          change = false;
          loading = true;
        });
        bool status = true;
        String msg = response['message'];
        setSnackbar(msg, context);
        if (response['status']) {
          getCurrentInfo();
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, "WRONG")!, context);
      }
    } else {
      setSnackbar(getTranslated(context, "NO_INTERNET")!, context);
    }
  }

  cancelStatus(String bookingId, status1) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "user_id": curUserId,
          "accept_reject": "4",
          "booking_id": bookingId,
          "reason": reasonList[indexReason].reason,
        };
        print(
            "this is our request @@ ${data.toString()} and @@ ${baseUrl1}Payment/cancel_ride_point_to_point}");
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "Payment/cancel_ride_point_to_point"), data);
        print(response);
        print(response);
        setState(() {
          acceptStatus = false;
        });
        // bool status = true;
        String msg = response['message'];
        bool status = response['status'];
        setSnackbar(msg, context);
        if (status) {
          Navigator.pop(context);
          Navigator.pop(context);
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, "WRONG")!, context);
      }
    } else {
      setSnackbar(getTranslated(context, "NO_INTERNET")!, context);
    }
  }

  getCurrentInfo() async {
    try {
      Map params = {
        "user_id": curUserId,
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Payment/get_current_boooking"), params);
      setState(() {
        loading = false;
      });
      if (response['status']) {
        var v = response["data"];
        widget.model = MyRideModel.fromJson(v);
        /*Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RideBookedPage(MyRideModel.fromJson(v))));*/
        /* showConfirm(RidesModel(v['id'], v['user_id'], v['username'], v['uneaque_id'], v['purpose'], v['pickup_area'],
            v['pickup_date'], v['drop_area'], v['pickup_time'], v['area'], v['landmark'], v['pickup_address'], v['drop_address'],
            v['taxi_type'], v['departure_time'], v['departure_date'], v['return_date'], v['flight_number'], v['package'],
            v['promo_code'], v['distance'], v['amount'], v['paid_amount'], v['address'], v['transfer'], v['item_status'],
            v['transaction'], v['payment_media'], v['km'], v['timetype'], v['assigned_for'], v['is_paid_advance'], v['status'], v['latitude'], v['longitude'], v['date_added'],
            v['drop_latitude'], v['drop_longitude'], v['booking_type'], v['accept_reject'], v['created_date']));*/

        //print(data);
      } else {
        // setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, "WRONG")!, context);
      setState(() {
        change = true;
      });
    }
  }

  double lat = 0;
  double long = 0;
  @override
  void initState() {
    super.initState();
    PushNotificationService pushNotificationService =
        new PushNotificationService(
            context: context,
            onResult: (result) {
              //if(mounted&&result=="yes")
              print("result" + result);
              if (result == "com" || result == "cancel") {
                if (result == "cancel") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FindingRidePage(
                              LatLng(latitude, longitude),
                              LatLng(
                                  double.parse(
                                      widget.model.dropLatitude.toString()),
                                  double.parse(
                                      widget.model.dropLongitude.toString())),
                              widget.model.pickupAddress.toString(),
                              widget.model.dropAddress.toString(),
                              widget.model.paymentMedia.toString(),
                              widget.model.bookingId.toString(),
                              widget.model.amount.toString(),
                              widget.model.km.toString(),
                              from: true,
                            )),
                  );
                }
                if (result == "com") {
                  Navigator.pop(context, true);
                }
              } else {
                getCurrentInfo();
              }
            });
    pushNotificationService.initialise();
    getReason();
    /*  Future.delayed(Duration(seconds: 2), () {
        showDialog(context: context, builder: (context) => RateRideDialog(widget.model));
    });*/
  }

  int indexReason = 0;
  PersistentBottomSheetController? persistentBottomSheetController1;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  showBottom1() async {
    persistentBottomSheetController1 =
        await scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
        decoration:
            boxDecoration(radius: 0, showShadow: true, color: Colors.white),
        padding: EdgeInsets.all(getWidth(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "This charge is deducted from your wallet",
              style: TextStyle(color: Colors.red),
            ),
            boxHeight(20),
            text("${getTranslated(context, "SELECT_REASON")}",
                textColor: MyColorName.colorTextPrimary,
                fontSize: 12.sp,
                fontFamily: fontBold),
            boxHeight(20),
            reasonList.length > 0
                ? Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: reasonList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              persistentBottomSheetController1!.setState!(() {
                                indexReason = index;
                              });
                              // Navigator.pop(context);
                            },
                            child: Container(
                              color: indexReason == index
                                  ? MyColorName.primaryLite.withOpacity(0.2)
                                  : Colors.white,
                              padding: EdgeInsets.all(getWidth(10)),
                              child: text(reasonList[index].reason.toString(),
                                  textColor: MyColorName.colorTextPrimary,
                                  fontSize: 10.sp,
                                  fontFamily: fontMedium,
                                  isLongText: true),
                            ),
                          );
                        }),
                  )
                : SizedBox(),
            boxHeight(20),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: !acceptStatus
                      ? Container(
                          width: 35.w,
                          height: 5.h,
                          margin: EdgeInsets.all(getWidth(14)),
                          decoration: boxDecoration(
                              radius: 5,
                              bgColor: Theme.of(context).primaryColor),
                          child: Center(
                              child: text(getTranslated(context, "BACK")!,
                                  fontFamily: fontMedium,
                                  fontSize: 10.sp,
                                  isCentered: true,
                                  textColor: Colors.white)),
                        )
                      : CircularProgressIndicator(),
                ),
                boxWidth(10),
                InkWell(
                  onTap: () {
                    persistentBottomSheetController1!.setState!(() {
                      acceptStatus = true;
                    });
                    cancelStatus(widget.model.bookingId!, "5");
                  },
                  child: !acceptStatus
                      ? Container(
                          width: 35.w,
                          height: 5.h,
                          margin: EdgeInsets.all(getWidth(14)),
                          decoration: boxDecoration(
                              radius: 5,
                              bgColor: Theme.of(context).primaryColor),
                          child: Center(
                              child: text(getTranslated(context, "CONTINUE")!,
                                  fontFamily: fontMedium,
                                  fontSize: 10.sp,
                                  isCentered: true,
                                  textColor: Colors.white)),
                        )
                      : CircularProgressIndicator(),
                ),
              ],
            ),
            boxHeight(40),
          ],
        ),
      );
    });
  }

  DateTime? currentBackPressTime;
  Future<bool> onWill() async {
    DateTime now = DateTime.now();
    print("okay");
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      print("no");
      Common().toast("Press back again to exit");
      return Future.value(false);
    }
    exit(1);
    return Future.value();
  }

  final globalKey = new GlobalKey();
  bool loading1 = true;
  Future<String> capturePng(i, url) async {
    try {
      print('inside');
      RenderRepaintBoundary? boundary = globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      print(pngBytes);
      String dir = (await getApplicationSupportDirectory()).path;
      File? file = File(
          "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
      await file.writeAsBytes(pngBytes);
      setState(() {
        loading1 = true;
      });
      SocialShare.shareOptions("${url}", imagePath: file.path);
      return file.path;
    } catch (e) {
      print(e);
    }
    return "";
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: onWill,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        //  appBar: AppBar(),
        body: SafeArea(
          child: widget.model.latitude != null &&
                  widget.model.latitude != "" &&
                  !loading
              ? Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    !loading
                        ? MapPage(
                            true,
                            driveList: [],
                            live: true,
                            zoom: 16,
                            pick: widget.model.pickupAddress.toString(),
                            dest: widget.model.dropAddress.toString(),
                            model: widget.model.dropAddress == null ||
                                    widget.model.dropAddress == ""
                                ? widget.model
                                : null,
                            id: widget.model.driverId,
                            carType:
                                widget.model.taxiType == "Bike" ? "1" : "2",
                            status1: widget.model.acceptReject,
                            SOURCE_LOCATION: LatLng(
                                double.parse(widget.model.latitude!),
                                double.parse(widget.model.longitude!)),
                            DEST_LOCATION: LatLng(
                                double.parse(
                                    widget.model.dropLatitude.toString()),
                                double.parse(
                                    widget.model.dropLongitude.toString())),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                    /*!widget.from
                        ? Positioned(
                            top: 0,
                            left: 0,
                            child: widget.model.acceptReject == "1"
                                ? Container(
                                    padding: EdgeInsets.all(getWidth(10)),
                                    color: Colors.white,
                                    child: AnimatedTextKit(
                                      animatedTexts: [
                                        ColorizeAnimatedText(
                                          "${getTranslated(context, "PICKUP_TIME")} - ${((double.parse(widget.model.km!) / 25) * 60).round()} min",
                                          textStyle: colorizeTextStyle,
                                          colors: colorizeColors,
                                        ),
                                      ],
                                      pause: Duration(milliseconds: 100),
                                      isRepeatingAnimation: true,
                                      totalRepeatCount: 100,
                                      onTap: () {
                                        print("Tap Event");
                                      },
                                    ),
                                  )
                                : SizedBox(),
                          )
                        : SizedBox(),*/
                    !widget.from && widget.model.taxiId != null
                        ? Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 40.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /*InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlacePicker(
                                            apiKey: Platform.isAndroid
                                                ? "AIzaSyBRnd5Bpqec-SYN-wAYFECRw3OHd4vkfSA"
                                                : "AIzaSyBRnd5Bpqec-SYN-wAYFECRw3OHd4vkfSA",
                                            onPlacePicked: (result) {
                                              print(result.formattedAddress);
                                              setState(() {
                                                widget.model.dropAddress =
                                                    result.formattedAddress
                                                        .toString();
                                                widget.model.dropLatitude =
                                                    result
                                                        .geometry!.location.lat
                                                        .toString();
                                                widget.model.dropLongitude =
                                                    result
                                                        .geometry!.location.lng
                                                        .toString();
                                                change = true;
                                              });
                                              Navigator.of(context).pop();
                                              getTime1(
                                                  widget.model.latitude,
                                                  widget.model.longitude,
                                                  widget.model.dropLatitude,
                                                  widget.model.dropLongitude);
                                            },
                                            initialPosition: LatLng(
                                                double.parse(widget
                                                    .model.dropLatitude
                                                    .toString()),
                                                double.parse(widget
                                                    .model.dropLongitude
                                                    .toString())),
                                            //   useCurrentLocation: true,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 40.w,
                                      height: 5.h,
                                      margin: EdgeInsets.all(getWidth(5)),
                                      decoration: boxDecoration(
                                          radius: 5,
                                          bgColor:
                                              Theme.of(context).primaryColor),
                                      child: Center(
                                          child: !change
                                              ? text(
                                                  getTranslated(
                                                      context, "CHANGE_DROP")!,
                                                  fontFamily: fontMedium,
                                                  fontSize: 8.sp,
                                                  isCentered: true,
                                                  textColor: Colors.white)
                                              : CircularProgressIndicator(
                                                  color: Colors.white,
                                                )),
                                    ),
                                  ),*/
                                  boxHeight(10),
                                  widget.model.acceptReject != "3"
                                      ? InkWell(
                                          onTap: () {
                                            if (widget.model.acceptReject ==
                                                "6") {
                                              String url =
                                                  "https://www.google.com/maps/dir/?api=1&origin=${latitude.toString()},${longitude.toString()}&destination=${widget.model.dropLatitude},${widget.model.dropLongitude}&travel_mode=driving&dir_action=navigate";
                                              print(url);
                                              launch(url);
                                            } else {
                                              String url =
                                                  "https://www.google.com/maps/dir/?api=1&origin=${latitude.toString()},${longitude.toString()}&destination=${driveLat},${driveLng}&travel_mode=driving&dir_action=navigate";

                                              print(url);
                                              launch(url);
                                            }
                                          },
                                          child: Container(
                                            width: 40.w,
                                            height: 5.h,
                                            margin: EdgeInsets.all(getWidth(5)),
                                            decoration: boxDecoration(
                                                radius: 5,
                                                bgColor: Theme.of(context)
                                                    .primaryColor),
                                            child: Center(
                                                child: text("Track Location",
                                                    fontFamily: fontMedium,
                                                    fontSize: 10.sp,
                                                    isCentered: true,
                                                    textColor: Colors.white)),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    !widget.from
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Row(
                                children: [
                                  buildFlatButton(Icons.call, 'CALL_NOW', () {
                                    launch(
                                        "tel://${widget.model.driverContact}");
                                  }),
                                  SizedBox(width: 10),
                                  widget.model.acceptReject == "1"
                                      ? buildFlatButton(Icons.close, 'CANCEL',
                                          () {
                                          showBottom1();
                                        })
                                      : SizedBox(),
                                  SizedBox(width: 10),
                                  buildFlatButton(
                                      isOpened
                                          ? Icons.keyboard_arrow_down
                                          : Icons.keyboard_arrow_up,
                                      isOpened ? 'LESS' : 'MORE', () {
                                    setState(() {
                                      isOpened = !isOpened;
                                    });
                                  }),
                                ],
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ),
        bottomNavigationBar: !loading
            ? SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // !widget.from
                    //     ? Container(
                    //         padding: EdgeInsets.all(getWidth(10)),
                    //         color: Colors.white,
                    //         child: AnimatedTextKit(
                    //           animatedTexts: [
                    //             // ColorizeAnimatedText(
                    //             //   "Cancellation Charges ₹${widget.model.cancel_charge} is deducted from wallet.",
                    //             //   textStyle: colorizeTextStyle,
                    //             //   colors: colorizeColors,
                    //             // ),
                    //           ],
                    //           pause: Duration(milliseconds: 100),
                    //           isRepeatingAnimation: true,
                    //           totalRepeatCount: 100,
                    //           onTap: () {
                    //             print("Tap Event");
                    //           },
                    //         ),
                    //       )
                    //     : SizedBox(),

                    // Text("OTP : ${widget.model.otp.toString()}"),
                    ///
                    // Container(
                    //   padding: EdgeInsets.all(getWidth(10)),
                    //   color: Colors.white,
                    //   child: AnimatedTextKit(
                    //     animatedTexts: [
                    //       ColorizeAnimatedText(
                    //         "OTP : ${widget.model.otp}",
                    //         textStyle: colorizeTextStyle,
                    //         colors: colorizeColors,
                    //       ),
                    //     ],
                    //     pause: Duration(milliseconds: 100),
                    //     isRepeatingAnimation: true,
                    //     totalRepeatCount: 100,
                    //     onTap: () {
                    //       print("Tap Event");
                    //     },
                    //   ),
                    // ),
                    !widget.from
                        ? Container(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.model.acceptReject == "6"
                                      ? "Trip End OTP : ${widget.model.bookingOtp}"
                                      : "Start OTP : ${widget.model.bookingOtp}",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                                /*!widget.from
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            loading1 = false;
                                          });
                                          final dynamicLinkParams =
                                              DynamicLinkParameters(
                                            link: Uri.parse(
                                                "https://developmentalphawizz.com/ridex/?${widget.model.bookingId}"),
                                            uriPrefix:
                                                "https://sahayatri.page.link",
                                            androidParameters:
                                                const AndroidParameters(
                                                    packageName:
                                                        "com.alphataxi.user"),
                                            iosParameters: const IOSParameters(
                                                bundleId: "com.alphataxi.user"),
                                          );
                                          FirebaseDynamicLinks.instance
                                              .buildShortLink(dynamicLinkParams)
                                              .then((ShortDynamicLink value) {
                                            print(value.shortUrl);
                                            capturePng(0, value.shortUrl);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.share,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : SizedBox()*/
                              ],
                            ),
                          )
                        : SizedBox(),
                    RepaintBoundary(
                      key: globalKey,
                      child: GestureDetector(
                        onVerticalDragDown: (details) {
                          setState(() {
                            isOpened = !isOpened;
                          });
                        },
                        child: Container(
                          height: 100,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: isOpened
                                ? BorderRadius.circular(16)
                                : BorderRadius.vertical(
                                    top: Radius.circular(16)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imagePath +
                                        widget.model.driverImage.toString(),
                                    height: 72,
                                    width: 72,
                                  ),
                                ),
                              ),
                              SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.model.driverName}',
                                    style: theme.textTheme.headline6!.copyWith(
                                        fontSize: 18,
                                        letterSpacing: 1.2,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    '${getTranslated(context, "TRIP_ID")} - ${widget.model.uneaqueId.toString()}',
                                    style: theme.textTheme.bodyText1!
                                        .copyWith(color: Colors.black),
                                  ),
                                  Spacer(flex: 2),
                                  Text(
                                    '${widget.model.taxiType}(${widget.model.car_no})',
                                    style: theme.textTheme.caption!.copyWith(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                  /* Spacer(),
                              Text(
                                '${widget.model.car_no}',
                                style: theme.textTheme.bodyText1!
                                    .copyWith(fontSize: 13.5),
                              ),*/
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  widget.model.rating.toString() != "null"
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: AppTheme.ratingsColor,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                widget.model.rating.toString(),
                                                style: theme
                                                    .textTheme.bodyText1!
                                                    .copyWith(
                                                        fontSize: 12,
                                                        color: Colors.black),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(
                                                Icons.star,
                                                color: Colors.black,
                                                size: 10,
                                              )
                                            ],
                                          ),
                                        )
                                      : SizedBox(),
                                  Spacer(flex: 2),
                                  Text(
                                    getTranslated(context, 'CURRENT_STATUS')!,
                                    style: theme.textTheme.caption!
                                        .copyWith(color: Colors.black),
                                  ),
                                  Spacer(),
                                  Text(
                                    widget.model.acceptReject == "1"
                                        ? "Arriving"
                                        : widget.model.acceptReject == "6"
                                            ? "Started"
                                            : "Completed",
                                    style: theme.textTheme.bodyText1!.copyWith(
                                        fontSize: 13.5,
                                        color: widget.model.acceptReject == "1"
                                            ? Colors.orange
                                            : widget.model.acceptReject == "6"
                                                ? Colors.brown
                                                : Colors.green),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    isOpened ? Details(widget.model, widget.from) : SizedBox(),
                    /* AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 72,
                  color:
                  isOpened ? Colors.transparent : theme.backgroundColor,
                ),*/
                  ],
                ),
              )
            : SizedBox(),
      ),
    );
  }

  final colorizeColors = [
    MyColorName.colorView,
    MyColorName.colorView,
  ];

  final colorizeTextStyle = TextStyle(
    fontSize: 14.0,
    fontFamily: 'Horizon',
  );
  Widget buildFlatButton(IconData icon, String text, [Function? onTap]) {
    return Expanded(
      child: TextButton.icon(
        onPressed: onTap as void Function()? ?? () {},
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        icon: Icon(
          icon,
          size: 17,
          color: Colors.white,
        ),
        label: Text(
          getTranslated(context, text)!,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 13.5, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }
}

class Details extends StatefulWidget {
  MyRideModel model;
  bool from;
  Details(this.model, this.from);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: Column(
        children: [
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    getTranslated(context, 'RIDE_INFO')!,
                    style: theme.textTheme.headline6!
                        .copyWith(color: theme.hintColor, fontSize: 16.5),
                  ),
                  trailing: widget.model.km == null ||
                          widget.model.km == '' ||
                          widget.model.km == '0'
                      ? SizedBox.shrink()
                      : Text('${widget.model.km} km',
                          style: theme.textTheme.headline6!
                              .copyWith(fontSize: 16.5)),
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(
                    Icons.location_on,
                    color: theme.primaryColor,
                    size: 20,
                  ),
                  title: Text(
                    '${widget.model.pickupAddress}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                widget.model.dropAddress == null ||
                        widget.model.dropAddress == ''
                    ? SizedBox.shrink()
                    : ListTile(
                        horizontalTitleGap: 0,
                        leading: Icon(
                          Icons.navigation,
                          color: theme.primaryColor,
                          size: 20,
                        ),
                        title: Text(
                          '${widget.model.dropAddress}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(height: 12),
          !widget.from
              ? Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      widget.model.transaction == null ||
                              widget.model.transaction == ''
                          ? SizedBox.shrink()
                          : buildRowItem(
                              theme,
                              'PAYMENT_VIA',
                              '${widget.model.transaction}',
                              Icons.account_balance_wallet),
                      Spacer(),
                      buildRowItem(
                          theme,
                          'RIDE_FARE',
                          '₹ ${widget.model.amount}',
                          Icons.account_balance_wallet),
                      Spacer(),
                      buildRowItem(theme, 'RIDE_TYPE',
                          '${widget.model.bookingType}', Icons.drive_eta),
                    ],
                  ),
                )
              : SizedBox(),
          !widget.from && widget.model.acceptReject == "3"
              ? Container(
                  padding: EdgeInsets.all(getWidth(15)),
                  child: Column(
                    children: [
                      double.parse(widget.model.baseFare.toString()) > 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text(
                                    "${getTranslated(context, "BASE_FARE")} : ",
                                    fontSize: 10.sp,
                                    fontFamily: fontRegular,
                                    textColor: Colors.black),
                                text("₹" + widget.model.baseFare.toString(),
                                    fontSize: 10.sp,
                                    fontFamily: fontRegular,
                                    textColor: Colors.black),
                              ],
                            )
                          : SizedBox(),
                      double.parse(widget.model.km.toString()) >= 2 &&
                              double.parse(widget.model.ratePerKm.toString()) >
                                  0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text(
                                    "${widget.model.km.toString()} ${getTranslated(context, "KILOMETERS")} : ",
                                    fontSize: 10.sp,
                                    fontFamily: fontRegular,
                                    textColor: Colors.black),
                                text("₹" + widget.model.ratePerKm.toString(),
                                    fontSize: 10.sp,
                                    fontFamily: fontRegular,
                                    textColor: Colors.black),
                              ],
                            )
                          : SizedBox(),
                      double.parse(widget.model.timeAmount.toString()) > 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text(
                                    "${widget.model.totalTime.toString()} ${getTranslated(context, "MINUTES")} : ",
                                    fontSize: 10.sp,
                                    fontFamily: fontRegular,
                                    textColor: Colors.black),
                                text("₹" + widget.model.timeAmount.toString(),
                                    fontSize: 10.sp,
                                    fontFamily: fontRegular,
                                    textColor: Colors.black),
                              ],
                            )
                          : SizedBox(),
                      double.parse(widget.model.amount.toString()) > 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text(
                                    "${getTranslated(context, "SUB_TOTAL")} : ",
                                    fontSize: 10.sp,
                                    fontFamily: fontMedium,
                                    textColor: Colors.black),
                                text(
                                    "₹" +
                                        (double.parse(widget.model.amount
                                                    .toString()) +
                                                double.parse(widget
                                                    .model.promo_discount
                                                    .toString()) -
                                                double.parse(widget
                                                    .model.gstAmount
                                                    .toString()) -
                                                double.parse(widget
                                                    .model.surgeAmount
                                                    .toString()))
                                            .toStringAsFixed(2),
                                    fontSize: 10.sp,
                                    fontFamily: fontMedium,
                                    textColor: Colors.black),
                              ],
                            )
                          : SizedBox(),
                      double.parse(widget.model.gstAmount.toString()) > 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text("${getTranslated(context, "TAXES")} : ",
                                    fontSize: 10.sp,
                                    fontFamily: fontMedium,
                                    textColor: Colors.black),
                                text("₹" + widget.model.gstAmount.toString(),
                                    fontSize: 10.sp,
                                    fontFamily: fontMedium,
                                    textColor: Colors.black),
                              ],
                            )
                          : SizedBox(),
                      double.parse(widget.model.surgeAmount.toString()) > 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text("${getTranslated(context, "SURGE")} : ",
                                    fontSize: 10.sp,
                                    fontFamily: fontMedium,
                                    textColor: Colors.black),
                                text("₹" + widget.model.surgeAmount.toString(),
                                    fontSize: 10.sp,
                                    fontFamily: fontMedium,
                                    textColor: Colors.black),
                              ],
                            )
                          : SizedBox(),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text("${getTranslated(context, "TOTAL")} : ",
                              fontSize: 10.sp,
                              fontFamily: fontMedium,
                              textColor: Colors.black),
                          text("₹" + "${widget.model.amount}",
                              fontSize: 10.sp,
                              fontFamily: fontMedium,
                              textColor: Colors.black),
                        ],
                      ),
                      boxHeight(10),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Expanded buildRowItem(
      ThemeData theme, String title, String subtitle, IconData icon) {
    return Expanded(
      flex: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated(context, title)!,
            style: theme.textTheme.headline6!
                .copyWith(color: theme.hintColor, fontSize: 16),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                icon,
                color: theme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 6),
              Text(
                subtitle,
                style: theme.textTheme.headline6!.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
