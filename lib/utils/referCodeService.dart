import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

class ReferCodeService {
  BuildContext context;
  ValueChanged? onResult;

  ReferCodeService(this.context, {this.onResult});

  BranchUniversalObject? buo;
  String referCode = "";
  BranchLinkProperties lp = BranchLinkProperties();
  Future init(code) async {
    await App.init();
    referCode = refer.toString();
    print(code.toString());
    buo = BranchUniversalObject(
        title: 'Sahaytri',
        canonicalIdentifier: 'flutter/branch',
        //parameter canonicalUrl
        //If your content lives both on the web and in the app, make sure you set its canonical URL
        // (i.e. the URL of this piece of content on the web) when building any BUO.
        // By doing so, we’ll attribute clicks on the links that you generate back to their original web page,
        // even if the user goes to the app instead of your website! This will help your SEO efforts.
        canonicalUrl: 'https://flutter.dev',
        imageUrl:
            'https://flutter.dev/assets/flutter-lockup-4cb0ee072ab312e59784d9fbf4fb7ad42688a7fdaea1270ccf6bbf4f34b7e03f.svg',
        contentDescription: 'Ride App',
        publiclyIndex: true,
        locallyIndex: true,
        contentMetadata: BranchContentMetaData(),
        expirationDateInMilliSec:
            DateTime.now().add(Duration(days: 365)).millisecondsSinceEpoch);
    FlutterBranchSdk.validateSDKIntegration();
    FlutterBranchSdk.registerView(buo: buo!);
    lp = BranchLinkProperties(
      channel: 'facebook',
      feature: 'sharing',
      //parameter alias
      //Instead of our standard encoded short url, you can specify the vanity alias.
      // For example, instead of a random string of characters/integers, you can set the vanity alias as *.app.link/devonaustin.
      // Aliases are enforced to be unique** and immutable per domain, and per link - they cannot be reused unless deleted.
      //alias: 'https://branch.io' //define link url,
      stage: 'new share',
      campaign: 'launch',
    )
      //  ..addControlParam('refer_code', referCode)
      ..addControlParam('codeId', code.toString())
      ..addControlParam('custom_random', DateTime.now().millisecond.toString());
    print("okay");

    _generateDeepLink(context);
  }

  void _generateDeepLink(BuildContext context) async {
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp);
    print("okay" + response.success.toString());
    print(response.result.toString());
    if (response.success) {
      if (onResult != null) {
        onResult!(response.result.toString());
      }

      referUrl = response.result.toString();
      print(response.result);

      // Toast.show("${response.result}",context);
    } else {
      print('${response.errorCode} - ${response.errorMessage}');
    }
  }
}
