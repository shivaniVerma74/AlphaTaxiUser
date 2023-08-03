import 'dart:async';

import 'package:cabira/Model/refer_model.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:cabira/utils/widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:social_share/social_share.dart';

class ReferEarn extends StatefulWidget {
  const ReferEarn({Key? key}) : super(key: key);

  @override
  State<ReferEarn> createState() => _ReferEarnState();
}

class _ReferEarnState extends State<ReferEarn> {
  String referCode = "", title = "Sahayatri User App", des = "You can use this code to refer your friends \nto Sahayatri User App and get rewarded";
  bool saveStatus = true;
  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool loading = true;
  List<ReferModel> referList = [];
  getRefer() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "get_referral_data": "1",
        "user_id":curUserId.toString(),
        "refferal_code": refer.toString(),
      };
      Map response =
      await apiBase.postAPICall(Uri.parse(baseUrl + "get_refferal_user"), params);
      setState(() {
        saveStatus = true;
      });
      if (response['status']) {
        for (var v in response['data']) {
          setState(() {
            referList.add(new ReferModel(v['id'], v['username'], v['email'], v['mobile'], v['car_type'], v['user_image'], v['refer_status']));
            des = response['Refferal Message'];
          });
          print("this is description $des");
        }
      } else {
        setSnackbar(response['message'], context);
        setState((){
          des = response['Refferal Message'];
        });
        print("this is description $des");
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, "WRONG")!, context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSaved();
    getRefer();
  }

  getSaved() async {
    await App.init();
    setState(() {
      referCode = refer.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Refer & Earn",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Color(
              0xff2CC8DE), //<- background color to combine with the picture :-)
        ),
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              width: 20.0,
              height: 30.0,
            ),
            Container(
              child: Image.asset(
                'assets/refer.png',
                height: 200.0,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 40.0),
                child: Column(children: [
                  Text(getTranslated(context, "REFER")!,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ))
                ])),
            Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Column(children: [
                  Text(
                      des,
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ))
                ])),
            Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Column(children: [
                  InkWell(
                    onTap: () {
                      SocialShare.copyToClipboard(refer);
                      setSnackbar("Code Copied", context);
                    },
                    child: DottedBorder(
                        dashPattern: [8, 4],
                        strokeWidth: 2,
                        child: Container(
                          height: 50,
                          width: 250,
                          color: Color(0xff2CC8DE),
                          child: Center(child: Text(refer)),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                    width: 10,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(left: 10.w,bottom: 0.0,top: 0.0,right: 10.w),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xff2CC8DE),
                          ),
                          onPressed: () {
                            SocialShare.shareOptions(
                                "$title\n$des\nReferral Code - $refer\n$referUrl");
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Text(
                                   getTranslated(context,'SHARE')!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  boxHeight(10),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        text(getTranslated(context, "RECENT_REFER")!,fontSize: 14.sp,fontFamily: fontMedium,textColor: Colors.black),
                      ],
                    ),
                  ),
                  Container(
                    child: referList.length>0?ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: referList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.all(10),
                            elevation: 3,
                            child: ListTile(
                              leading: Container(
                                height: 72,
                                width: 72,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imagePath+referList[index].user_image.toString(),
                                    height: 72,
                                    width: 72,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              title: text(referList[index].name,fontSize: 12.sp,fontFamily: fontMedium, textColor: Colors.black),
                              subtitle: text(referList[index].email,fontSize: 10.sp,fontFamily: fontMedium, textColor: Colors.black45),
                              trailing: Container(
                                height: 15,
                                width: 15,
                                decoration: referList[index].refer_status == "Complete"
                                    ? boxDecoration(radius: 100,bgColor: Colors.green)
                                    : boxDecoration(radius: 100,bgColor: Colors.red),
                              ),
                            ),
                          );
                        }):Center(
                      child: text(getTranslated(context, "NO_REFER")!,fontFamily: fontMedium,fontSize: 12.sp,textColor: Colors.black),
                    ),
                  ),
                ]))
          ]),
        ));
  }
}
