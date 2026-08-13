import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  static const _totalPages = 4;

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
      default:
        return true;
    }
  }

  void _next() {
    if (_page < _totalPages - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_page > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
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
      programStartDate: DateTime.now(),
    );
    await ref.read(profileControllerProvider).saveProfile(profile);
    // No navigation needed — app_router's redirect reacts to
    // userProfileProvider automatically once the write lands.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _page > 0
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _back)
            : null,
        title: Text('Pasul ${_page + 1} din $_totalPages'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_page + 1) / _totalPages),
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
                        child: CircularProgressIndicator(strokeWidth: 2),
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
  const _StepScaffold({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
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
    return _StepScaffold(
      title: 'Nivel de activitate fizică',
      children: [
        RadioGroup<ActivityLevel>(
          groupValue: activityLevel,
          onChanged: (value) => onChanged(value!),
          child: Column(
            children: [
              for (final level in ActivityLevel.values)
                RadioListTile<ActivityLevel>(value: level, title: Text(level.label)),
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
