part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeData theme;

  ThemeState({required this.theme});

  factory ThemeState.initial() => ThemeState(theme: themes[AppTheme.lightTheme]!);

  ThemeState copyWith({
    ThemeData? theme,
  }) {
    return ThemeState(
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object?> get props => [theme];
}
