import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'auth_providers.dart';

/// Confirms and performs full account deletion — required by both the App
/// Store and Google Play for any app that lets people create an account.
/// Re-entering the password does double duty: it's the "are you sure"
/// confirmation for an irreversible action, and it satisfies Firebase's
/// requirement to reauthenticate before deleting an account.
class DeleteAccountDialog extends ConsumerStatefulWidget {
  const DeleteAccountDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(context: context, builder: (_) => const DeleteAccountDialog());
  }

  @override
  ConsumerState<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<DeleteAccountDialog> {
  final _passwordController = TextEditingController();
  bool _deleting = false;
  bool _passwordVisible = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final l10n = AppLocalizations.of(context);
    final password = _passwordController.text;
    if (password.isEmpty) return;
    setState(() {
      _deleting = true;
      _error = null;
    });
    try {
      await ref.read(accountDeletionServiceProvider).deleteAccountWithPassword(password);
      // No navigation needed — authStateChangesProvider fires as soon as
      // the account is gone, and the router redirects to the login screen
      // on its own (same mechanism as a normal sign-out).
      if (mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _deleting = false;
        _error = e.code == 'wrong-password' || e.code == 'invalid-credential'
            ? l10n.deleteAccountWrongPassword
            : l10n.deleteAccountFailed(e.code);
      });
    } catch (_) {
      setState(() {
        _deleting = false;
        _error = l10n.deleteAccountFailedGeneric;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.deleteAccountTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.deleteAccountExplanation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: !_passwordVisible,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.password,
              errorText: _error,
              suffixIcon: IconButton(
                tooltip: _passwordVisible ? l10n.hidePassword : l10n.showPassword,
                icon: Icon(_passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
              ),
            ),
            onSubmitted: (_) => _deleting ? null : _confirm(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _deleting ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
          onPressed: _deleting ? null : _confirm,
          child: _deleting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(l10n.deleteAccountConfirm),
        ),
      ],
    );
  }
}
