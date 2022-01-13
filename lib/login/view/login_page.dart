import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_learn/app/locale_bloc/locale_bloc.dart';
import 'package:bloc_learn/app/theme_cubit/theme_cubit.dart';
import 'package:bloc_learn/generated/l10n.dart';
import 'package:bloc_learn/login/cubit/login_cubit.dart';
import 'package:bloc_learn/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).login),
        actions: [
          TextButton(
            onPressed: () =>
                BlocProvider.of<LocaleBloc>(context)..add(LoadLocale()),
            child: Text(
              S.of(context).changeLocale,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () => BlocProvider.of<ThemeCubit>(context).SwitchTheme(),
            child: const Text(
              'Theme',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
          child: const LoginForm(),
        ),
      ),
    );
  }
}
