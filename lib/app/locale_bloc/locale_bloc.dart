import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'locale_event.dart';

part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleState.initial()) {
    on<LoadLocale>((event, emit) {
      if (state.locale == Locale("ru")) {
        emit(state.copyWith(locale: Locale('en')));
      } else {
        emit(state.copyWith(locale: Locale('ru')));
      }
    });
  }
}
