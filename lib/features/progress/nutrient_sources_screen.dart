import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/micronutrient_reference.dart';
import '../../domain/usecases/nutrient_sources_calculator.dart';
import '../../l10n/app_localizations.dart';
import 'progress_providers.dart';

/// Predominant foods, e.g. "Piept de pui — 32%" — separate from the
/// macro/micronutrient *totals* on ProgressScreen (which answer "how much
/// protein did I eat"), this answers "which foods actually gave me that
/// protein", broken out into two dedicated sections per the user's
/// explicit request for two separate analyses rather than one merged view.
class NutrientSourcesScreen extends ConsumerStatefulWidget {
  const NutrientSourcesScreen({super.key});

  @override
  ConsumerState<NutrientSourcesScreen> createState() => _NutrientSourcesScreenState();
}

class _NutrientSourcesScreenState extends ConsumerState<NutrientSourcesScreen> {
  ProgressPeriod _period = ProgressPeriod.last7Days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(nutrientSourcesProvider(_period)).valueOrNull ?? NutrientSourcesSummary.empty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nutrientSourcesTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<ProgressPeriod>(
            segments: ProgressPeriod.values
                .map((p) => ButtonSegment(value: p, label: Text(p.label(l10n))))
                .toList(),
            selected: {_period},
            onSelectionChanged: (selection) => setState(() => _period = selection.first),
          ),
          const SizedBox(height: 20),
          _NutrientSourcesSection(
            title: l10n.macroSourcesSectionTitle,
            icon: Icons.pie_chart_rounded,
            color: const Color(0xFF7C5CFC),
            entries: [
              for (final macro in MacroNutrient.values)
                (label: macro.label(l10n), sources: summary.macroSources[macro] ?? const []),
            ],
            emptyMessage: l10n.nutrientSourcesNoData,
          ),
          const SizedBox(height: 16),
          _NutrientSourcesSection(
            title: l10n.micronutrientSourcesSectionTitle,
            icon: Icons.science_outlined,
            color: const Color(0xFF1FAE7E),
            entries: [
              for (final nutrient in Micronutrient.values)
                (
                  label: nutrient.label(l10n),
                  sources: summary.micronutrientSources[nutrient] ?? const [],
                ),
            ],
            emptyMessage: l10n.nutrientSourcesNoData,
          ),
        ],
      ),
    );
  }
}

class _NutrientSourcesSection extends StatelessWidget {
  const _NutrientSourcesSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.entries,
    required this.emptyMessage,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<({String label, List<NutrientSource> sources})> entries;
  final String emptyMessage;

  /// Only nutrients with at least one contributing food are worth a
  /// section — an empty one would just be dead space (micronutrient
  /// coverage is inherently partial, see MicronutrientProfile).
  List<({String label, List<NutrientSource> sources})> get _nonEmpty =>
      entries.where((e) => e.sources.isNotEmpty).toList();

  @override
  Widget build(BuildContext context) {
    final nonEmpty = _nonEmpty;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: color, width: 1.5)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            if (nonEmpty.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(emptyMessage, style: Theme.of(context).textTheme.bodyMedium),
              )
            else
              for (var i = 0; i < nonEmpty.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                _SingleNutrientSources(label: nonEmpty[i].label, sources: nonEmpty[i].sources, accent: color),
              ],
          ],
        ),
      ),
    );
  }
}

class _SingleNutrientSources extends StatelessWidget {
  const _SingleNutrientSources({required this.label, required this.sources, required this.accent});

  final String label;
  final List<NutrientSource> sources;
  final Color accent;

  /// Predominant sources only — a long tail of one-off foods each
  /// contributing a sliver isn't useful to show, and "restul alimentelor"
  /// absorbs them into one honest catch-all share instead.
  static const _topCount = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final top = sources.take(_topCount).toList();
    final othersShare = sources.skip(_topCount).fold<double>(0, (sum, s) => sum + s.sharePercent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        for (final source in top) _SourceRow(name: source.foodName, sharePercent: source.sharePercent, accent: accent),
        if (othersShare >= 0.5)
          _SourceRow(
            name: l10n.nutrientSourcesOthers,
            sharePercent: othersShare,
            accent: colorScheme.onSurfaceVariant,
            italic: true,
          ),
      ],
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.name, required this.sharePercent, required this.accent, this.italic = false});

  final String name;
  final double sharePercent;
  final Color accent;
  final bool italic;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontStyle: italic ? FontStyle.italic : FontStyle.normal),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (sharePercent / 100).clamp(0, 1),
                minHeight: 6,
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: accent,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              '${sharePercent.round()}%',
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
