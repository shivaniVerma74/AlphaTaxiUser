import 'package:flutter/material.dart';
import '../../login_navigator.dart';
import 'registration_interactor.dart';
import 'registration_ui.dart';

class RegisterPage extends StatelessWidget {
  final String? phoneNumber;

  RegisterPage(this.phoneNumber);

  @override
  Widget build(BuildContext context) {
    return RegistrationBody(phoneNumber);
  }
}

class RegistrationBody extends StatefulWidget {
  final String? phoneNumber;

  RegistrationBody(this.phoneNumber);

  @override
  _RegistrationBodyState createState() => _RegistrationBodyState();
}

class _RegistrationBodyState extends State<RegistrationBody>
    implements RegistrationInteractor {
  @override
  Widget build(BuildContext context) {
    return RegistrationUI( widget.phoneNumber,"","");
  }

  @override
  void register(String name, String email) {
    Navigator.pushNamed(context, LoginRoutes.verification);
  }
}
