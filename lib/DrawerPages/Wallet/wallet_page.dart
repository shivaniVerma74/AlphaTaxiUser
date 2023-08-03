import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cabira/BookRide/search_location_page.dart';
import 'package:cabira/Components/entry_field.dart';
import 'package:cabira/Locale/locale.dart';
import 'package:cabira/Locale/strings_enum.dart';
import 'package:cabira/Model/wallet_model.dart';
import 'package:cabira/Routes/page_routes.dart';
import 'package:cabira/Theme/style.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/Razorpay.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/colors.dart';
import 'package:cabira/utils/constant.dart';
import 'package:cabira/utils/khalti_pay.dart';
import 'package:cabira/utils/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sizer/sizer.dart';
import '../app_drawer.dart';

class WalletPage extends StatefulWidget {
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  ApiBaseHelper apiBase = new ApiBaseHelper();
  double totalBal = 0;
  double minimumBal = 0;
  bool isNetwork = false;
  bool saveStatus = true;
  bool showText = false;
  TextEditingController amount = new TextEditingController();
  getSetting() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "user_id": curUserId.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Authentication/minimum_balance"), params);
      setState(() {
        saveStatus = true;
      });
      if (response['status']) {
        var data = response["data"][0];
        print(data);
        minimumBal = double.parse(data['wallet_amount'].toString());
        amount.text = minimumBal.toString().split(".")[0];
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

  List<WalletModel> walletList = [];

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

  List<WithdrawModel> withdrawList = [];
  getWithdraw() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "driver_id": curUserId.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Authentication/get_widrwwal"), params);
      setState(() {
        saveStatus = true;
      });
      if (response['status']) {
        var data = response["data"];
        for (var v in data) {
          setState(() {
            withdrawList.add(new WithdrawModel(
                v['id'], v['amount'], v['status'], v['added_date']));
          });
        }
        print(data);
        totalBal = double.parse(response['wallet'].toString());
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

  bool loading = false;
  bool showWithdraw = false;
  addWallet(orderId) async {
    try {
      setState(() {
        loading = true;
      });
      Map params = {
        "user_id": curUserId.toString(),
        "amount": amount.text.contains(".")
            ? amount.text.toString().split(".")[0]
            : amount.text.toString(),
        "transaction_id": orderId.toString(),
        "txn_date": DateTime.now().toString(),
        "status": "Paid",
        "gateway_name": "Razorpay",
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "users/addWallet"), params);
      setState(() {
        loading = false;
      });
      if (response['status']) {
        setSnackbar(response['message'], context);
        getWallet();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSetting();
    getWallet();
    getWithdraw();
  }

  Future<bool> onWill() {
    Navigator.pop(context, true);
    /* Navigator.popUntil(
      context,
      ModalRoute.withName('/'),
    );*/
    /*Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SearchLocationPage()),
        (route) => false);*/

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: onWill,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        //   drawer: AppDrawer(false),
        body: SingleChildScrollView(
          child: saveStatus
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              child: Text(
                                getTranslated(context, "AVAILABLE_AMOUNT1")!,
                                style: theme.textTheme.bodyText2!
                                    .copyWith(color: theme.hintColor),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                '₹$totalBal',
                                style: theme.textTheme.headline4!
                                    .copyWith(color: theme.hintColor),
                              ),
                            ),
                          ],
                        ),
                        /*Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          child: Text(
                            context.getString(Strings.Joining)!,
                            style:
                            theme.textTheme.bodyText2!.copyWith(color: theme.hintColor),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            '₹500.00',
                            style: theme.textTheme.headline4,
                          ),
                        ),
                      ],
                    ),*/
                      ],
                    ),
                    SizedBox(height: 32),
                    Container(
                      width: getWidth(330),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                showText = !showText;
                              });
                            },
                            child: Container(
                              width: 80.w,
                              height: 5.h,
                              decoration: boxDecoration(
                                  radius: 5,
                                  bgColor: Theme.of(context).primaryColor),
                              child: Center(
                                  child: text(
                                      showText
                                          ? getTranslated(context, "HIDE")!
                                          : getTranslated(
                                              context, "ADD_MONEY")!,
                                      fontFamily: fontMedium,
                                      fontSize: 10.sp,
                                      isCentered: true,
                                      textColor: Colors.white)),
                            ),
                          ),
                          /* InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  SendToBankPage(totalBal.toString(),minimumBal.toString())),
                          );
                        },
                        child: Container(
                          width: 42.w,
                          height: 5.h,
                          decoration: boxDecoration(
                              radius: 5,
                              bgColor: Theme.of(context)
                                  .primaryColor),
                          child: Center(
                              child: text("Withdraw Money",
                                  fontFamily: fontMedium,
                                  fontSize: 10.sp,
                                  isCentered: true,
                                  textColor: Colors.white)),
                        ),
                      ),*/
                        ],
                      ),
                    ),
                    boxHeight(10),
                    showText
                        ? Container(
                            width: getWidth(330),
                            decoration:
                                boxDecoration(radius: 10, showShadow: true),
                            child: Column(
                              children: [
                                EntryField(
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                  controller: amount,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  label: "Enter Amount",
                                ),
                                boxHeight(10),
                                InkWell(
                                  onTap: () {
                                    if (amount.text == "") {
                                      setSnackbar(
                                          "Please Enter Amount", context);
                                      return;
                                    }
                                    /*KhaltiPayHelper khaltiPay =
                                          new KhaltiPayHelper(
                                              amount.text, context, (result) {
                                        if (result != "error") {
                                          addWallet(result);
                                        } else {
                                          setState(() {
                                            loading = false;
                                          });
                                        }
                                      });
                                      setState(() {
                                        loading = true;
                                      });
                                      khaltiPay.init();*/
                                    RazorPayHelper razorPay =
                                        new RazorPayHelper(amount.text, context,
                                            (result) {
                                      if (result != "error") {
                                        addWallet(result);
                                      } else {
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                    });
                                    setState(() {
                                      loading = true;
                                    });
                                    razorPay.init();
                                  },
                                  child: Container(
                                    width: 80.w,
                                    height: 5.h,
                                    decoration: boxDecoration(
                                        radius: 5,
                                        bgColor:
                                            Theme.of(context).primaryColor),
                                    child: Center(
                                        child: !loading
                                            ? text(
                                                getTranslated(
                                                    context, "ADD_MONEY")!,
                                                fontFamily: fontMedium,
                                                fontSize: 10.sp,
                                                isCentered: true,
                                                textColor: Colors.white)
                                            : CircularProgressIndicator(
                                                color: Colors.white,
                                              )),
                                  ),
                                ),
                                boxHeight(10),
                              ],
                            ),
                          )
                        : SizedBox(),
                    boxHeight(10),
                    /*  Container(
                  width: getWidth(330),
                  child: text(totalBal<500?"Note-You need to add minimum ₹${minimumBal} to get booking request.":"Note-Please maintain ₹${minimumBal} minimum balance to take rides.",
                  fontSize: 10.sp,
                    fontFamily: fontMedium,
                    textColor: Colors.red
                  ),
                ),*/
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated(context, 'RECENT_TRANS')!,
                            style: theme.textTheme.bodyText2!
                                .copyWith(color: theme.hintColor),
                          ),
                          /*InkWell(
                        onTap: (){
                          setState(() {
                            showWithdraw = !showWithdraw;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(getWidth(10)),
                          decoration: boxDecoration(radius: 10,color: MyColorName.primaryDark),
                          child: Text(
                            showWithdraw?"Hide History":"Withdraw History",
                            style:
                            theme.textTheme.bodyText2!.copyWith(color: theme.hintColor),
                          ),
                        ),
                      ),*/
                        ],
                      ),
                    ),
                    !showWithdraw
                        ? saveStatus
                            ? walletList.length > 0
                                ? ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: walletList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => Padding(
                                      padding: EdgeInsets.only(bottom: 4.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 6),
                                        tileColor: theme.backgroundColor,
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                              height: getWidth(72),
                                              width: getWidth(72),
                                              child: Image.network(image,
                                                  height: 60, width: 60)),
                                        ),
                                        title: Text(
                                          "${getTranslated(context, "TRAN_ID")} - ${walletList[index].transactionId}",
                                          style: theme.textTheme.headline6!
                                              .copyWith(fontSize: 12.sp),
                                        ),
                                        subtitle: Text(
                                          '${getDate(walletList[index].createdAt)}',
                                          style: theme.textTheme.caption,
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              ' ₹${walletList[index].amount}',
                                              style: theme.textTheme.headline6!
                                                  .copyWith(
                                                      color: walletList[index]
                                                                  .wallet_type ==
                                                              null
                                                          ? Colors.red
                                                          : Colors.green,
                                                      fontSize: 17),
                                            ),
                                            /*  SizedBox(height: 4),
                          Text(
                            context.getString(Strings.RIDE_INFO)! + '  >',
                            style: theme.textTheme.caption!
                                .copyWith(color: theme.primaryColor),
                          ),*/
                                          ],
                                        ),
                                        onTap: () => Navigator.pushNamed(
                                            context, PageRoutes.rideInfoPage),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: text(
                                        getTranslated(
                                            context, "NO_TRANSACTION")!,
                                        fontFamily: fontMedium,
                                        fontSize: 12.sp,
                                        textColor: Colors.black),
                                  )
                            : Center(child: CircularProgressIndicator())
                        : saveStatus
                            ? walletList.length > 0
                                ? ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: withdrawList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => Padding(
                                      padding: EdgeInsets.only(bottom: 4.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 6),
                                        tileColor: theme.backgroundColor,
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(image.toString(),
                                              height: 60, width: 60),
                                        ),
                                        title: Text(
                                          withdrawList[index].status == "0"
                                              ? "Status - Pending"
                                              : withdrawList[index].status ==
                                                      "1"
                                                  ? "Status - Confirm"
                                                  : "Status - Cancel",
                                          style: theme.textTheme.headline6!
                                              .copyWith(fontSize: 17),
                                        ),
                                        subtitle: Text(
                                          '${getDate(withdrawList[index].added_date)}',
                                          style: theme.textTheme.caption,
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              ' ₹${withdrawList[index].amount}',
                                              style: theme.textTheme.headline6!
                                                  .copyWith(
                                                      color: Colors.green,
                                                      fontSize: 17),
                                            ),
                                            /*  SizedBox(height: 4),
                          Text(
                            context.getString(Strings.RIDE_INFO)! + '  >',
                            style: theme.textTheme.caption!
                                .copyWith(color: theme.primaryColor),
                          ),*/
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: text(
                                        getTranslated(
                                            context, "NO_WITHDRAWAL")!,
                                        fontFamily: fontMedium,
                                        fontSize: 12.sp,
                                        textColor: Colors.black),
                                  )
                            : Center(child: CircularProgressIndicator())
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class WithdrawModel {
  String id, amount, status, added_date;
  WithdrawModel(this.id, this.amount, this.status, this.added_date);
}
