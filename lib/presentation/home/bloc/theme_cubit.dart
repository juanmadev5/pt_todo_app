import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  bool _isDark = false;

  void toggleTheme() {
    _isDark = !_isDark;
    emit(_isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
