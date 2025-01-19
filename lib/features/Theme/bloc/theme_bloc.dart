import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeState(
          themeData: ThemeData.light(),
        )) {
    on<ToggleTheme>(_onToggleTheme);
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    final isLightTheme = state.themeData.brightness == Brightness.light;
    emit(ThemeState(themeData: isLightTheme ? ThemeData.dark() : ThemeData.light()));
  }
}
