import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/premium_code.dart';
import '../../l10n/app_localizations.dart';
import 'admin_providers.dart';

/// Admin-only screen (only ever pushed when isAdminProvider is true — see
/// food_log_screen.dart's overflow menu) — the "control over how many
/// codes, which accounts, for how long" the admin role exists for: mint a
/// new code bound to one account, see every code ever generated and its
/// redemption status, and the two headline subscriber counts.
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  final _emailController = TextEditingController();
  final _daysController = TextEditingController(text: '30');
  bool _generating = false;

  @override
  void dispose() {
    _emailController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final email = _emailController.text.trim();
    final days = int.tryParse(_daysController.text.trim());
    if (email.isEmpty || days == null || days <= 0) return;

    final l10n = AppLocalizations.of(context);
    setState(() => _generating = true);
    try {
      final code = await ref
          .read(adminControllerProvider)
          .generatePremiumCode(targetEmail: email, durationDays: days);
      if (!mounted) return;
      _emailController.clear();
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l10n.codeGeneratedTitle),
          content: SelectableText(code, style: Theme.of(context).textTheme.headlineSmall),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.close))],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stats = ref.watch(premiumStatsProvider);
    final codes = ref.watch(premiumCodesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminDashboardTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.people_outline_rounded,
                  label: l10n.totalUsersLabel,
                  value: stats.valueOrNull?.totalUsers.toString() ?? '—',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.workspace_premium_outlined,
                  label: l10n.activePremiumLabel,
                  value: stats.valueOrNull?.activePremiumUsers.toString() ?? '—',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(l10n.generateCodeSectionTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: l10n.targetEmailLabel),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _daysController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.durationDaysLabel),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _generating ? null : _generate,
            icon: _generating
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.qr_code_2_rounded),
            label: Text(l10n.generateCodeButton),
          ),
          const SizedBox(height: 28),
          Text(l10n.generatedCodesSectionTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          codes.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.errorPrefixed(error.toString())),
            ),
            data: (list) => list.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l10n.noCodesGeneratedYet),
                  )
                : Column(children: [for (final code in list) _PremiumCodeTile(code: code)]),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _PremiumCodeTile extends StatelessWidget {
  const _PremiumCodeTile({required this.code});

  final PremiumCode code;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final (statusLabel, statusColor) = switch (code.status) {
      PremiumCodeStatus.pending => (l10n.codeStatusPending, colorScheme.tertiary),
      PremiumCodeStatus.redeemed => (l10n.codeStatusRedeemed, const Color(0xFF1FAE7E)),
      PremiumCodeStatus.revoked => (l10n.codeStatusRevoked, colorScheme.error),
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(code.code, style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1)),
        subtitle: Text('${code.targetEmail} · ${l10n.durationDaysValue(code.durationDays)}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
          child: Text(statusLabel, style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12)),
        ),
        isThreeLine: false,
      ),
    );
  }
}
