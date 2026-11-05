import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// "Delete my account" from Profile.
///
/// Asks the member to confirm and to enter their password again, then calls
/// the `deleteMyAccount` function, which removes the account and all of the
/// member's data. Finally clears this device and returns to Sign in.
Future<void> deleteMyAccountFlow(BuildContext context) async {
  final l = FFLocalizations.of(context);
  final theme = FlutterFlowTheme.of(context);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l.getText('khdel001')),
      content: Text(l.getText('khdel002')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          style: TextButton.styleFrom(foregroundColor: theme.error),
          child: Text(l.getText('khdel003')),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) {
    return;
  }

  final password = TextEditingController();
  final entered = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l.getText('khdel004')),
      content: TextField(
        controller: password,
        obscureText: true,
        autofocus: true,
        decoration: InputDecoration(labelText: l.getText('khdel005')),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          style: TextButton.styleFrom(foregroundColor: theme.error),
          child: Text(l.getText('khdel003')),
        ),
      ],
    ),
  );
  final secret = password.text;
  password.dispose();
  if (entered != true || secret.isEmpty || !context.mounted) {
    return;
  }

  void snack(String text) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
  void closeProgress() {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  try {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      throw FirebaseAuthException(code: 'no-current-user');
    }
    await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: secret));
    // A fresh token carries the new sign-in time the function checks.
    await user.getIdToken(true);
    await FirebaseFunctions.instance
        .httpsCallable('deleteMyAccount',
            options:
                HttpsCallableOptions(timeout: const Duration(seconds: 300)))
        .call(<String, dynamic>{});
  } on FirebaseAuthException catch (e) {
    closeProgress();
    snack(l.getText(
        e.code == 'wrong-password' || e.code == 'invalid-credential'
            ? 'khdel006'
            : 'khdel007'));
    return;
  } catch (_) {
    closeProgress();
    snack(l.getText('khdel007'));
    return;
  }

  closeProgress();
  if (!context.mounted) {
    return;
  }
  GoRouter.of(context).prepareAuthEvent();
  await actions.clearMemberOfflineData();
  try {
    await authManager.signOut();
  } catch (_) {
    // The account no longer exists; the local session is cleared anyway.
  }
  if (!context.mounted) {
    return;
  }
  GoRouter.of(context).clearRedirectLocation();
  snack(l.getText('khdel008'));
  context.goNamedAuth(SignInPageWidget.routeName, context.mounted);
}
