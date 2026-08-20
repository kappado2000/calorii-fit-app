import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/user_profile.dart';
import '../../l10n/app_localizations.dart';
import '../profile/profile_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

/// App store policy (Google explicitly bars weight-loss advertising to
/// minors; Apple treats diet/weight content as sensitive for younger
/// users too) plus the app's own disclaimer both assume an adult-ish
/// audience capable of consenting to a calorie deficit — set higher than
/// the generic COPPA 13, since this is specifically a weight-management
/// app, not a general-purpose utility.
const _minimumAge = 16;
const _maximumAge = 120;

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  bool _saving = false;

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _targetRateController = TextEditingController(text: '0.5');
  Sex _sex = Sex.female;
  ActivityLevel _activityLevel = ActivityLevel.sedentary;
  Goal _goal = Goal.lose;
  bool _disclaimerAccepted = false;
  DateTime? _existingDisclaimerAcceptedAt;

  /// The disclaimer step only shows for first-time setup — re-showing it
  /// every time someone edits their weight or goal would be friction for
  /// no benefit, since consent was already recorded once.
  bool _isFirstTimeSetup = true;

  int get _totalPages => _isFirstTimeSetup ? 5 : 4;

  @override
  void initState() {
    super.initState();
    // Editing an existing profile ("Editează profil/obiectiv") must start
    // from the saved values, not a blank form — the profile stream has
    // already emitted by the time this screen is reachable at all (either
    // fresh-signup onboarding never has a profile yet, or an edit always
    // does), so the cached stream value is available synchronously here.
    final existing = ref.read(userProfileProvider).valueOrNull;
    if (existing != null) {
      _isFirstTimeSetup = false;
      _ageController.text = existing.age.toString();
      _heightController.text = _formatNumber(existing.heightCm);
      _weightController.text = _formatNumber(existing.weightKg);
      _targetRateController.text = _formatNumber(existing.targetRateKgPerWeek);
      _sex = existing.sex;
      _activityLevel = existing.activityLevel;
      _goal = existing.goal;
      _existingProgramStartDate = existing.programStartDate;
      _existingDisclaimerAcceptedAt = existing.disclaimerAcceptedAt;
    }
  }

  // Editing must keep the original program-start anchor — the "since
  // program start" progress chart depends on it staying fixed, it isn't
  // meant to reset every time the user tweaks their goal.
  DateTime? _existingProgramStartDate;

  String _formatNumber(double value) {
    return value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toString();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _targetRateController.dispose();
    super.dispose();
  }

  bool get _canGoNext {
    switch (_page) {
      case 0:
        final age = int.tryParse(_ageController.text);
        return age != null && age >= _minimumAge && age <= _maximumAge;
      case 1:
        return double.tryParse(_heightController.text.replaceAll(',', '.')) != null &&
            double.tryParse(_weightController.text.replaceAll(',', '.')) != null;
      case 3:
        if (_goal == Goal.maintain) return true;
        return double.tryParse(_targetRateController.text.replaceAll(',', '.')) != null;
      case 4:
        return _disclaimerAccepted;
      default:
        return true;
    }
  }

  void _next() {
    if (_page < _totalPages - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_page > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
    }
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    final profile = UserProfile(
      heightCm: double.parse(_heightController.text.replaceAll(',', '.')),
      weightKg: double.parse(_weightController.text.replaceAll(',', '.')),
      age: int.parse(_ageController.text),
      sex: _sex,
      activityLevel: _activityLevel,
      goal: _goal,
      targetRateKgPerWeek: _goal == Goal.maintain
          ? 0
          : double.parse(_targetRateController.text.replaceAll(',', '.')),
      programStartDate: _existingProgramStartDate ?? DateTime.now(),
      disclaimerAcceptedAt: _existingDisclaimerAcceptedAt ?? DateTime.now(),
    );
    final controller = ref.read(profileControllerProvider);
    await controller.saveProfile(profile);
    // Seeds the weight-evolution chart/analysis with a real starting
    // point — without this, a user who has logged only one real weigh-in
    // has nothing to compare it against until a second one exists, even
    // though the onboarding weight *is* conceptually the diet's starting
    // weight. Only on first-time setup: editing an existing profile's
    // weight later (a correction, not a new weigh-in) shouldn't silently
    // insert a duplicate history entry.
    if (_isFirstTimeSetup) {
      await controller.logWeight(profile.weightKg, date: profile.programStartDate);
    }
    // The router no longer auto-redirects away from /onboarding once a
    // profile exists (that's what makes deliberate editing reachable at
    // all — see app_router.dart) — so returning to the food log after a
    // save, whether this was first-time setup or an edit, is now this
    // screen's job. go() rather than pop(): first-time onboarding has no
    // back-stack entry to pop (it's the router's forced redirect target).
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: _page > 0
            ? IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: _back)
            : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                for (var i = 0; i < _totalPages; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 6,
                      decoration: BoxDecoration(
                        color: i <= _page ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) => setState(() => _page = page),
              children: [
                _AgeSexStep(
                  ageController: _ageController,
                  sex: _sex,
                  onSexChanged: (sex) => setState(() => _sex = sex),
                  onTextChanged: () => setState(() {}),
                ),
                _HeightWeightStep(
                  heightController: _heightController,
                  weightController: _weightController,
                  onTextChanged: () => setState(() {}),
                ),
                _ActivityStep(
                  activityLevel: _activityLevel,
                  onChanged: (level) => setState(() => _activityLevel = level),
                ),
                _GoalStep(
                  goal: _goal,
                  targetRateController: _targetRateController,
                  onGoalChanged: (goal) => setState(() => _goal = goal),
                  onTextChanged: () => setState(() {}),
                ),
                if (_isFirstTimeSetup)
                  _DisclaimerStep(
                    accepted: _disclaimerAccepted,
                    onChanged: (value) => setState(() => _disclaimerAccepted = value),
                  ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: (_canGoNext && !_saving) ? _next : null,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_page == _totalPages - 1 ? l10n.finish : l10n.continueLabel),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({required this.title, required this.icon, required this.children});

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: colorScheme.primaryContainer, shape: BoxShape.circle),
            child: Icon(icon, color: colorScheme.onPrimaryContainer, size: 30),
          ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 20),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          ...children,
        ],
      ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.03, end: 0),
    );
  }
}

