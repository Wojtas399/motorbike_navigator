import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../component/gap.dart';
import '../../component/text.dart';
import '../../extensions/context_extensions.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
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
      );
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton();

  void _onPressed(BuildContext context) {
    //TODO
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
