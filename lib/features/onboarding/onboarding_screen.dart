import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/user_profile.dart';
import '../profile/profile_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

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
        return int.tryParse(_ageController.text) != null;
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
    await ref.read(profileControllerProvider).saveProfile(profile);
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
                    : Text(_page == _totalPages - 1 ? 'Finalizează' : 'Continuă'),
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
    return _StepScaffold(
      title: 'Câțiva ani și sexul biologic',
      icon: Icons.cake_rounded,
      children: [
        TextField(
          controller: ageController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Vârstă', suffixText: 'ani'),
          onChanged: (_) => onTextChanged(),
        ),
        const SizedBox(height: 20),
        SegmentedButton<Sex>(
          segments: const [
            ButtonSegment(value: Sex.female, label: Text('Femeie')),
            ButtonSegment(value: Sex.male, label: Text('Bărbat')),
          ],
          selected: {sex},
          onSelectionChanged: (selection) => onSexChanged(selection.first),
        ),
        const SizedBox(height: 8),
        Text(
          'Folosit doar pentru calculul metabolismului bazal (formula Mifflin-St Jeor).',
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
    return _StepScaffold(
      title: 'Înălțime și greutate actuală',
      icon: Icons.straighten_rounded,
      children: [
        TextField(
          controller: heightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Înălțime', suffixText: 'cm'),
          onChanged: (_) => onTextChanged(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Greutate', suffixText: 'kg'),
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
    return _StepScaffold(
      title: 'Nivel de activitate fizică',
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
                    title: Text(level.label),
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
    return _StepScaffold(
      title: 'Care e obiectivul tău?',
      icon: Icons.flag_rounded,
      children: [
        SegmentedButton<Goal>(
          segments: Goal.values.map((g) => ButtonSegment(value: g, label: Text(g.label))).toList(),
          selected: {goal},
          onSelectionChanged: (selection) => onGoalChanged(selection.first),
        ),
        if (goal != Goal.maintain) ...[
          const SizedBox(height: 20),
          TextField(
            controller: targetRateController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: goal == Goal.lose ? 'Ritm de slăbit dorit' : 'Ritm de creștere dorit',
              suffixText: 'kg/săptămână',
            ),
            onChanged: (_) => onTextChanged(),
          ),
          const SizedBox(height: 8),
          Text(
            'Recomandat: 0.25-0.75 kg/săptămână pentru un ritm sustenabil.',
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
    return _StepScaffold(
      title: 'Înainte să începi',
      icon: Icons.health_and_safety_outlined,
      children: [
        Text(
          'Calorii Fit estimează necesarul caloric și ritmul de slăbit pe baza unor '
          'formule general acceptate (Mifflin-St Jeor), nu pe baza unei evaluări '
          'medicale individuale. Nu înlocuiește sfatul unui medic sau nutriționist, '
          'mai ales dacă ai o afecțiune medicală, ești însărcinată sau alăptezi.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
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
                    'Am înțeles și sunt de acord să folosesc aplicația în cunoștință de cauză.',
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
