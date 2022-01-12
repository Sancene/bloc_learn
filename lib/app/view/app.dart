import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_learn/app/app.dart';
import 'package:bloc_learn/app/locale_bloc/locale_bloc.dart';
import 'package:bloc_learn/theme.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_learn/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required AuthenticationRepository authenticationRepository,
  })
      : _authenticationRepository = authenticationRepository,
        super(key: key);

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) =>
            AppBloc(
              authenticationRepository: _authenticationRepository,
            ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleBloc>(
      create: (localeBlocContext) => LocaleBloc(),
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: state.locale,
            supportedLocales: S.delegate.supportedLocales,
            theme: theme,
            home: FlowBuilder<AppStatus>(
              state: context.select((AppBloc bloc) => bloc.state.status),
              onGeneratePages: onGenerateAppViewPages,
            ),
          );
        },
      ),
    );
  }
}
