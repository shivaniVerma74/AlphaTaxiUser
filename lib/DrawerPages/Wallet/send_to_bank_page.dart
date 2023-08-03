import 'package:cabira/utils/Session.dart';
import 'package:flutter/material.dart';
import 'package:cabira/Components/custom_button.dart';
import 'package:cabira/Components/entry_field.dart';
import 'package:cabira/DrawerPages/app_drawer.dart';
import 'package:cabira/Locale/locale.dart';
import 'package:cabira/Locale/strings_enum.dart';

class SendToBankPage extends StatefulWidget {
  @override
  _SendToBankPageState createState() => _SendToBankPageState();
}

class _SendToBankPageState extends State<SendToBankPage> {
  TextEditingController _bankNameController =
      TextEditingController(text: 'Bank of Nation');
  TextEditingController _accountNumberController =
      TextEditingController(text: '5886 7445 8996 4525');
  TextEditingController _bankCodeController =
      TextEditingController(text: 'VFFC48695');
  TextEditingController _amountController =
      TextEditingController(text: '₹ 100');

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _bankCodeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      //  drawer: AppDrawer(false),
      body: Stack(
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
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Text(
                      getTranslated(context, 'AVAILABLE_AMOUNT')!,
                      style: theme.textTheme.bodyText2!
                          .copyWith(color: theme.hintColor),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '₹ 159.85',
                      style: theme.textTheme.headline4!
                          .copyWith(color: theme.hintColor),
                    ),
                  ),
                  SizedBox(height: 32),
                  Expanded(
                    child: Container(
                      color: theme.backgroundColor,
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          EntryField(
                            controller: _bankNameController,
                            label: getTranslated(context, 'BANK_NAME'),
                          ),
                          EntryField(
                            controller: _accountNumberController,
                            label: getTranslated(context, 'ACCOUNT_NUMBER'),
                          ),
                          EntryField(
                            controller: _bankCodeController,
                            label: getTranslated(context, 'BANK_CODE'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            color: theme.cardColor,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: EntryField(
                              controller: _amountController,
                              label: getTranslated(
                                  context, 'ENTER_AMOUNT_TO_TRANSFER'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            start: 0,
            end: 0,
            child: CustomButton(
              text: getTranslated(context, 'SUBMIT'),
              onTap: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}
