import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cabira/Theme/style.dart';

class ThemeCubit extends Cubit<ThemeData> {
  final bool isDark;
  ThemeCubit(this.isDark)
      : super(isDark ? AppTheme.darkTheme : AppTheme.lightTheme);

  void selectLightTheme() {
    emit(AppTheme.lightTheme);
  }

  void selectDarkTheme() {
    emit(AppTheme.darkTheme);
  }
}
