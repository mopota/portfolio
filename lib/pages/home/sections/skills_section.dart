import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/localization/locale_cubit.dart';
import '../../../core/localization/app_strings.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final locale = context.watch<LocaleCubit>().state.languageCode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppStrings.get('skills_title', locale),
            style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
          ).animate().fadeIn().scale(),
          const SizedBox(height: 16),
          Text(
            AppStrings.get('skills_subtitle', locale),
            style: textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 80),
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _SkillHex(icon: Icons.flutter_dash, label: AppStrings.get('skill_flutter', locale), color: Colors.blue),
              _SkillHex(icon: Icons.android, label: AppStrings.get('skill_kotlin', locale), color: Colors.green),
              _SkillHex(icon: Icons.storage, label: AppStrings.get('skill_isar', locale), color: Colors.orange),
              _SkillHex(icon: Icons.cloud, label: AppStrings.get('skill_firebase', locale), color: Colors.amber),
              _SkillHex(icon: Icons.psychology, label: AppStrings.get('skill_ai', locale), color: Colors.purple),
              _SkillHex(icon: Icons.speed, label: AppStrings.get('skill_perf', locale), color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillHex extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SkillHex({required this.icon, required this.label, required this.color});

  @override
  State<_SkillHex> createState() => _SkillHexState();
}

class _SkillHexState extends State<_SkillHex> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Column(
        children: [
          AnimatedContainer(
            duration: 300.ms,
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: _isHovered ? widget.color.withValues(alpha: 0.1) : colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(_isHovered ? 40 : 24),
              border: Border.all(
                color: _isHovered ? widget.color : colorScheme.outline.withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: Icon(widget.icon, size: 48, color: _isHovered ? widget.color : colorScheme.onSurface),
          ),
          const SizedBox(height: 16),
          Text(
            widget.label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _isHovered ? widget.color : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).scale();
  }
}
