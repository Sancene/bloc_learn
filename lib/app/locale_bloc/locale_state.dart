part of 'locale_bloc.dart';

class LocaleState extends Equatable {
  final Locale locale;

  LocaleState({required this.locale});

  factory LocaleState.initial() => LocaleState(locale: Locale('ru'));

  LocaleState copyWith({
    Locale? locale,
  }) {
    return LocaleState(
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [locale];
}
