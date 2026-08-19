import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
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
            ? 'Parolă greșită.'
            : 'Nu am putut șterge contul (${e.code}). Încearcă din nou.';
      });
    } catch (_) {
      setState(() {
        _deleting = false;
        _error = 'Nu am putut șterge contul. Încearcă din nou.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Ștergere cont'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Se șterg definitiv contul și toate datele tale (profil, jurnal de mese, '
            'antrenamente, greutăți, alimente memorate). Acțiunea nu poate fi anulată.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Parolă',
              errorText: _error,
            ),
            onSubmitted: (_) => _deleting ? null : _confirm(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _deleting ? null : () => Navigator.of(context).pop(),
          child: const Text('Anulează'),
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
              : const Text('Șterge definitiv'),
        ),
      ],
    );
  }
}
