import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cabira/Model/address_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:cabira/Components/custom_button.dart';
import 'package:cabira/DrawerPages/Settings/theme_cubit.dart';
import 'package:cabira/Locale/strings_enum.dart';
import 'package:cabira/Theme/style.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/colors.dart';
import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:cabira/utils/widget.dart';
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cabira/Locale/locale.dart';
import 'package:sizer/sizer.dart';

import 'package:http/http.dart' as http;

class Address {
  String id, title, description;

  Address(this.id, this.title, this.description);
}

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late ThemeCubit _themeCubit;
  int? _themeValue;
  int? _languageValue;
  bool screenStatus = false;
  double lat = 0, lng = 0;
  TextEditingController titleCon = TextEditingController();
  TextEditingController addressCon = TextEditingController();
  @override
  void initState() {
    super.initState();
    getAddress();
  }

  List<String> typeAdr = ["Home", "Work"];
  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  List<Address> ruleList = [];
  bool acceptStatus = false;
  addAddress(type, homeAddress) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "user_id": curUserId,
          "user_address": homeAddress,
          "lat": lat.toString(),
          "lang": lng.toString(),
          "type": type
        };
        if (id != "") {
          data['id'] = id.toString();
        }
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "Authentication/user_address"), data);
        print(response);
        print(response);
        bool status = true;
        String msg = response['message'];
        setSnackbar(msg, context);
        setState(() {
          acceptStatus = false;
          addData = false;
          addressList.clear();
        });
        if (response['status']) {
          getAddress();
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setSnackbar("No Internet Connection", context);
    }
  }

  deleteAddress(id) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "id": id,
        };
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "Authentication/delete_address"), data);
        print(response);
        print(response);
        bool status = true;
        String msg = response['message'];
        setSnackbar(msg, context);
        setState(() {
          acceptStatus = false;
          addData = false;
          addressList.clear();
        });
        if (response['status']) {
          getAddress();
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setSnackbar("No Internet Connection", context);
    }
  }

  List<AddressModel> addressList = [];
  getAddress() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "user_id": curUserId,
        };
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "Authentication/get_address"), data);
        print(response);
        print(response);
        bool status = true;
        String msg = response['message'];

        setState(() {
          acceptStatus = false;
        });
        if (response['status']) {
          for (var v in response['data']) {
            setState(() {
              addressList.add(AddressModel.fromJson(v));
            });
          }
        } else {
          setSnackbar(msg, context);
        }
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setSnackbar("No Internet Connection", context);
    }
  }

  String id = "";
  bool addData = false;
  String homeAddress = "", workAddress = "";
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return Future.value();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(
              Icons.arrow_back_sharp,
              color: Colors.white,
            ),
          ),
          title: Text(
            "Manage Address",
            style: theme.textTheme.headline4!.copyWith(color: Colors.white),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(!addData ? Icons.add : Icons.close),
          onPressed: () {
            setState(() {
              id = "";
              addData = !addData;
            });
          },
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: getWidth(25)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boxHeight(20),
              !addData
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: addressList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            AddressModel model = addressList[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  id = model.id!;
                                  addressCon.text = model.pickupAddress!;
                                  titleCon.text = model.type!;
                                  lat = double.parse(model.lat!);
                                  lng = double.parse(model.lang!);
                                  addData = true;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(getHeight(10)),
                                decoration: boxDecoration(
                                    radius: 10,
                                    bgColor: Colors.white,
                                    showShadow: true),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 90.w,
                                      height: 6.h,
                                      decoration: boxDecoration(
                                          radius: 10,
                                          bgColor:
                                              Theme.of(context).primaryColor),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: text(model.type!,
                                                fontFamily: fontMedium,
                                                fontSize: 12.sp,
                                                isCentered: true,
                                                textColor: Colors.white),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                deleteAddress(model.id!);
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              )),
                                          Container(
                                              height: 6.h,
                                              child: VerticalDivider(
                                                color: Colors.white,
                                              )),
                                          boxWidth(5),
                                          Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          boxWidth(10),
                                        ],
                                      )),
                                    ),
                                    Container(
                                      width: 90.w,
                                      padding: EdgeInsets.all(getWidth(10)),
                                      child: Text(
                                        model.pickupAddress!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  : Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            autofocus: true,
                            controller: titleCon,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: MyColorName.primaryLite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                ),
                            decoration: InputDecoration(
                                counterText: '',
                                labelText: 'Title',
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: MyColorName.colorView,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColorName.primaryLite,
                                        width: 2)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColorName.primaryLite,
                                        width: 2))),
                          ),
                          boxHeight(20),
                          TextFormField(
                            controller: addressCon,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: MyColorName.primaryLite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                ),
                            minLines: 3,
                            maxLines: 5,
                            readOnly: true,
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
                                        addressCon.text =
                                            result.formattedAddress.toString();
                                        lat = result.geometry!.location.lat;
                                        lng = result.geometry!.location.lng;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    initialPosition:
                                        LatLng(latitude, longitude),
                                    useCurrentLocation: true,
                                  ),
                                ),
                              );
                            },
                            decoration: InputDecoration(
                                counterText: '',
                                labelText: 'Address',
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: MyColorName.colorView,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColorName.primaryLite,
                                        width: 2)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColorName.primaryLite,
                                        width: 2))),
                          ),
                          boxHeight(20),
                          InkWell(
                            onTap: () async {
                              if (titleCon.text == "") {
                                setSnackbar("Enter Title", context);
                                return;
                              }
                              if (addressCon.text == "") {
                                setSnackbar("Enter Address", context);
                                return;
                              }
                              setState(() {
                                acceptStatus = true;
                              });
                              addAddress(titleCon.text, addressCon.text);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              width: 80.w,
                              height: 6.h,
                              decoration: boxDecoration(
                                  radius: 10, bgColor: Colors.black),
                              child: Center(
                                child: text(
                                    id != "" ? "Update Address" : "Add Address",
                                    fontFamily: fontMedium,
                                    fontSize: 12.sp,
                                    textColor: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
  }
}
