import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cabira/BookRide/map.dart';
import 'package:cabira/BookRide/rate_ride_dialog.dart';
import 'package:cabira/BookRide/search_location_page.dart';
import 'package:cabira/Components/row_item.dart';
import 'package:cabira/Model/my_ride_model.dart';
import 'package:cabira/Model/reason_model.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/PushNotificationService.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/colors.dart';
import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:cabira/utils/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cabira/Assets/assets.dart';
import 'package:cabira/Components/background_image.dart';
import 'package:cabira/Locale/strings_enum.dart';
import 'package:cabira/Theme/style.dart';
import 'package:cabira/Locale/locale.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

class RideInfoPage extends StatefulWidget {
  MyRideModel model;
  String? check;
  RideInfoPage(this.model, {this.check});

  @override
  State<RideInfoPage> createState() => _RideInfoPageState();
}

class _RideInfoPageState extends State<RideInfoPage> {
  bool showMore = false;
  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool acceptStatus = false;
  String totalTime = "0".toString();
  bool change = false;

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
          "distance": calculateDistance(
                  double.parse(widget.model.latitude.toString()),
                  double.parse(widget.model.longitude.toString()),
                  double.parse(widget.model.dropLatitude.toString()),
                  double.parse(widget.model.dropLongitude.toString()))
              .toStringAsFixed(2),
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
        });
        bool status = true;
        String msg = response['message'];
        setSnackbar(msg, context);
        if (response['status']) {
          Navigator.pop(context, true);
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, "WRONG")!, context);
      }
    } else {
      setSnackbar(getTranslated(context, "NO_INTERNET")!, context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.check != null) {
      showMore = true;
    }
    PushNotificationService pushNotificationService =
        new PushNotificationService(
            context: context,
            onResult: (result) {
              //if(mounted&&result=="yes")
              print("result" + result);
              if (result == "com" || result == "cancel") {
                if (result == "com") {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => RateRideDialog(widget.model));
                }
              } else {
                Navigator.pop(context, true);
              }
            });
    pushNotificationService.initialise();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        /* floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: (){

            },
            child: Icon(Icons.share,color: Colors.white,),
          ),*/
        body: widget.check == null
            ? SafeArea(
                child: widget.model.latitude != null &&
                        widget.model.latitude != ""
                    ? Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          MapPage(
                            true,
                            live: false,
                            pick: widget.model.pickupAddress.toString(),
                            dest: widget.model.dropAddress.toString(),
                            driveList: [],
                            SOURCE_LOCATION: LatLng(
                                double.parse(widget.model.latitude!),
                                double.parse(widget.model.longitude!)),
                            DEST_LOCATION: LatLng(
                                double.parse(
                                    widget.model.dropLatitude.toString()),
                                double.parse(
                                    widget.model.dropLongitude.toString())),
                          ),
                          /*!widget.model.bookingType!.contains("Point") &&
                                    widget.model.acceptReject != "3" &&
                                    widget.model.taxiId != null
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
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
                                              useCurrentLocation: true,
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
                                    ),
                                  )
                                : SizedBox(),*/

                          widget.model.acceptReject != "3"
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.model.acceptReject == "6") {
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
                                  ),
                                )
                              : SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              !widget.model.bookingType!.contains("Point") &&
                                      widget.model.driverId != null
                                  ? InkWell(
                                      onTap: () {
                                        launch(
                                            "tel://${widget.model.driverContact}");
                                      },
                                      child: Container(
                                        width: 20.w,
                                        height: 4.h,
                                        margin: EdgeInsets.all(getWidth(5)),
                                        decoration: boxDecoration(
                                            radius: 5,
                                            bgColor:
                                                Theme.of(context).primaryColor),
                                        child: Center(
                                            child: text(
                                                getTranslated(context, "CALL")!,
                                                fontFamily: fontMedium,
                                                fontSize: 8.sp,
                                                isCentered: true,
                                                textColor: Colors.white)),
                                      ),
                                    )
                                  : SizedBox(),
                              boxWidth(20),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    showMore = !showMore;
                                  });
                                },
                                child: Container(
                                  width: 20.w,
                                  height: 4.h,
                                  margin: EdgeInsets.all(getWidth(5)),
                                  decoration: boxDecoration(
                                      radius: 5,
                                      bgColor: Theme.of(context).primaryColor),
                                  child: Center(
                                      child: text(
                                          !showMore ? "View More" : "View Less",
                                          fontFamily: fontMedium,
                                          fontSize: 8.sp,
                                          isCentered: true,
                                          textColor: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : SizedBox(),
              )
            : SizedBox(),
        bottomNavigationBar: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            height: widget.check != null
                ? MediaQuery.of(context).size.height
                : null,
            child: Column(
              mainAxisSize:
                  widget.check != null ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: widget.check != null
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                /*  widget.model.promo_discount!=null&&widget.model.promo_discount!=""&&widget.model.promo_discount!="0"?AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        "Promo Discount - ₹${widget.model.promo_discount}",
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
                  ):SizedBox(),*/
                widget.model.acceptReject == "1"
                    ? Container(
                        padding: EdgeInsets.all(getWidth(10)),
                        color: Colors.white,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            ColorizeAnimatedText(
                              "Cancellation Charge ₹${widget.model.cancel_charge} is deducted from wallet.",
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
                Text(
                  widget.model.acceptReject == "6"
                      ? "Trip End OTP : ${widget.model.bookingOtp}"
                      : "Start OTP : ${widget.model.bookingOtp}",
                  style: TextStyle(color: Colors.black),
                ),
                // Text("OTP : ${widget.model.otp.toString()}"),
                Container(
                  height: 100,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      widget.model.driverName != null
                          ? Container(
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
                            )
                          : SizedBox(),
                      SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.model.driverName != null
                              ? Text(
                                  '${widget.model.driverName}',
                                  style: theme.textTheme.headline6!.copyWith(
                                      fontSize: 18,
                                      letterSpacing: 1.2,
                                      color: Colors.black),
                                )
                              : SizedBox(),
                          Text(
                            '${getTranslated(context, "TRIP_ID")} - ${widget.model.uneaqueId.toString()}',
                            style: theme.textTheme.bodyText1!
                                .copyWith(color: Colors.black),
                          ),
                          /* Text(
                              '${widget.model.taxiType}',
                              style:
                              theme.textTheme.caption!.copyWith(fontSize: 12),
                            ),*/
                          Spacer(flex: 2),
                          Text(
                            getTranslated(context, "CAR_TYPE")!,
                            style: theme.textTheme.caption!
                                .copyWith(color: Colors.black),
                          ),
                          Spacer(),
                          Text(
                            '${widget.model.taxiType}',
                            style: theme.textTheme.bodyText1!
                                .copyWith(fontSize: 12, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      // Spacer(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            widget.model.rating.toString() != "null"
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: AppTheme.ratingsColor,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${widget.model.rating}',
                                          style: theme.textTheme.bodyText1!
                                              .copyWith(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.star,
                                          color: AppTheme.starColor,
                                          size: 10,
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            Spacer(flex: 2),
                            Text(
                              getTranslated(context, 'BOOKED_ON')!,
                              style: theme.textTheme.caption!
                                  .copyWith(color: Colors.black),
                            ),
                            Spacer(),
                            Text(
                              '${getDate(widget.model.dateAdded)}',
                              style: theme.textTheme.bodyText1!
                                  .copyWith(fontSize: 12, color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                showMore
                    ? Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: theme.backgroundColor,
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    getTranslated(context, 'RIDE_INFO')!,
                                    style: theme.textTheme.headline6!.copyWith(
                                        color: theme.hintColor, fontSize: 16.5),
                                  ),
                                  trailing: Text('${widget.model.km} km',
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                ListTile(
                                  horizontalTitleGap: 0,
                                  leading: Icon(
                                    Icons.navigation,
                                    color: theme.primaryColor,
                                    size: 20,
                                  ),
                                  title: Text(
                                    '${widget.model.dropAddress}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: theme.backgroundColor,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16))),
                            child: Row(
                              children: [
                                RowItem(
                                    'PAYMENT_VIA',
                                    '${widget.model.transaction}',
                                    Icons.account_balance_wallet),
                                Spacer(),
                                RowItem('RIDE_FARE', '₹ ${widget.model.amount}',
                                    Icons.account_balance_wallet),
                                Spacer(),
                                RowItem(
                                    'RIDE_TYPE',
                                    '${widget.model.bookingType}',
                                    Icons.drive_eta),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(getWidth(15)),
                            child: Column(
                              children: [
                                double.parse(widget.model.baseFare.toString()) >
                                        0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          text(
                                              "${getTranslated(context, "BASE_FARE")} : ",
                                              fontSize: 10.sp,
                                              fontFamily: fontRegular,
                                              textColor: Colors.black),
                                          text(
                                              "₹" +
                                                  widget.model.baseFare
                                                      .toString(),
                                              fontSize: 10.sp,
                                              fontFamily: fontRegular,
                                              textColor: Colors.black),
                                        ],
                                      )
                                    : SizedBox(),
                                double.parse(widget.model.km.toString()) >= 2 &&
                                        double.parse(widget.model.ratePerKm
                                                .toString()) >
                                            0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          text(
                                              "${widget.model.km.toString()} ${getTranslated(context, "KILOMETERS")} : ",
                                              fontSize: 10.sp,
                                              fontFamily: fontRegular,
                                              textColor: Colors.black),
                                          text(
                                              "₹" +
                                                  widget.model.ratePerKm
                                                      .toString(),
                                              fontSize: 10.sp,
                                              fontFamily: fontRegular,
                                              textColor: Colors.black),
                                        ],
                                      )
                                    : SizedBox(),
                                double.parse(widget.model.timeAmount
                                            .toString()) >
                                        0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          text(
                                              "${widget.model.totalTime.toString()} ${getTranslated(context, "MINUTES")} : ",
                                              fontSize: 10.sp,
                                              fontFamily: fontRegular,
                                              textColor: Colors.black),
                                          text(
                                              "₹" +
                                                  widget.model.timeAmount
                                                      .toString(),
                                              fontSize: 10.sp,
                                              fontFamily: fontRegular,
                                              textColor: Colors.black),
                                        ],
                                      )
                                    : SizedBox(),
                                double.parse(widget.model.amount.toString()) > 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          text(
                                              "${getTranslated(context, "SUB_TOTAL")} : ",
                                              fontSize: 10.sp,
                                              fontFamily: fontMedium,
                                              textColor: Colors.black),
                                          text(
                                              "₹" +
                                                  (double.parse(widget
                                                              .model.amount
                                                              .toString()) +
                                                          double.parse(widget
                                                              .model
                                                              .promo_discount
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
                                double.parse(
                                            widget.model.gstAmount.toString()) >
                                        0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          text(
                                              "${getTranslated(context, "TAXES")} : ",
                                              fontSize: 10.sp,
                                              fontFamily: fontMedium,
                                              textColor: Colors.black),
                                          text(
                                              "₹" +
                                                  widget.model.gstAmount
                                                      .toString(),
                                              fontSize: 10.sp,
                                              fontFamily: fontMedium,
                                              textColor: Colors.black),
                                        ],
                                      )
                                    : SizedBox(),
                                widget.model.promo_discount.toString() != ''
                                    ? double.parse(widget.model.promo_discount
                                                .toString()) >
                                            0
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              text(
                                                  "${getTranslated(context, "PROMO")} : ",
                                                  fontSize: 10.sp,
                                                  fontFamily: fontRegular,
                                                  textColor: Colors.black),
                                              text(
                                                  "- ₹" +
                                                      double.parse(widget.model
                                                              .promo_discount
                                                              .toString())
                                                          .toStringAsFixed(2),
                                                  fontSize: 10.sp,
                                                  fontFamily: fontRegular,
                                                  textColor: Colors.black),
                                            ],
                                          )
                                        : SizedBox()
                                    : SizedBox(),
                                double.parse(widget.model.surgeAmount
                                            .toString()) >
                                        0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          text(
                                              "${getTranslated(context, "SURGE")} : ",
                                              fontSize: 10.sp,
                                              fontFamily: fontMedium,
                                              textColor: Colors.black),
                                          text(
                                              "₹" +
                                                  widget.model.surgeAmount
                                                      .toString(),
                                              fontSize: 10.sp,
                                              fontFamily: fontMedium,
                                              textColor: Colors.black),
                                        ],
                                      )
                                    : SizedBox(),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    text(
                                        "${getTranslated(context, "TOTAL")} : ",
                                        fontSize: 10.sp,
                                        fontFamily: fontMedium,
                                        textColor: Colors.black),
                                    text(
                                        "₹" +
                                            "${double.parse(widget.model.amount.toString()).toStringAsFixed(2)}",
                                        fontSize: 10.sp,
                                        fontFamily: fontMedium,
                                        textColor: Colors.black),
                                  ],
                                ),
                                boxHeight(10),
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
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
}
