import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cabira/Model/promo_code.dart';
import 'package:cabira/Model/wallet_model.dart';
import 'package:cabira/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cabira/BookRide/finding_ride_page.dart';
import 'package:cabira/BookRide/map.dart';
import 'package:cabira/Model/driver_model.dart';
import 'package:cabira/Model/ride_model.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/constant.dart';
import 'package:cabira/utils/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cabira/Assets/assets.dart';
import 'package:cabira/Components/background_image.dart';
import 'package:cabira/Components/custom_button.dart';
import 'package:cabira/Locale/locale.dart';
import 'package:cabira/Locale/strings_enum.dart';
import 'package:cabira/Routes/page_routes.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class CabType {
  final String car;
  final String? rideType;
  final String cost;

  CabType(this.car, this.rideType, this.cost);
}

class ChooseCabPage extends StatefulWidget {
  LatLng source, destination;
  String pickAddress, dropAddress, paymentType, shareType;

  DateTime? bookingDate;

  ChooseCabPage(this.source, this.destination, this.pickAddress,
      this.dropAddress, this.paymentType, this.bookingDate, this.shareType);

  @override
  _ChooseCabPageState createState() => _ChooseCabPageState();
}

class _ChooseCabPageState extends State<ChooseCabPage> {
  int _currentCar = 0;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  //var distance;
  var vehicleType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentType = widget.paymentType;
    bookingDate = widget.bookingDate;
    getDriver();
    getPromo();
    // getJoiningBonus();
//    getRides();
    getTime1(
        widget.source.latitude.toString(),
        widget.source.longitude.toString(),
        widget.destination.latitude.toString(),
        widget.destination.longitude.toString());
    //getEstimated();
    getWallet();
  }

  List<WalletModel> walletList = [];
  double totalBal = 0;
  getWallet() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "user_id": curUserId.toString(),
      };
      Map response = await apiBase.getAPICall(
        Uri.parse(baseUrl1 + "users/getWallet/${curUserId}"),
      );
      setState(() {
        saveStatus = true;
        walletList.clear();
      });
      if (response['status']) {
        var data = response["transactions"];
        for (var v in data) {
          print(v['Note']);
          setState(() {
            walletList.add(new WalletModel.fromJson(v));
          });
        }
        print(data);
        totalBal = double.parse(response['amount'].toString());
      } else {
        setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, "WRONG")!, context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  List<CabType> cabs = [];
  TextEditingController promoCon = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    cabs = [
      CabType(Assets.Car1, getTranslated(context, 'SHARE'), '40.50'),
      CabType(Assets.Car2, getTranslated(context, 'PRIVATE'), '65.50'),
      CabType(Assets.Car3, getTranslated(context, 'LUXURY'), '128.20'),
    ];
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            latitude != 0 && !driveStatus && rideList.length > 0
                ? MapPage(
                    true,
                    pick: widget.pickAddress,
                    dest: widget.dropAddress,
                    driveList: driverList,
                    SOURCE_LOCATION: widget.source,
                    DEST_LOCATION: widget.destination,
                    carType:
                        rideList[_currentCar].catType == "Bike" ? "1" : "2",
                    live: false,
                  )
                : Center(child: CircularProgressIndicator()),
            /*     Positioned(
              right: getWidth(10),
              top: getHeight(10),
              child: InkWell(
                onTap: () {
                  scaffoldKey.currentState!.showBottomSheet((context) =>  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        boxHeight(10),
                        Row(
                          children: [
                            Expanded(
                              child: text(
                                "Offers",
                                isCentered: true,
                                fontSize: 14.sp,
                                fontFamily: fontMedium,
                                textColor: MyColorName.colorTextPrimary,
                              ),
                            ),
                            IconButton(onPressed: (){
                              Navigator.pop(context);
                            }, icon: Icon(Icons.close,color:MyColorName.colorTextPrimary ,)),
                          ],
                        ),
                        boxHeight(10),
                        Container(
                          margin: EdgeInsets.all(getWidth(10)),
                          child: TextField(
                            controller: promoCon,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                              ),
                              focusedBorder: OutlineInputBorder(),
                              hintText: "Enter Promo Code",
                              suffixIcon: IconButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  applyCode(promoCon.text);
                                },
                                icon: Icon(Icons.send,
                                color: MyColorName.primaryLite,
                                ),
                              )
                            ),
                          ),
                        ),
                        boxHeight(10),
                        ListView.builder(
                          itemCount: promoList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context,index){
                           return Container(
                             margin: EdgeInsets.all(getWidth(10)),
                             decoration: boxDecoration(
                               showShadow: true,
                             ),
                             child: ListTile(
                               title: text(
                                 "Promo Code : ${promoList[index].promocode}",
                                 fontSize: 14.sp,
                                 fontFamily: fontMedium,
                                 textColor: MyColorName.colorTextPrimary,
                               ),
                               subtitle:  text(
                                 "${promoList[index].message}",
                                 fontSize: 14.sp,
                                 fontFamily: fontMedium,
                                 textColor: MyColorName.colorTextPrimary,
                               ),
                               trailing:  InkWell(
                                 onTap: () {
                                   Navigator.pop(context);
                                   applyCode(promoList[index].promocode);
                                 },
                                 child: Container(
                                   width: 20.w,
                                   height: 4.h,
                                   decoration: boxDecoration(
                                       radius: 5,bgColor: Theme.of(context)
                                       .primaryColor),
                                   child: Center(
                                       child: text("Apply",
                                           fontFamily: fontMedium,
                                           fontSize: 10.sp,
                                           isCentered: true,
                                           textColor: Colors.white)),
                                 ),
                               ),
                             ),
                           );
                        }),
                        boxHeight(10),
                      ],
                    ),
                  ),);
                },
                child: Container(
                  decoration: boxDecoration(
                      radius: 10,
                      color: Theme.of(context).primaryColor),
                  height: 6.h,
                  width: 6.h,
                  child: Icon(
                    Icons.local_offer_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 20.sp,
                  ),
                ),
              ),
            ),*/
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                rideList.length > 0
                    ? Container(
                        height: 188,
                        alignment: Alignment.center,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: rideList.length,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            vehicleType =
                                rideList[index].catType == "Bike" ? "1" : "2";
                            return Padding(
                              padding: EdgeInsetsDirectional.only(end: 10),
                              child: GestureDetector(
                                onTap: () {
                                  if (rideList[_currentCar].catType !=
                                      rideList[index].catType) {
                                    getDriver();
                                  }
                                  setState(() {
                                    _currentCar = index;
                                  });
                                },
                                child: Card(
                                  elevation: 5,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 350),
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: _currentCar == index
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).backgroundColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FadedScaleAnimation(
                                          Image.asset(
                                            rideList[index].catType == "Bike"
                                                ? "assets/cars/car1.png"
                                                : "assets/cars/car2.png",
                                            height: 80,
                                            width: 80,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          getTranslated(context, "GO")! +
                                              ' ' +
                                              rideList[index]
                                                  .cartype
                                                  .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Est. ₹' +
                                              rideList[index]
                                                  .intailrate
                                                  .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff605f5f)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : SizedBox(),
                SizedBox(height: 16),
                /* CustomButton(
                    text: getString(Strings.RIDE_NOW),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).scaffoldBackgroundColor,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>FindingRidePage()));
                    }
                ),*/
              ],
            )
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          scaffoldKey.currentState!.showBottomSheet(
            (context) => Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  boxHeight(10),
                  Row(
                    children: [
                      Expanded(
                        child: text(
                          getTranslated(context, "OFFER")!,
                          isCentered: true,
                          fontSize: 14.sp,
                          fontFamily: fontMedium,
                          textColor: MyColorName.colorTextPrimary,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: MyColorName.colorTextPrimary,
                          )),
                    ],
                  ),
                  boxHeight(10),
                  Container(
                    margin: EdgeInsets.all(getWidth(10)),
                    child: TextField(
                      controller: promoCon,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          hintText: getTranslated(context, "PROMO_CODE1")!,
                          suffixIcon: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              applyCode(promoCon.text);
                            },
                            icon: Icon(
                              Icons.send,
                              color: MyColorName.primaryLite,
                            ),
                          )),
                    ),
                  ),
                  boxHeight(10),
                  ListView.builder(
                      itemCount: promoList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(getWidth(10)),
                          decoration: boxDecoration(
                            showShadow: true,
                          ),
                          child: ListTile(
                            title: text(
                              "${getTranslated(context, "PROMO_CODE1")} : ${promoList[index].promocode}",
                              fontSize: 14.sp,
                              fontFamily: fontMedium,
                              textColor: MyColorName.colorTextPrimary,
                            ),
                            subtitle: text(
                              "${promoList[index].message}",
                              fontSize: 14.sp,
                              fontFamily: fontMedium,
                              textColor: MyColorName.colorTextPrimary,
                            ),
                            trailing: InkWell(
                              onTap: () {
                                setState(() {
                                  promoCon.text =
                                      promoList[index].promocode.toString();
                                });
                                Navigator.pop(context);
                                applyCode(promoList[index].promocode);
                              },
                              child: Container(
                                width: 20.w,
                                height: 4.h,
                                decoration: boxDecoration(
                                    radius: 5,
                                    bgColor: Theme.of(context).primaryColor),
                                child: Center(
                                    child: text(
                                        getTranslated(context, "APPLY")!,
                                        fontFamily: fontMedium,
                                        fontSize: 10.sp,
                                        isCentered: true,
                                        textColor: Colors.white)),
                              ),
                            ),
                          ),
                        );
                      }),
                  boxHeight(10),
                ],
              ),
            ),
          );
        },
        child: Container(
          decoration: boxDecoration(
              radius: 100,
              showShadow: true,
              bgColor: Theme.of(context).primaryColor),
          height: 6.h,
          width: 6.h,
          child: Icon(
            Icons.local_offer_outlined,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            boxHeight(20),
            Container(
              color: theme.backgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 52,
              child: Row(
                children: [
                  Text(
                    getTranslated(context, "PAYMENT_MODE")!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 13.5,
                        ),
                  ),
                  Spacer(),
                  Container(
                    width: 1,
                    height: 28,
                    color: theme.hintColor,
                  ),
                  Spacer(),
                  PopupMenuButton(
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: theme.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          paymentType != ""
                              ? paymentType
                              : getTranslated(context, 'WALLET')!,
                          style: theme.textTheme.button!.copyWith(
                              color: theme.primaryColor, fontSize: 15),
                        ),
                      ],
                    ),
                    onSelected: (val) {
                      setState(() {
                        paymentType = val.toString();
                      });
                    },
                    offset: Offset(0, -144),
                    color: theme.backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: getString(Strings.CASH)!,
                          child: Row(
                            children: [
                              Icon(Icons.credit_card_sharp),
                              SizedBox(width: 12),
                              Text(getTranslated(context, 'CASH')!),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.account_balance_wallet),
                              SizedBox(width: 12),
                              Text(getTranslated(context, 'WALLET')!),
                            ],
                          ),
                          value: getString(Strings.WALLET)!,
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
            Container(
              color: theme.backgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 52,
              child: Row(
                children: [
                  Text(
                    "${getTranslated(context, "DISTANCE")}         ",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 13.5,
                        ),
                  ),
                  Spacer(),
                  Container(
                    width: 1,
                    height: 28,
                    color: theme.hintColor,
                  ),
                  Spacer(),
                  Text(
                    distance + " Km",
                    style: theme.textTheme.button!
                        .copyWith(color: theme.primaryColor, fontSize: 15),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      if (isFirstUser != "1") {
                        if (bookingDate != null) {
                          showConfirm("schedule");
                        } else {
                          showConfirm("now");
                        }
                      } else {
                        /*if (bookingDate != null) {
                          showConfirm("schedule");
                        } else {
                          showConfirm("now");
                        }*/
                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>FindingRidePage()));
                    },
                    child: Container(
                      width: 75.w,
                      height: bookingDate != null ? 7.h : 6.h,
                      decoration: boxDecoration(
                          radius: 10, bgColor: Theme.of(context).primaryColor),
                      child: Center(
                          child: saveStatus
                              ? text(
                                  bookingDate != null
                                      ? "${getTranslated(context, "SCHEDULE_BOOKING")}\n${getDate(bookingDate.toString())}"
                                      : "${getTranslated(context, "RIDE_NOW")}",
                                  fontFamily: fontMedium,
                                  fontSize: bookingDate != null ? 10.sp : 12.sp,
                                  isCentered: true,
                                  textColor: Colors.white)
                              : CircularProgressIndicator(
                                  color: Colors.white,
                                )),
                    ),
                  ),
                  Container(
                    decoration: boxDecoration(
                        radius: 10, color: Theme.of(context).primaryColor),
                    height: 6.h,
                    width: 6.h,
                    child: Center(
                      child: IconButton(
                          onPressed: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true, onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) {
                              setState(() {
                                bookingDate = date;
                              });
                              print('confirm $date');
                            },
                                //currentTime: DateTime.now(),
                                minTime: DateTime.now(),
                                maxTime: DateTime.now().add(Duration(days: 2)));
                          },
                          icon: Icon(
                            Icons.calendar_today_outlined,
                            color: Theme.of(context).primaryColor,
                            size: 24.sp,
                          )),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showConfirm(String type) {
    getJoiningBonus();
    surge = 0;
    gst = 0;
    gst = ((double.parse(rideList[_currentCar].gst) *
                double.parse(rideList[_currentCar].intailrate)) /
            100)
        .roundToDouble();
    // if(isFirstUser != "1"){

    // }
    if (type != "schedule" &&
        !rideList[_currentCar].serge.contains("Not") &&
        rideList[_currentCar].surge_charge.length > 0) {
      if (rideList[_currentCar].surge_charge[0]['time_on_off'].toString() !=
          "CLOSED") {
        surge = ((double.parse(rideList[_currentCar]
                        .surge_charge[0]['amount']
                        .toString()) *
                    double.parse(rideList[_currentCar].intailrate)) /
                100)
            .roundToDouble();
      } else {
        surge = 0;
      }
    }
    if (paymentType == "Wallet" &&
        walletAmount <
            surge + gst + double.parse(rideList[_currentCar].intailrate)) {
      setSnackbar("Insufficient Balance", context);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context1) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(getWidth(15)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  text(getTranslated(context, "CONFIRM_RIDE")!,
                      fontSize: 10.sp,
                      fontFamily: fontMedium,
                      textColor: Colors.black),
                  Divider(),
                  boxHeight(10),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration:
                            boxDecoration(radius: 100, bgColor: Colors.green),
                      ),
                      boxWidth(10),
                      Expanded(
                          child: text(widget.pickAddress,
                              fontSize: 9.sp,
                              fontFamily: fontRegular,
                              textColor: Colors.black)),
                    ],
                  ),
                  boxHeight(10),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration:
                            boxDecoration(radius: 100, bgColor: Colors.red),
                      ),
                      boxWidth(10),
                      Expanded(
                          child: text(widget.dropAddress,
                              fontSize: 9.sp,
                              fontFamily: fontRegular,
                              textColor: Colors.black)),
                    ],
                  ),
                  boxHeight(10),
                  Divider(),
                  boxHeight(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          rideList[_currentCar].cartype != "" &&
                                  rideList[_currentCar].cartype != "Bike"
                              ? "assets/cars/car2.png"
                              : "assets/cars/car1.png",
                          height: 30,
                          width: 30,
                        ),
                      ),
                      text(rideList[_currentCar].cartype,
                          fontSize: 10.sp,
                          fontFamily: fontRegular,
                          textColor: Colors.black),
                      text("₹" + rideList[_currentCar].intailrate,
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: Colors.black),
                    ],
                  ),
                  boxHeight(10),
                  Divider(),
                  boxHeight(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text("${getTranslated(context, "PAYMENT_MODE")} : ",
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: Colors.black),
                      text(paymentType,
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: Colors.black),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text("${getTranslated(context, "DISTANCE")} : ",
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: Colors.black),
                      text(distance + " Km",
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: Colors.black),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text("${getTranslated(context, "BASE_FARE")} : ",
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: Colors.black),
                      text(
                          double.parse(distance) >= 1
                              ? "₹" + rideList[_currentCar].base_fare
                              : "₹" + rideList[_currentCar].minFare,
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: Colors.black),
                    ],
                  ),
                  double.parse(distance) >= 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(
                                "${distance} ${getTranslated(context, "KILOMETERS")} : ",
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                            text("₹" + rideList[_currentCar].rate_per_km,
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                          ],
                        )
                      : SizedBox(),
                  double.parse(rideList[_currentCar].time_cahrge) > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(
                                "${totalTime} ${getTranslated(context, "MINUTES")} : ",
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                            text("₹" + rideList[_currentCar].time_cahrge,
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                          ],
                        )
                      : SizedBox(),
                  gst > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text("${getTranslated(context, "TAXES")} : ",
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                            text("₹" + gst.toStringAsFixed(2),
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                          ],
                        )
                      : SizedBox(),
                  surge > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text("${getTranslated(context, "SURGE")} : ",
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                            text("₹" + surge.toStringAsFixed(2),
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                          ],
                        )
                      : SizedBox(),
                  promoDiscount != "0"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text("${getTranslated(context, "PROMO")} : ",
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                            text("-₹" + promoDiscount,
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
                      text(
                          "₹" +
                              (surge +
                                      gst +
                                      double.parse(
                                          rideList[_currentCar].intailrate) -
                                      double.parse(promoDiscount))
                                  .toStringAsFixed(2),
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: Colors.black),
                    ],
                  ),
                  rideList[_currentCar].cancellation_charges != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(
                                "${getTranslated(context, "CANCEL_CHARGE")} : ",
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                            text(
                                "₹" +
                                    rideList[_currentCar]
                                        .cancellation_charges
                                        .toString(),
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                          ],
                        )
                      : SizedBox(),
                  widget.shareType != ""
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text("${getTranslated(context, "RIDE_TYPE")} : ",
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                            text(widget.shareType,
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                          ],
                        )
                      : SizedBox(),
                  boxHeight(10),
                  type != "now"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text("${getTranslated(context, "BOOKING_DATE")} : ",
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                            Expanded(
                                child: text(getDate(bookingDate),
                                    fontSize: 10.sp,
                                    fontFamily: fontMedium,
                                    textColor: Colors.black)),
                          ],
                        )
                      : SizedBox(),
                  boxHeight(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context1);
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>FindingRidePage()));
                        },
                        child: Container(
                          width: 30.w,
                          height: 5.h,
                          decoration:
                              boxDecoration(radius: 5, bgColor: Colors.grey),
                          child: Center(
                              child: text(getTranslated(context, "CANCEL")!,
                                  fontFamily: fontMedium,
                                  fontSize: 10.sp,
                                  isCentered: true,
                                  textColor: Colors.white)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context1);
                          if (isFirstUser == "1") {
                            if (type == "now") {
                              if (totalBal.isNegative) {
                                setState(() {
                                  saveStatus = true;
                                });
                                setSnackbar(
                                    "You have negative balance, Please update wallet",
                                    context);
                              } else {
                                addRides();
                              }
                            } else {
                              print(
                                  "this is schedule time ${bookingDate!.hour} : ${bookingDate!.minute}");
                              if (totalBal.isNegative) {
                                setState(() {
                                  saveStatus = true;
                                });
                                setSnackbar(
                                    "You have negative balance, Please update wallet",
                                    context);
                              } else {
                                addScheduleRides();
                              }
                            }
                          }

                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>FindingRidePage()));
                        },
                        child: Container(
                          width: 30.w,
                          height: 5.h,
                          decoration: boxDecoration(
                              radius: 5,
                              bgColor: Theme.of(context).primaryColor),
                          child: Center(
                              child: text(getTranslated(context, "CONFIRM")!,
                                  fontFamily: fontMedium,
                                  fontSize: 10.sp,
                                  isCentered: true,
                                  textColor: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  String paymentType = "Wallet";
  DateTime? bookingDate;
  Future getEstimated() async {
    calculateDistance(widget.source.latitude, widget.source.longitude,
        widget.destination.latitude, widget.destination.longitude);
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${widget.source.latitude}%2C${widget.source.longitude}&destinations=${widget.destination.latitude}%2C${widget.destination.longitude}&key=AIzaSyBq52y-MtlJa6wtmzZ1XIz3LTbwBpaWXuU'));
    http.StreamedResponse response = await request.send();
    print(request);
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      var data = json.decode(str);
      print(data);

      if (data["status"] == "OK") {
        setState(() {
          var dis =
              data["rows"][0]["elements"][0]["distance"]["text"].toString();
          List d = dis.toString().split(" ").toList();
          //  distance = double.parse(d[0].toString());
          print("$distance>>>>>>>>>>>>>>>>>>>>");
        });
      } else {}
    } else {
      return null;
    }
  }

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool saveStatus = true;
  bool driveStatus = true;
  List<RideModel> rideList = [];
  List<DriverModel> driverList = [];
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

  double gst = 0.0;
  double surge = 0.0;

  addRides() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "user_id": curUserId,
        "username": "name",
        "pickup_address": widget.pickAddress,
        "latitude": widget.source.latitude.toString(),
        "longitude": widget.source.longitude.toString(),
        "drop_address": widget.dropAddress,
        "drop_latitude": widget.destination.latitude.toString(),
        "drop_longitude": widget.destination.longitude.toString(),
        "amount": (double.parse(rideList[_currentCar].intailrate) -
                double.parse(promoDiscount) +
                gst +
                surge)
            .toStringAsFixed(2),
        "paid_amount": double.parse(distance) >= 1
            ? (double.parse(rideList[_currentCar].intailrate) -
                    double.parse(promoDiscount) +
                    gst +
                    surge)
                .toStringAsFixed(2)
            : rideList[_currentCar].minFare,
        "gst_amount": gst.toStringAsFixed(2),
        "surge_amount": surge.toStringAsFixed(2),
        "distance": distance,
        "km": distance,
        "rate_per_km": rideList[_currentCar].rate_per_km,
        "total_time": totalTime,
        "base_fare": double.parse(distance) >= 1
            ? rideList[_currentCar].base_fare
            : rideList[_currentCar].minFare,
        "time_amount": rideList[_currentCar].time_cahrge,
        "taxi_type": rideList[_currentCar].cartype != ""
            ? rideList[_currentCar].cartype
            : "Bike",
        "cancel_charge": rideList[_currentCar].cancellation_charges,
        "delivery_type": rideList[_currentCar].cartype != "" &&
                rideList[_currentCar].cartype != "Bike"
            ? "2"
            : "1",
        "paymenttype": paymentType,
        "taxi_id": rideList[_currentCar].taxi_id,
        //"car_categories":rideList[_currentCar].i
        "transaction": paymentType,
      };
      if (promoDiscount != "0") {
        params['promo_discount'] = promoDiscount.toString();
        params['promo_code'] = promoCon.text.toString();
      }
      print("ADD RIDE PARAM =====>  $params");
      //  return;
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "payment/booking_trip"), params);
      setState(() {
        saveStatus = true;
      });
      if (response['status']) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FindingRidePage(
                    widget.source,
                    widget.destination,
                    widget.pickAddress,
                    widget.dropAddress,
                    paymentType,
                    response['booking_id'].toString(),
                    (surge +
                            gst +
                            double.parse(rideList[_currentCar].intailrate) -
                            double.parse(promoDiscount))
                        .toStringAsFixed(2),
                    // (double.parse(rideList[_currentCar].rate_per_km)+double.parse(rideList[_currentCar].base_fare)-double.parse(promoDiscount)+gst+surge).toStringAsFixed(2),
                    distance)));
        setSnackbar("Booking Confirmed", context);
      } else {
        setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, "WRONG")!, context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  String promoDiscount = "0";
  addScheduleRides() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "user_id": curUserId,
        "username": name,
        "pickup_address": widget.pickAddress,
        "latitude": widget.source.latitude.toString(),
        "longitude": widget.source.longitude.toString(),
        "drop_address": widget.dropAddress,
        "drop_latitude": widget.destination.latitude.toString(),
        "drop_longitude": widget.destination.longitude.toString(),
        "amount": (double.parse(rideList[_currentCar].intailrate) +
                double.parse(promoDiscount) +
                gst +
                surge)
            .toStringAsFixed(2),
        "paid_amount": (double.parse(rideList[_currentCar].intailrate) +
                double.parse(promoDiscount) +
                gst +
                surge)
            .toStringAsFixed(2),
        "gst_amount": gst.toStringAsFixed(2),
        "total_time": totalTime,
        "taxi_id": rideList[_currentCar].taxi_id,
        "surge_amount": surge.toStringAsFixed(2),
        "distance": distance,
        "km": distance,
        "taxi_type": rideList[_currentCar].cartype != ""
            ? rideList[_currentCar].cartype
            : "Bike",
        "delivery_type": rideList[_currentCar].cartype != "" &&
                rideList[_currentCar].cartype != "Bike"
            ? "2"
            : "1",
        "rate_per_km": rideList[_currentCar].rate_per_km,
        "base_fare": double.parse(distance) >= 1
            ? rideList[_currentCar].base_fare
            : rideList[_currentCar].minFare,
        "time_amount": rideList[_currentCar].time_cahrge,
        "paymenttype": paymentType,
        "transaction": paymentType,
        "cancel_charge": rideList[_currentCar].cancellation_charges,
        "pickup_time": bookingDate!.minute == 0
            ? '${bookingDate!.hour}:${bookingDate!.minute}0'
            : '${bookingDate!.hour}:${bookingDate!.minute}',
        "pickup_date": DateFormat("yyyy-MM-dd").format(bookingDate!),
        "sharing_type": widget.shareType,
      };
      if (promoDiscount != "0") {
        params['promo_discount'] = promoDiscount.toString();
        params['promo_code'] = promoCon.text.toString();
      }
      print(params);
      Map response = await apiBase.postAPICall(
          Uri.parse(widget.shareType != ""
              ? baseUrl1 + "Payment/intercity_booking"
              : baseUrl1 + "payment/shedual_booking_trip"),
          params);
      setState(() {
        saveStatus = true;
      });
      if (response['status']) {
        Navigator.pop(context, "yes");

        setSnackbar("Booking Confirmed", context);
      } else {
        setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, "WRONG")!, context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  getRides(totalTime) async {
    try {
      Map params = {
        "distance": distance,
        "lat": widget.source.latitude.toString(),
        "lang": widget.source.longitude.toString(),
        "time": totalTime,
        "location": "Indore",
        "type": widget.shareType != ""
            ? "intercity"
            : bookingDate != null
                ? "schedule"
                : "",
      };
      print("GET CAN CHARGE ;;;;;;;;;;;; $params");
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "products/get_cab_charge"), params);
      List<RideModel> tempList = [];
      if (response['status']) {
        for (var v in response['data']) {
          setState(() {
            tempList.add(new RideModel(
                v['taxi_id'],
                v['cartype'],
                v['intialkm'].toString(),
                double.parse(v['amount'].toString()).roundToDouble().toString(),
                double.parse(v['base_fare'] != null
                        ? v['base_fare'].toString()
                        : "0")
                    .roundToDouble()
                    .toString(),
                double.parse(v['time_cahrge'].toString())
                    .roundToDouble()
                    .toStringAsFixed(2),
                double.parse(v['rate_per_km'].toString())
                    .roundToDouble()
                    .toStringAsFixed(2),
                v['image'],
                v['serge'].toString(),
                v['gst'].toString(),
                v['surge_charge'],
                v['car_categories'],
                v['min_fare'] != null ? v['min_fare'].toString() : "0",
                v['cancellation_charges'],
                ""));
          });
        }
        setState(() {
          rideList = new List.from(tempList.reversed);
        });
      } else {
        // setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, "WRONG")!, context);
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
      print("GET TIME::::::" + response.body.toString());
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
      getRides(totalTime);
      print("TOTAL TIME" + totalTime.toString());
    } else {
      print("TIME 0");
      getRides("0");
    }
  }

  getDriver() async {
    try {
      setState(() {
        driveStatus = true;
        driverList.clear();
      });
      Map params = {
        "lat": widget.source.latitude.toString(),
        "lang": widget.source.longitude.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl + "get_driver_by_lat_lang"), params);

      if (response['status']) {
        for (var v in response['data']) {
          driverList.add(new DriverModel(
              v['id'].toString(),
              v['name'].toString(),
              v['user_name'].toString(),
              v['car_no'].toString(),
              v['phone'].toString(),
              v['latitude'].toString(),
              v['longitude'].toString(),
              v['rating'].toString(),
              v['user_image'].toString(),
              v['car_type'].toString()));
        }
        setState(() {
          driveStatus = false;
        });
      } else {
        setState(() {
          driveStatus = false;
        });
        //setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, "WRONG")!, context);
      setState(() {
        driveStatus = true;
      });
    }
  }

  List<PromoModel> promoList = [];
  String bonusAmount = '';
  String minRideAmount = '';
  getPromo() async {
    try {
      setState(() {
        driveStatus = true;
        driverList.clear();
      });
      Map params = {
        "lat": widget.source.latitude.toString(),
        "lang": widget.source.longitude.toString(),
      };
      https: //productsalphawizz.com/taxi/api/Payment/get_promo_code
      Map response = await apiBase.getAPICall(
        Uri.parse(baseUrl1 + "Payment/get_promo_code"),
      );

      if (response['status']) {
        for (var v in response['data']) {
          promoList.add(new PromoModel.fromJson(v));
        }
        setState(() {
          driveStatus = false;
        });
      } else {
        setState(() {
          driveStatus = false;
        });
        //setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, "WRONG")!, context);
      setState(() {
        driveStatus = true;
      });
    }
  }

  getJoiningBonus() async {
    try {
      setState(() {
        driveStatus = true;
        driverList.clear();
      });
      // Map params = {
      //   "lat": widget.source.latitude.toString(),
      //   "lang": widget.source.longitude.toString(),
      // };
      https: //productsalphawizz.com/taxi/api/Payment/get_promo_code
      Map response = await apiBase.getAPICall(
        Uri.parse(baseUrl1 + "Payment/joining_bonus_user"),
      );

      if (response['status']) {
        minRideAmount = response['data']['min_booking'];
        String promoAmount = response['data']['amount'];
        print("this is joining bonus amount $minRideAmount");
        setState(() {
          driveStatus = false;
        });
        if (isFirstUser != "" && isFirstUser != "1") {
          if (double.parse(rideList[_currentCar].intailrate) >
              double.parse(minRideAmount)) {
            setState(() {
              promoDiscount = promoAmount;
            });
          }
        }
      } else {
        setState(() {
          driveStatus = false;
        });
        //setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, "WRONG")!, context);
      setState(() {
        driveStatus = true;
      });
    }
  }

  applyCode(code) async {
    try {
      setState(() {
        saveStatus = false;
        driverList.clear();
      });

      Map params = {
        "final_total": rideList[_currentCar].intailrate,
        "promo_code": code,
        "user_id": curUserId,
      };
      https: //productsalphawizz.com/taxi/api/Payment/get_promo_code
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Payment/validate_promo_code5"), params);
      // Uri.parse(baseUrl1 + "Payment/apply_promo_code"),params);

      if (response['status']) {
        setSnackbar("${response['message']}", context);
        if (response['data'][0]['type'] == 'Percentage') {
          setState(() {
            saveStatus = true;
            promoDiscount = response['data'][0]['final_discount'] != null &&
                    response['data'][0]['final_discount'] != ""
                ? (double.parse(
                            response['data'][0]['final_discount'].toString()) *
                        double.parse(
                            rideList[_currentCar].intailrate.toString()) /
                        100)
                    .toStringAsFixed(2)
                : "0";
          });
        } else {
          setState(() {
            promoDiscount = response['data'][0]['final_discount'] != null &&
                    response['data'][0]['final_discount'] != ""
                ? response['data'][0]['final_discount'].toString()
                : "0";
            saveStatus = true;
          });
        }
        print("this is promo discount ===>${promoDiscount.toString()}");
      } else {
        setSnackbar("${response['message']}", context);
        setState(() {
          saveStatus = true;
        });
        //setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, "WRONG")!, context);
      setState(() {
        saveStatus = true;
      });
    }
  }
/* Future<RideModel?> getRide(distance) async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://productsalphawizz.com/taxi/api/products/get_cab_charge'));
    request.fields.addAll({'distance': '$distance'});

    http.StreamedResponse response = await request.send();
     print(request.fields);
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      print(str);
      return RideModel.fromJson(json.decode(str));
    } else {
      return null;
    }
  }*/
}
