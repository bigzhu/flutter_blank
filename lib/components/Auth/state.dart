import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nhost_dart/nhost_dart.dart';
import 'package:logger/logger.dart';

import '../../state.dart';
import '../../utils/index.dart';

class AuthStateNotifier extends StateNotifier<AuthenticationState> {
  final Ref ref;
  late NhostAuthClient auth;
  late Logger logger;
  AuthStateNotifier(this.ref) : super(AuthenticationState.inProgress) {
    auth = ref.watch(nhostClientP).auth;
    logger = ref.watch(loggerP);
    autoSignIn();
  }
  Future<void> autoSignIn() async {
    try {
      await auth.signInWithStoredCredentials();
      state = auth.authenticationState;
      return;
    } on Exception catch (e) {
      logger.e('$e');
      showError('$e');
    }
    state = AuthenticationState.signedOut;
  }

  Future<void> completeOAuth(Uri uri) async {
    state = AuthenticationState.inProgress;
    await auth.completeOAuthProviderSignIn(uri);
    state = auth.authenticationState;
    // use close to save the token
    ref.watch(nhostClientP).close();
  }

  Future<void> logout() async {
    state = AuthenticationState.inProgress;
    await auth.signOut();
    state = auth.authenticationState;
    ref.watch(nhostClientP).close();
  }
}

final authSNP =
    StateNotifierProvider<AuthStateNotifier, AuthenticationState>((ref) {
  return AuthStateNotifier(ref);
});
