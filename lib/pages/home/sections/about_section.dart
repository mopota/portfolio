import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/localization/locale_cubit.dart';
import '../../../core/localization/app_strings.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final locale = context.watch<LocaleCubit>().state.languageCode;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 120),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.get('about_label', locale),
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ).animate().fadeIn().slideX(begin: locale == 'ar' ? 0.2 : -0.2),
                    const SizedBox(height: 24),
                    Text(
                      AppStrings.get('about_title', locale),
                      style: textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        fontSize: locale == 'ar' ? 45 : null,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 40),
                    Text(
                      AppStrings.get('about_p1', locale),
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w300,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 32),
                    Text(
                      AppStrings.get('about_p2', locale),
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ).animate().fadeIn(delay: 600.ms),
                  ],
                ),
              ),
              const SizedBox(width: 80),
              if (MediaQuery.of(context).size.width > 900)
                Expanded(
                  flex: 3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 400,
                        height: 500,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true))
                       .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 3.seconds),
                      
                      Container(
                        width: 350,
                        height: 450,
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true))
                       .scale(begin: const Offset(1.1, 1.1), end: const Offset(1, 1), duration: 4.seconds),
                      
                      const Icon(Icons.architecture, size: 120, color: Colors.white)
                          .animate(onPlay: (c) => c.repeat())
                          .rotate(duration: 10.seconds),
                    ],
                  ).animate().fadeIn(delay: 800.ms).scale(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
