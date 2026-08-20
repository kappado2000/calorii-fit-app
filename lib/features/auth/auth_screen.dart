import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = l10n.authEnterEmailFirst);
      return;
    }
    try {
      await ref.read(authControllerProvider).sendPasswordResetEmail(email);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.authPasswordResetSent)));
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _messageForAuthError(e));
    }
  }

  String _messageForAuthError(FirebaseAuthException e) {
    final l10n = AppLocalizations.of(context);
    switch (e.code) {
      case 'invalid-email':
        return l10n.authErrorInvalidEmail;
      case 'user-not-found':
        return l10n.authErrorUserNotFound;
      case 'wrong-password':
      case 'invalid-credential':
        return l10n.authErrorWrongCredentials;
      case 'email-already-in-use':
        return l10n.authErrorEmailInUse;
      case 'weak-password':
        return l10n.authErrorWeakPassword;
      default:
        return e.message ?? l10n.authErrorGeneric;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSignIn = _mode == _AuthMode.signIn;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

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
                  ShaderMask(
                    shaderCallback: (bounds) => context.appColors.heroGradient.createShader(bounds),
                    child: Text(
                      l10n.appTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 34,
                        letterSpacing: -0.5,
                        height: 1.0,
                        // ShaderMask paints the gradient through this color's
                        // alpha channel, so it must stay opaque white, not
                        // the theme's normal text color.
                        color: Colors.white,
                      ),
                    ),
                  ).animate().fadeIn(delay: 150.ms, duration: 400.ms).slideY(begin: 0.25, end: 0, curve: Curves.easeOutCubic),
                  const SizedBox(height: 6),
                  Text(
                    isSignIn ? l10n.authWelcomeBack : l10n.authLetsStart,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      prefixIcon: const Icon(Icons.mail_outline_rounded),
                    ),
                    validator: (value) =>
                        (value == null || !value.contains('@')) ? l10n.authEnterValidEmail : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                    ),
                    validator: (value) =>
                        (value == null || value.length < 6) ? l10n.authPasswordMinLength : null,
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
                        : Text(isSignIn ? l10n.authSignIn : l10n.authCreateAccount),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => setState(() {
                      _mode = isSignIn ? _AuthMode.register : _AuthMode.signIn;
                      _errorMessage = null;
                    }),
                    child: Text(
                      isSignIn ? l10n.authNoAccountYet : l10n.authHaveAccountAlready,
                    ),
                  ),
                  if (isSignIn)
                    TextButton(onPressed: _resetPassword, child: Text(l10n.authForgotPassword)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
