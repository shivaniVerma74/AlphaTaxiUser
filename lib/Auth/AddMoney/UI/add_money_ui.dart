import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cabira/utils/Session.dart';
import 'package:flutter/material.dart';
import 'package:cabira/Locale/strings_enum.dart';
import 'package:cabira/Locale/locale.dart';
import 'package:cabira/Components/entry_field.dart';
import 'package:cabira/Components/custom_button.dart';
import 'add_money_interactor.dart';

class AddMoneyUI extends StatefulWidget {
  final AddMoneyInteractor addMoneyInteractor;

  AddMoneyUI(this.addMoneyInteractor);

  @override
  _AddMoneyUIState createState() => _AddMoneyUIState();
}

class _AddMoneyUIState extends State<AddMoneyUI> {
  TextEditingController _cardNumberController =
      TextEditingController(text: '5555 5555 5555 5555');
  TextEditingController _expiryController =
      TextEditingController(text: '12/25');
  TextEditingController _cvvController = TextEditingController(text: '666');
  TextEditingController _amountController =
      TextEditingController(text: '₹ 500.00');

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Scaffold(
      body: FadedSlideAnimation(
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Container(
                height: size.height + 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppBar(),
                    SizedBox(height: 12,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        getTranslated(context,'ADD_WALLET_MONEY')!,
                        style: theme.textTheme.headline4!.copyWith(fontSize: 35),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text(
                        getTranslated(context,'PAYMENT_MADE_EASY')!,
                        style: theme.textTheme.bodyText2!
                            .copyWith(color: theme.hintColor, fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 12,),
                    Expanded(
                      child: Container(
                        height: 600,
                        color: theme.backgroundColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Spacer(),
                            EntryField(
                              controller: _cardNumberController,
                              label: getTranslated(context,'CARD_NUMBER'),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: EntryField(
                                    controller: _expiryController,
                                    label: getTranslated(context,'EXPIRY_DATE'),
                                  ),
                                ),
                                Expanded(
                                  child: EntryField(
                                    controller: _cvvController,
                                    label: getTranslated(context,'CVV_CODE'),
                                  ),
                                ),
                              ],
                            ),
                            EntryField(
                              controller: _amountController,
                              label: getTranslated(context,'ENTER_AMOUNT'),
                            ),
                            Spacer(flex: 6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: getTranslated(context,'SKIP'),
                    onTap: () => widget.addMoneyInteractor.skip(),
                    color: theme.scaffoldBackgroundColor,
                    textColor: theme.primaryColor,
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    text: getTranslated(context,'ADD_MONEY'),
                    onTap: () => widget.addMoneyInteractor.addMoney(),
                  ),
                ),
              ],
            ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
