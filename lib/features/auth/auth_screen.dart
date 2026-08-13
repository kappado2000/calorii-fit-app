import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import 'auth_providers.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

enum _AuthMode { signIn, register }

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  _AuthMode _mode = _AuthMode.signIn;
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    final controller = ref.read(authControllerProvider);
    try {
      if (_mode == _AuthMode.signIn) {
        await controller.signInWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await controller.registerWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _messageForAuthError(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Introdu emailul mai întâi, ca să-ți trimitem linkul de resetare.');
      return;
    }
    try {
      await ref.read(authControllerProvider).sendPasswordResetEmail(email);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Ți-am trimis un email de resetare a parolei.')));
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _messageForAuthError(e));
    }
  }

  String _messageForAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Adresă de email invalidă.';
      case 'user-not-found':
        return 'Nu există niciun cont cu acest email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email sau parolă greșită.';
      case 'email-already-in-use':
        return 'Există deja un cont cu acest email.';
      case 'weak-password':
        return 'Parola e prea slabă (minim 6 caractere).';
      default:
        return e.message ?? 'A apărut o eroare. Încearcă din nou.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSignIn = _mode == _AuthMode.signIn;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      gradient: context.appColors.heroGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: context.appColors.cardShadow,
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.restaurant_rounded, size: 40, color: Colors.white),
                  ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                  Text(
                    'Calorii Fit',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isSignIn ? 'Bine ai revenit' : 'Hai să începem',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline_rounded),
                    ),
                    validator: (value) =>
                        (value == null || !value.contains('@')) ? 'Introdu un email valid' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Parolă',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                    validator: (value) =>
                        (value == null || value.length < 6) ? 'Minim 6 caractere' : null,
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: colorScheme.onErrorContainer),
                      ),
                    ).animate().shake(duration: 400.ms),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(isSignIn ? 'Autentificare' : 'Creează cont'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => setState(() {
                      _mode = isSignIn ? _AuthMode.register : _AuthMode.signIn;
                      _errorMessage = null;
                    }),
                    child: Text(
                      isSignIn ? 'Nu ai cont? Creează unul' : 'Ai deja cont? Autentifică-te',
                    ),
                  ),
                  if (isSignIn)
                    TextButton(onPressed: _resetPassword, child: const Text('Ai uitat parola?')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
