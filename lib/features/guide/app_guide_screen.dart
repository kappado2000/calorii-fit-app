import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// In-app mirror of the functionality guide artifact — kept short per
/// section (mobile reading, not the full web document) and updated here
/// first whenever a feature changes, then ported into the artifact and
/// vice versa. Every string is localized across all 13 supported locales.
class AppGuideScreen extends StatelessWidget {
  const AppGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.guideScreenTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _GuideCard(icon: Icons.emoji_food_beverage_rounded, title: l10n.guideIntroTitle, body: l10n.guideIntroBody),
          _GuideCard(icon: Icons.camera_alt_rounded, title: l10n.guidePhotoTitle, body: l10n.guidePhotoBody),
          _GuideCard(icon: Icons.menu_book_rounded, title: l10n.guideLogTitle, body: l10n.guideLogBody),
          _GuideCard(icon: Icons.auto_stories_rounded, title: l10n.guideRecipesTitle, body: l10n.guideRecipesBody),
          _GuideCard(icon: Icons.fitness_center_rounded, title: l10n.guideWorkoutsTitle, body: l10n.guideWorkoutsBody),
          _GuideCard(icon: Icons.show_chart_rounded, title: l10n.guideProgressTitle, body: l10n.guideProgressBody),
          _GuideCard(icon: Icons.water_drop_rounded, title: l10n.guideHydrationTitle, body: l10n.guideHydrationBody),
          _GuideCard(icon: Icons.local_fire_department_rounded, title: l10n.guideStreaksTitle, body: l10n.guideStreaksBody),
          _GuideCard(icon: Icons.notifications_active_rounded, title: l10n.guideRemindersTitle, body: l10n.guideRemindersBody),
          _GuideCard(icon: Icons.person_rounded, title: l10n.guideProfileTitle, body: l10n.guideProfileBody),
          _GuideCard(icon: Icons.lock_rounded, title: l10n.guidePrivacyTitle, body: l10n.guidePrivacyBody),
          _GuideCard(icon: Icons.language_rounded, title: l10n.guideLanguagesTitle, body: l10n.guideLanguagesBody),
          _PremiumCard(l10n: l10n),
        ],
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(icon, color: colorScheme.onPrimary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(body, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Distinct from the other cards on purpose — this describes a plan, not a
/// shipped feature, so the draft note must stay visible for as long as
/// there's no real in-app purchase/paywall wired up.
class _PremiumCard extends StatelessWidget {
  const _PremiumCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: colorScheme.tertiaryContainer.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: colorScheme.tertiary, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Icon(Icons.workspace_premium_rounded, color: colorScheme.onTertiary, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.guidePremiumTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.guidePremiumDraftNote,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(l10n.guidePremiumFreeBody, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(l10n.guidePremiumPaidBody, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
