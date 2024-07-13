import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../dependency_injection.dart';
import '../../component/gap.dart';
import '../../component/text.dart';
import '../../config/app_router.dart';
import '../../extensions/context_extensions.dart';
import 'cubit/sign_in_cubit.dart';
import 'cubit/sign_in_state.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<SignInCubit>()..initialize(),
        child: _LoggedUserListener(
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TitleLarge(context.str.signInTitle),
                  const GapVertical24(),
                  const _GoogleSignInButton(),
                ],
              ),
            ),
          ),
        ),
      );
}

class _LoggedUserListener extends StatelessWidget {
  final Widget child;

  const _LoggedUserListener({required this.child});

  void _onAuthStateChanged(
    bool isUserAlreadySignedIn,
    BuildContext context,
  ) {
    if (isUserAlreadySignedIn) {
      context.replaceRoute(const MapRoute());
    }
  }

  @override
  Widget build(BuildContext context) => BlocListener<SignInCubit, SignInState>(
        listener: (_, state) =>
            _onAuthStateChanged(state.isUserAlreadySignedIn, context),
        child: child,
      );
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton();

  void _onPressed(BuildContext context) {
    context.read<SignInCubit>().signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) => FilledButton.icon(
        onPressed: () => _onPressed(context),
        icon: SvgPicture.asset(
          width: 24,
          height: 24,
          'assets/google_logo.svg',
        ),
        label: Text(context.str.signInWithGoogleLabel),
      );
}
