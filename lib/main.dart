import 'dart:io';

import 'package:cabira/Auth/Login/UI/login_page.dart';
import 'package:cabira/Theme/style.dart';
import 'package:cabira/splash_screen.dart';
import 'package:cabira/utils/Demo_Localization.dart';
import 'package:cabira/utils/PushNotificationService.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cabira/Auth/login_navigator.dart';
import 'package:cabira/DrawerPages/Settings/language_cubit.dart';
import 'package:cabira/DrawerPages/Settings/theme_cubit.dart';
import 'package:cabira/Routes/page_routes.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'Locale/locale.dart';
import 'map_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  MapUtils.getMarkerPic();
  MobileAds.instance.initialize();

  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: AppTheme.primaryColor, // status bar color
  ));
  String? locale = prefs.getString('locale');
  bool? isDark = prefs.getBool('theme');
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => LanguageCubit(locale)),
    BlocProvider(create: (context) => ThemeCubit(isDark ?? false)),
  ], child: Cabira()));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class Cabira extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _CabiraState state = context.findAncestorStateOfType<_CabiraState>()!;
    state.setLocale(newLocale);
  }

  @override
  State<Cabira> createState() => _CabiraState();
}

class _CabiraState extends State<Cabira> {
  bool _isKeptOn = true;
  double _brightness = 1.0;
  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  Locale? _locale;

  setLocale(Locale locale) {
    if (mounted)
      setState(() {
        _locale = locale;
      });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      if (mounted)
        setState(() {
          this._locale = locale;
        });
    });
    super.didChangeDependencies();
  }

  initPlatformState() async {
    await App.init();
    bool keptOn = await Screen.isKeptOn;
    if (App.localStorage.getBool("lock") != null) {
      doLock = App.localStorage.getBool("lock")!;
      Screen.keepOn(App.localStorage.getBool("lock"));
    }
    if (App.localStorage.getBool("notification") != null) {
      notification = App.localStorage.getBool("notification")!;
    }
    double brightness = await Screen.brightness;
    setState(() {
      _isKeptOn = keptOn;
      _brightness = brightness;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return KhaltiScope(
        publicKey: "test_public_key_d5d9f63743584dc38753056b0cc737d5",
        enabledDebugging: true,
        builder: (context, navKey) {
          return Sizer(builder: (context, orientation, deviceType) {
            return BlocBuilder<LanguageCubit, Locale>(
              builder: (context, locale) {
                return BlocBuilder<ThemeCubit, ThemeData>(
                  builder: (context, theme) {
                    return MaterialApp(
                      locale: _locale,
                      supportedLocales: [
                        Locale("en", "US"),
                        Locale("ne", "NPL"),
                      ],
                      navigatorKey: navKey,
                      localizationsDelegates: [
                        DemoLocalization.delegate,
                        KhaltiLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      localeResolutionCallback: (locale, supportedLocales) {
                        for (var supportedLocale in supportedLocales) {
                          if (supportedLocale.languageCode ==
                                  locale!.languageCode &&
                              supportedLocale.countryCode ==
                                  locale.countryCode) {
                            return supportedLocale;
                          }
                        }
                        return supportedLocales.first;
                      },
                      theme: theme,
                      home: SplashScreen(),
                      // routes: PageRoutes().routes(),
                      debugShowCheckedModeBanner: false,
                    );
                  },
                );
              },
            );
          });
        });
  }
}