class _AgeSexStep extends StatelessWidget {
  const _AgeSexStep({
    required this.ageController,
    required this.sex,
    required this.onSexChanged,
    required this.onTextChanged,
  });

  final TextEditingController ageController;
  final Sex sex;
  final ValueChanged<Sex> onSexChanged;
  final VoidCallback onTextChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final age = int.tryParse(ageController.text);
    final ageError = age == null
        ? null
        : age < _minimumAge
        ? l10n.onboardingAgeTooLow(_minimumAge)
        : age > _maximumAge
        ? l10n.onboardingAgeInvalid
        : null;

    return _StepScaffold(
      title: l10n.onboardingAgeSexTitle,
      icon: Icons.cake_rounded,
      children: [
        TextField(
          controller: ageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: l10n.age, suffixText: l10n.years, errorText: ageError),
          onChanged: (_) => onTextChanged(),
        ),
        const SizedBox(height: 20),
        SegmentedButton<Sex>(
          segments: [
            ButtonSegment(value: Sex.female, label: Text(l10n.sexFemale)),
            ButtonSegment(value: Sex.male, label: Text(l10n.sexMale)),
          ],
          selected: {sex},
          onSelectionChanged: (selection) => onSexChanged(selection.first),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.onboardingSexHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _HeightWeightStep extends StatelessWidget {
  const _HeightWeightStep({
    required this.heightController,
    required this.weightController,
    required this.onTextChanged,
  });

  final TextEditingController heightController;
  final TextEditingController weightController;
  final VoidCallback onTextChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _StepScaffold(
      title: l10n.onboardingHeightWeightTitle,
      icon: Icons.straighten_rounded,
      children: [
        TextField(
          controller: heightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: l10n.height, suffixText: 'cm'),
          onChanged: (_) => onTextChanged(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: l10n.weight, suffixText: 'kg'),
          onChanged: (_) => onTextChanged(),
        ),
      ],
    );
  }
}

class _ActivityStep extends StatelessWidget {
  const _ActivityStep({required this.activityLevel, required this.onChanged});

  final ActivityLevel activityLevel;
  final ValueChanged<ActivityLevel> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return _StepScaffold(
      title: l10n.onboardingActivityTitle,
      icon: Icons.directions_run_rounded,
      children: [
        RadioGroup<ActivityLevel>(
          groupValue: activityLevel,
          onChanged: (value) => onChanged(value!),
          child: Column(
            children: [
              for (final level in ActivityLevel.values)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: activityLevel == level
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: RadioListTile<ActivityLevel>(
                    value: level,
                    title: Text(level.label(l10n)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalStep extends StatelessWidget {
  const _GoalStep({
    required this.goal,
    required this.targetRateController,
    required this.onGoalChanged,
    required this.onTextChanged,
  });

  final Goal goal;
  final TextEditingController targetRateController;
  final ValueChanged<Goal> onGoalChanged;
  final VoidCallback onTextChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _StepScaffold(
      title: l10n.onboardingGoalTitle,
      icon: Icons.flag_rounded,
      children: [
        SegmentedButton<Goal>(
          segments: Goal.values.map((g) => ButtonSegment(value: g, label: Text(g.label(l10n)))).toList(),
          selected: {goal},
          onSelectionChanged: (selection) => onGoalChanged(selection.first),
        ),
        if (goal != Goal.maintain) ...[
          const SizedBox(height: 20),
          TextField(
            controller: targetRateController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: goal == Goal.lose ? l10n.onboardingLossRate : l10n.onboardingGainRate,
              suffixText: l10n.kgPerWeek,
            ),
            onChanged: (_) => onTextChanged(),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingRateRecommendation,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}

/// Shown once, on first-time setup only — App Store/Google Play review
/// expects a clear "this isn't medical advice" acknowledgment for any app
/// that computes calorie/weight-loss targets, and it's good practice
/// regardless of store policy.
class _DisclaimerStep extends StatelessWidget {
  const _DisclaimerStep({required this.accepted, required this.onChanged});

  final bool accepted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return _StepScaffold(
      title: l10n.disclaimerTitle,
      icon: Icons.health_and_safety_outlined,
      children: [
        Text(
          l10n.disclaimerIntro,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        _DisclaimerPoint(
          icon: Icons.medical_services_outlined,
          text: l10n.disclaimerMedical,
        ),
        _DisclaimerPoint(
          icon: Icons.warning_amber_rounded,
          text: l10n.disclaimerAllergens,
        ),
        _DisclaimerPoint(
          icon: Icons.favorite_border_rounded,
          text: l10n.disclaimerEatingDisorders,
        ),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onChanged(!accepted),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Checkbox(value: accepted, onChanged: (value) => onChanged(value ?? false)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    l10n.disclaimerAcceptLabel,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DisclaimerPoint extends StatelessWidget {
  const _DisclaimerPoint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
