import 'dart:async';

import 'package:cabira/Model/my_ride_model.dart';
import 'package:cabira/Model/restaurant_model.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/constant.dart';
import 'package:cabira/utils/location_details.dart';
import 'package:cabira/utils/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../utils/Session.dart';
import '../utils/colors.dart';
import 'choose_cab_page.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  TextEditingController pickupCon = new TextEditingController();
  TextEditingController dropCon = new TextEditingController();
  TextEditingController pickupCityCon = new TextEditingController();
  TextEditingController dropCityCon = new TextEditingController();
  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool loading = true;
  bool loading1 = true;
  CarouselController carouselController = new CarouselController();
  int current = 0;
  int currentIndex = 0;
  List<RestaurantModel> restList = [];
  List<RestaurantModel> nearList = [];
  List<RestaurantModel> topList = [];
  getRestaurant() async {
    try {
      setState(() {
        loading = true;
      });
      Map params = {
        "lat": latitude.toString(),
        "lang": longitude.toString(),
      };
      print("ALL COMPLETE RIDE PARAM ====== $params");
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Authentication/get_all_restarnts"), params);

      setState(() {
        loading = false;
        restList.clear();
        nearList.clear();
      });
      if (response['status']) {
        print(response['data']);
        List<RestaurantModel> tempList = [];
        for (var v in response['data']) {
          tempList.add(RestaurantModel.fromJson(v));
        }
        topList = tempList.toList();
        restList = tempList.toList();
        tempList.sort((a, b) {
          print(a.distance);
          print(a.userName);
          return a.distance!.compareTo(b.distance!);
        });
        nearList = tempList.toList();
      } else {
        setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, "WRONG")!, context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    getRestaurant();
  }

  getLocation() {
    GetLocation location = new GetLocation((result) {
      if (mounted) {
        setState(() {
          address = result.first.addressLine;
          latitude = result.first.coordinates.latitude;
          longitude = result.first.coordinates.longitude;
          pickupCon.text = address;
          pickupCityCon.text = result.first.locality;
          print(pickupCityCon.text);
        });
      }
    });
    location.getLoc();
  }

  String titleName = "Our riders top picks";
  String paymentType = "Cash";
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Color(0xfffafafa),
        width: getWidth(375),
        child: Column(
          children: [
            Container(
              width: getWidth(375),
              padding: EdgeInsets.all(getWidth(20)),
              color: MyColorName.colorView,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        restList = topList.toList();
                        titleName = "Our riders top picks";
                      });
                    },
                    child: Text(
                      "Our riders top picks →".toUpperCase(),
                      style: theme.textTheme.titleLarge!
                          .copyWith(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        restList = nearList.toList();
                        titleName = "nearest";
                      });
                    },
                    child: Text(
                      "nearest →".toUpperCase(),
                      style: theme.textTheme.titleLarge!
                          .copyWith(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(getWidth(10)),
                  child: Column(
                    children: [
                      Text(
                        titleName.toUpperCase(),
                        style: theme.textTheme.titleLarge!.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                      boxHeight(20),
                      !loading
                          ? restList.isNotEmpty
                              ? ListView.builder(
                                  itemCount: restList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () async {
                                        if (restList[index].openClose == 0) {
                                          setSnackbar(
                                              "Restaurant is Closed", context);
                                          // return;
                                        }
                                        double dropLatitude = 0,
                                            dropLongitude = 0;
                                        dropCon.text =
                                            restList[index].userAddress!;
                                        dropLatitude =
                                            double.parse(restList[index].lat!);
                                        dropLongitude =
                                            double.parse(restList[index].lang!);
                                        Navigator.pop(context, {
                                          "address": dropCon.text,
                                          "lat": dropLatitude,
                                          "lng": dropLongitude,
                                        });
                                        /*var result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChooseCabPage(
                                                      LatLng(
                                                          latitude, longitude),
                                                      LatLng(dropLatitude,
                                                          dropLongitude),
                                                      address,
                                                      pickupCityCon.text,
                                                      dropCityCon.text,
                                                      dropCon.text,
                                                      paymentType,
                                                      null,
                                                      "",
                                                    )));*/
                                      },
                                      child: Container(
                                        decoration: boxDecoration(
                                            radius: 20.0,
                                            showShadow: true,
                                            bgColor: Colors.white),
                                        margin: EdgeInsets.all(5),
                                        width: getWidth(375),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                CarouselSlider(
                                                  carouselController:
                                                      carouselController,
                                                  options: CarouselOptions(
                                                    height: getHeight(184),
                                                    viewportFraction: 1.0,
                                                    enableInfiniteScroll: false,
                                                    autoPlay: true,
                                                    /*onPageChanged: (index, reason) {
                                                setState(() {
                                                  restList[index].index = index;
                                                });
                                              },*/
                                                  ),
                                                  items: restList[index]
                                                      .userImage!
                                                      .map((e) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                20.0),
                                                        topRight:
                                                            Radius.circular(
                                                                20.0),
                                                      ),
                                                      child: CachedNetworkImage(
                                                        imageUrl: "${e}",
                                                        width: getWidth(375),
                                                        height: getHeight(200),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  left: 19,
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        getWidth(5)),
                                                    decoration: boxDecoration(
                                                      radius: 5.0,
                                                      bgColor: Colors.black
                                                          .withOpacity(0.4),
                                                    ),
                                                    child: Text(
                                                      "${restList[index].description}",
                                                      style: theme
                                                          .textTheme.bodyLarge!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12.0),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    bottom: 0,
                                                    child: Container(
                                                      width: getWidth(340),
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "${restList[index].userName}"
                                                                    .toUpperCase(),
                                                                style: theme
                                                                    .textTheme
                                                                    .titleLarge!
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w800,
                                                                        fontSize:
                                                                            22.0),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        4),
                                                            decoration:
                                                                boxDecoration(
                                                                    radius: 10,
                                                                    bgColor: Colors
                                                                        .green),
                                                            child: Row(
                                                              children: [
                                                                text(
                                                                    "${restList[index].ratting}",
                                                                    fontFamily:
                                                                        fontMedium,
                                                                    fontSize:
                                                                        12.sp,
                                                                    textColor:
                                                                        Colors
                                                                            .white),
                                                                boxWidth(5),
                                                                Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 16,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                                /*Positioned(
                                                    top: 10,
                                                    right: 10,
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        Icons.favorite_border,
                                                        color: Colors.white,
                                                      ),
                                                    )),*/
                                                /*Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: boxDecoration(
                                                    radius: 10,
                                                    bgColor: restList[index]
                                                                .openClose !=
                                                            0
                                                        ? Colors.green
                                                        : Colors.red),
                                                child: Center(
                                                  child: text(
                                                      restList[index].openClose !=
                                                              0
                                                          ? "Open"
                                                          : "Close",
                                                      fontFamily: fontMedium,
                                                      fontSize: 10.sp,
                                                      textColor: Colors.white),
                                                ),
                                              )),*/
                                              ],
                                            ),
                                            boxHeight(5),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Ride. Eat. Repeat"
                                                    .toUpperCase(),
                                                style: theme
                                                    .textTheme.titleLarge!
                                                    .copyWith(fontSize: 16.0),
                                              ),
                                            ),
                                            boxHeight(5),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                              : Center(
                                  child: Text(
                                    "No Data Available".toUpperCase(),
                                    style: theme.textTheme.titleLarge!.copyWith(
                                      color: theme.hintColor,
                                    ),
                                  ),
                                )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
