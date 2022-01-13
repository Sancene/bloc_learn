import 'package:bloc/bloc.dart';
import 'package:bloc_learn/theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial());

  void SwitchTheme() {
    if (state.theme == themes[AppTheme.lightTheme])
      emit(state.copyWith(theme: themes[AppTheme.darkTheme]));
    else
      emit(state.copyWith(theme: themes[AppTheme.lightTheme]));
  }
}
