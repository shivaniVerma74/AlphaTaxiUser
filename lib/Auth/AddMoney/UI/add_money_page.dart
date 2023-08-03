import 'package:flutter/material.dart';
import 'add_money_interactor.dart';
import 'add_money_ui.dart';

class AddMoneyPage extends StatefulWidget {
  final VoidCallback onAddMoneyDone;

  AddMoneyPage(this.onAddMoneyDone);

  @override
  _AddMoneyPageState createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage>
    implements AddMoneyInteractor {
  @override
  Widget build(BuildContext context) {
    return AddMoneyUI(this);
  }

  @override
  void addMoney() {
    widget.onAddMoneyDone();
  }

  @override
  void skip() {
    widget.onAddMoneyDone();
  }
}
