import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import 'admin_providers.dart';

/// Reachable from the food log's overflow menu by anyone signed in — the
/// common path (redeeming a premium code someone was given) is front and
/// center; admin activation is a secondary action tucked behind a small
/// link on the same screen, since only the one person who knows the
/// password ever uses it.
class AccessCodeScreen extends ConsumerStatefulWidget {
  const AccessCodeScreen({super.key});

  @override
  ConsumerState<AccessCodeScreen> createState() => _AccessCodeScreenState();
}

class _AccessCodeScreenState extends ConsumerState<AccessCodeScreen> {
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _totpController = TextEditingController();
  bool _showAdminField = false;
  bool _redeeming = false;
  bool _activatingAdmin = false;

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _totpController.dispose();
    super.dispose();
  }

  Future<void> _redeem() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _redeeming = true);
    try {
      final until = await ref.read(adminControllerProvider).redeemPremiumCode(code);
      if (!mounted) return;
      final formatted = DateFormat('d MMMM y', l10n.localeName).format(until);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.premiumActivatedMessage(formatted))));
      _codeController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _redeeming = false);
    }
  }

  Future<void> _activateAdmin() async {
    final password = _passwordController.text;
    final totpCode = _totpController.text.trim();
    if (password.isEmpty || totpCode.isEmpty) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _activatingAdmin = true);
    try {
      await ref.read(adminControllerProvider).activateAdmin(password, totpCode);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.adminActivatedMessage)));
      _passwordController.clear();
      _totpController.clear();
      setState(() => _showAdminField = false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _activatingAdmin = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.accessCodeScreenTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.premiumCodeFieldLabel, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _codeController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(labelText: l10n.premiumCodeFieldLabel),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _redeeming ? null : _redeem,
            child: _redeeming
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.activatePremiumButton),
          ),
          const SizedBox(height: 32),
          if (!_showAdminField)
            Center(
              child: TextButton(
                onPressed: () => setState(() => _showAdminField = true),
                child: Text(l10n.iAmAdminLink),
              ),
            )
          else ...[
            const Divider(),
            const SizedBox(height: 16),
            Text(l10n.adminPasswordFieldLabel, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.adminPasswordFieldLabel),
            ),
            const SizedBox(height: 12),
            Text(l10n.adminTotpFieldLabel, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _totpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.adminTotpFieldLabel),
              onSubmitted: (_) => _activateAdmin(),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _activatingAdmin ? null : _activateAdmin,
              child: _activatingAdmin
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l10n.activateAdminButton),
            ),
          ],
        ],
      ),
    );
  }
}
