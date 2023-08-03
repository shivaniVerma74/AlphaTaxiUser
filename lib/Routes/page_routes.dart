import 'package:cabira/DrawerPages/Refer%20Earn/refer_earn.dart';
import 'package:flutter/material.dart';
import 'package:cabira/Auth/login_navigator.dart';
import 'package:cabira/BookRide/choose_cab_page.dart';
import 'package:cabira/BookRide/finding_ride_page.dart';
import 'package:cabira/BookRide/ride_booked_page.dart';
import 'package:cabira/BookRide/search_location_page.dart';
import 'package:cabira/DrawerPages/ContactUs/contact_us_page.dart';
import 'package:cabira/DrawerPages/Profile/profile_page.dart';
import 'package:cabira/DrawerPages/PromoCode/promo_code_page.dart';
import 'package:cabira/DrawerPages/Rides/my_rides_page.dart';
import 'package:cabira/DrawerPages/Rides/ride_info_page.dart';
import 'package:cabira/DrawerPages/Settings/settings_page.dart';
import 'package:cabira/DrawerPages/Wallet/send_to_bank_page.dart';
import 'package:cabira/DrawerPages/Wallet/wallet_page.dart';
import 'package:cabira/DrawerPages/faq_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PageRoutes {
  static const String loginNavigator = 'login_navigator';
  static const String searchLocationPage = 'search_location_page';
  static const String chooseCabPage = 'choose_cab_page';
  static const String findingRidePage = 'finding_ride_page';
  static const String rideBookedPage = 'ride_booked_page';
  static const String profilePage = 'profile_page';
  static const String myRidesPage = 'my_rides_page';
  static const String rideInfoPage = 'ride_info_page';
  static const String walletPage = 'wallet_page';
  static const String referPage = 'refer_earn';
  static const String promoCodePage = 'promo_code_page';
  static const String contactUsPage = 'contact_us_page';
  static const String faqPage = 'faq_page';
  static const String sendToBankPage = 'send_to_bank_page';
  static const String settingsPage = 'settings_page';

  Map<String, WidgetBuilder> routes() {
    return {
      loginNavigator: (context) => LoginNavigator(),
      searchLocationPage: (context) => SearchLocationPage(),
      chooseCabPage: (context) => ChooseCabPage(
          LatLng(0, 0), LatLng(0, 0), "", "", "", "", "", null, ""),
      findingRidePage: (context) =>
          FindingRidePage(LatLng(0, 0), LatLng(0, 0), "", "", "", "", "", ""),
      //rideBookedPage: (context) => RideBookedPage(),
      profilePage: (context) => ProfilePage(),
      myRidesPage: (context) => MyRidesPage("3"),
      rideInfoPage: (context) => MyRidesPage("3"),
      walletPage: (context) => WalletPage(),
      referPage: (context) => ReferEarn(),
      promoCodePage: (context) => PromoCodePage(),
      contactUsPage: (context) => ContactUsPage(),
      faqPage: (context) => FaqPage(),
      sendToBankPage: (context) => SendToBankPage(),
      settingsPage: (context) => SettingsPage(),
    };
  }
}
