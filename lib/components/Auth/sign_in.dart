import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nhost_dart/nhost_dart.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config.dart';
import '../../state.dart';
import 'state.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticationState = ref.watch(authSNP);
    if (authenticationState == AuthenticationState.inProgress) {
      EasyLoading.show(status: "Login in progress ...");
      return Container();
    }
    EasyLoading.dismiss();

    final logger = ref.read(loggerP);
    logger.d(getAuthURL('github'));
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton.icon(
        onPressed: () async {
          await launchUrl(Uri.parse(getAuthURL('github')),
              mode: LaunchMode.externalApplication);
        },
        icon: const Icon(FontAwesomeIcons.github),
        label: const Text('Sign in with GitHub'),
      ),
      const SizedBox(height: 40),
      ElevatedButton.icon(
        onPressed: () async {
          await launchUrl(Uri.parse(getAuthURL('google')),
              mode: LaunchMode.externalApplication);
        },
        icon: const Icon(FontAwesomeIcons.google),
        label: const Text('Sign in with Google'),
      )
    ]);
  }
}

//
