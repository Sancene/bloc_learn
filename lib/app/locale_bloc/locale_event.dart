part of 'locale_bloc.dart';

@immutable
abstract class LocaleEvent {}

class LoadLocale extends LocaleEvent {
  LoadLocale();
}
