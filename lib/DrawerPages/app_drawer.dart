import 'dart:async';
import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cabira/Auth/Login/UI/login_page.dart';
import 'package:cabira/BookRide/search_location_page.dart';
import 'package:cabira/DrawerPages/ChangePassword/change_password.dart';
import 'package:cabira/DrawerPages/ContactUs/contact_us_page.dart';
import 'package:cabira/DrawerPages/Profile/profile_page.dart';
import 'package:cabira/DrawerPages/Profile/reviews.dart';
import 'package:cabira/DrawerPages/PromoCode/promo_code_page.dart';
import 'package:cabira/DrawerPages/Refer%20Earn/refer_earn.dart';
import 'package:cabira/DrawerPages/Rides/intercity_rides.dart';
import 'package:cabira/DrawerPages/Rides/my_rides_page.dart';
import 'package:cabira/DrawerPages/Rides/rental_rides.dart';
import 'package:cabira/DrawerPages/Settings/settings_page.dart';
import 'package:cabira/DrawerPages/Wallet/wallet_page.dart';
import 'package:cabira/DrawerPages/faq_page.dart';
import 'package:cabira/DrawerPages/manage_address.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/colors.dart';
import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cabira/Assets/assets.dart';
import 'package:cabira/Locale/strings_enum.dart';
import 'package:cabira/Routes/page_routes.dart';
import 'package:cabira/Theme/style.dart';
import 'package:cabira/Locale/locale.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class AppDrawer extends StatefulWidget {
  final bool fromHome;
  ValueChanged onResult;
  AppDrawer({this.fromHome = true, required this.onResult});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    //addArray([1000, 100, 1000, 10, 100, 1, 5]);
    getNumber();
  }

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool loading = false;

  getNumber() async {
    try {
      Map params = {
        "user_id": curUserId.toString(),
      };
      var res = await http.get(
        Uri.parse(baseUrl1 + "Authentication/get_setting"),
      );
      Map response = jsonDecode(res.body);
      print(response);
      if (response['status']) {
        var data = response["data"];
        print(data);
        setState(() {
          userNumber = data['user_number'];
          cancelTime = data['ride_cancellation_time'];
        });
      } else {
        setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, "WRONG")!, context);
    }
  }

  void addArray(List<int> arr) {
    int index = 0;
    int total = 0;
    for (int i = 0; i < arr.length; i++) {
      if (i + 1 < arr.length && arr[i] < arr[i + 1] && index != i) {
        arr[i + 1] = arr[i + 1] - arr[i];
        index = i + 1;
        continue;
      } else {
        total += arr[i];
      }
    }
    print("Total = ${total}");
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  color: theme.scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          icon: Icon(Icons.close),
                          color: theme.primaryColor,
                          iconSize: 28,
                          onPressed: () => Navigator.pop(context)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
                        child: Row(
                          children: [
                            Container(
                              height: 72,
                              width: 72,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  image.toString(),
                                  height: 72,
                                  width: 72,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 150,
                                  child: Text(name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.headline5!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white)),
                                ),
                                SizedBox(height: 6),
                                Text(mobile != null ? mobile.toString() : "",
                                    style: theme.textTheme.caption!.copyWith(
                                        fontSize: 12, color: Colors.white)),
                                SizedBox(height: 4),
                                /*   Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: AppTheme.ratingsColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Text('4.2',
                                          style: TextStyle(fontSize: 12)),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.star,
                                        color: AppTheme.starColor,
                                        size: 10,
                                      )
                                    ],
                                  ),
                                ),*/
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              buildListTile(context, Icons.home, "HOME", () async {
                if (widget.fromHome)
                  Navigator.pop(context);
                else {
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchLocationPage()));
                  if (result != null) {
                    Navigator.pop(context);
                    widget.onResult(result);
                  }
                }
              }),
              buildListTile(context, Icons.person, "MY_PROFILE", () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              }),
              buildListTile(context, Icons.location_on, "Manage Address",
                  () async {
                var result = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddressScreen()));
                if (result != null) {
                  Navigator.pop(context);
                  widget.onResult(result);
                }
              }),
              buildListTile(context, Icons.drive_eta, "MY_RIDES", ()async {
               // Navigator.pop(context);
                var result = await  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyRidesPage("3")));
                if (result != null) {
                  Navigator.pop(context);
                  widget.onResult(result);
                }
              }),
              // buildListTile(context, Icons.history, "INTERCITY", () {
              //   Navigator.pop(context);
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => InterCityRidePage("3")));
              // }),
              buildListTile(context, Icons.account_balance_wallet, "WALLET",
                  () async {
                var result = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WalletPage()));
                if (result != null) {
                  Navigator.pop(context);
                  widget.onResult(result);
                }
              }),
              buildListTile(context, Icons.star, 'RATING', () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewsPage()),
                );
                if (result != null) {
                  Navigator.pop(context);
                  widget.onResult(result);
                }
                /*Navigator.popAndPushNamed(context, PageRoutes.reviewsPage);*/
              }),
              /* buildListTile(context, Icons.local_offer, Strings.PROMO_CODE,
                      () {
                    Navigator.pop(context);
                    Navigator.push(context,MaterialPageRoute(builder: (context)=> PromoCodePage()));
                  }),*/
              // ListTile(
              //   title: Text(
              //     getTranslated(context, "RENTAL_RIDES")!,
              //     style: TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              //   leading:
              //       Icon(Icons.location_on_outlined, color: MyColorName.primaryLite),
              //   /*   trailing: Text("₹500",style: TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //     ),),*/
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => RentalRides()),
              //     );
              //     /* Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => const ReferEarn()),
              //       );*/
              //   },
              // ),
              buildListTile(context, Icons.call, "EMERGENCY_CALL", () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  launch("tel://${userNumber}");
                                },
                                child: Text(
                                  "AlphaTaxi hotline",
                                  style: Theme.of(context).textTheme.titleLarge,
                                )),
                            Divider(),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  launch("https://wa.me/+91${userNumber}");
                                },
                                child: Text(
                                  "Whatsapp Chat",
                                  style: Theme.of(context).textTheme.titleLarge,
                                )),
                          ],
                        ),
                      );
                    });
              }),
              // buildListTile(context, Icons.airline_seat_recline_normal_rounded,
              //     "REFER_EARN", () {
              //   if (widget.fromHome)
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => ReferEarn()));
              //   else
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => ReferEarn()));
              // }),
              /*buildListTile(context, Icons.lock, "CHANGE_PASSWORD", () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangePassword()));
              }),*/
              // buildListTile(context, Icons.settings, "SETTINGS", () {
              //   Navigator.pop(context);
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => SettingsPage()));
              // }),
              buildListTile(context, Icons.help, "FAQS", () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FaqPage()));
              }),
              buildListTile(context, Icons.mail, "CONTACT_US", () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactUsPage()));
              }),
              buildListTile(context, Icons.drive_eta, 'BECOME', () {
                launch(playUrl);
                /*Navigator.popAndPushNamed(context, PageRoutes.reviewsPage);*/
              }),
              buildListTile(context, Icons.logout, "LOGOUT", () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(getTranslated(context, "LOGOUT")!),
                        content: Text(getTranslated(context, "DO_LOGOUT")!),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Text('No'),
                            /*   textColor: Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent)),*/
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                              child: Text('Yes'),
                              /* shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.transparent)),
                                textColor: Theme.of(context).colorScheme.primary,*/
                              onPressed: () async {
                                await App.init();
                                App.localStorage.clear();
                                //Common().toast("Logout");
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                    (route) => false);
                              }),
                        ],
                      );
                    });
              }),
            ],
          ),
        ),
      ),
    );
  }

  ListTile buildListTile(BuildContext context, IconData icon, String title,
      [Function? onTap]) {
    var theme = Theme.of(context);
    return ListTile(
      leading:
          FadedScaleAnimation(Icon(icon, color: theme.primaryColor, size: 24)),
      title: Text(
        getTranslated(context, title) != null
            ? getTranslated(context, title)!
            : title,
        style: theme.textTheme.headline5!
            .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      onTap: onTap as void Function()?,
    );
  }
}
