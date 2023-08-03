import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cabira/Components/custom_button.dart';
import 'package:cabira/Components/entry_field.dart';
import 'package:cabira/Locale/locale.dart';
import 'package:cabira/Locale/strings_enum.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../app_drawer.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  TextEditingController _controller = TextEditingController();
  ApiBaseHelper apiBase = new ApiBaseHelper();
  double totalBal = 0;
  double minimumBal = 0;
  bool isNetwork = false;
  bool saveStatus = false;
  addContact() async {
    try {
      setState(() {
        saveStatus = true;
      });
      Map params = {
        "driver_id": curUserId.toString(),
        "email": email.toString(),
        "name": name.toString(),
        "description": _controller.text.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Contact/contact_email"), params);
      setState(() {
        saveStatus = false;
      });
      if (response['status']) {
        setSnackbar(response['message'], context);
        back(context);
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
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      //  drawer: AppDrawer(false),
      body: FadedSlideAnimation(
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height + 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppBar(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        getTranslated(context, 'CONTACT_US')!,
                        style: theme.textTheme.headline4!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Text(
                        getTranslated(context, 'ENTER_PROMO_CODE_TO')!,
                        style: theme.textTheme.bodyText2,
                      ),
                    ),
                    SizedBox(height: 32),
                    /* Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            icon: Icons.call,
                            text: context.getString(Strings.CALL_US),
                            color: theme.cardColor,
                            textColor: theme.primaryColor,
                          ),
                        ),
                        Expanded(
                          child: CustomButton(
                            icon: Icons.email,
                            text: context.getString(Strings.EMAIL_US),
                          ),
                        ),
                      ],
                    ),*/
                    Expanded(
                      child: Container(
                        color: theme.backgroundColor,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(24, 48, 24, 0),
                                child: Text(
                                  getTranslated(context, 'WRITE_US')!,
                                  style: theme.textTheme.headline4,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                child: Text(
                                  getTranslated(context, 'DESC_YOUR_ISSUE')!,
                                  style: theme.textTheme.bodyText2!
                                      .copyWith(color: theme.hintColor),
                                ),
                              ),
                              SizedBox(height: 20),
                              EntryField(
                                label: getTranslated(context, 'YOUR_EMAIL'),
                                initialValue: email,
                                //readOnly: true,
                              ),
                              SizedBox(height: 20),
                              EntryField(
                                controller: _controller,
                                label:
                                    getTranslated(context, 'DESC_YOUR_ISSUE')!,
                              ),
                              // Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
      bottomNavigationBar: !saveStatus
          ? CustomButton(
              text: getTranslated(context, 'SUBMIT'),
              onTap: () {
                if (_controller.text == "") {
                  setSnackbar(getTranslated(context, "FILL_DESC")!, context);
                  return;
                }
                addContact();
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
