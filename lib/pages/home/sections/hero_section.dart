import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/localization/locale_cubit.dart';
import '../../../core/localization/app_strings.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onExploreProjects;
  final VoidCallback? onContactMe;

  const HeroSection({
    super.key,
    this.onExploreProjects,
    this.onContactMe,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final locale = context.watch<LocaleCubit>().state.languageCode;

    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surface,
            colorScheme.primaryContainer.withValues(alpha: 0.1),
            colorScheme.surface,
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Stack(
        children: [
          // Background Decorative Shapes
          Positioned(
            right: locale == 'ar' ? null : -100,
            left: locale == 'ar' ? -100 : null,
            top: 50,
            child: _DecorativeCircle(color: colorScheme.primaryContainer),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .moveY(begin: -20, end: 20, duration: 4.seconds, curve: Curves.easeInOut),
          
          Positioned(
            left: locale == 'ar' ? null : 50,
            right: locale == 'ar' ? 50 : null,
            bottom: 100,
            child: _DecorativeCircle(color: colorScheme.tertiaryContainer, size: 200),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .moveX(begin: -30, end: 30, duration: 5.seconds, curve: Curves.easeInOut),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, size: 16, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.get('hero_badge', locale),
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 40),
                
                Text(
                  AppStrings.get('hero_title', locale),
                  style: textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: MediaQuery.of(context).size.width > 800 ? 100 : 50,
                    height: 1,
                  ),
                ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),

                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [colorScheme.primary, colorScheme.tertiary],
                  ).createShader(bounds),
                  child: Text(
                    AppStrings.get('hero_subtitle', locale),
                    style: textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 32),

                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Text(
                    AppStrings.get('hero_description', locale),
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 56),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PrimaryCTA(
                      label: AppStrings.get('hero_cta_primary', locale),
                      onPressed: onExploreProjects ?? () {},
                    ),
                    const SizedBox(width: 24),
                    _SecondaryCTA(
                      label: AppStrings.get('hero_cta_secondary', locale),
                      onPressed: onContactMe ?? () {},
                    ),
                  ],
                ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.5, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final Color color;
  final double size;
  const _DecorativeCircle({required this.color, this.size = 400});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

class _PrimaryCTA extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  const _PrimaryCTA({required this.label, required this.onPressed});

  @override
  State<_PrimaryCTA> createState() => _PrimaryCTAState();
}

class _PrimaryCTAState extends State<_PrimaryCTA> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final s = _isHovered ? 1.05 : 1.0;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        transform: Matrix4.diagonal3Values(s, s, 1.0),
        child: FilledButton(
          onPressed: widget.onPressed,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: Text(widget.label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class _SecondaryCTA extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  const _SecondaryCTA({required this.label, required this.onPressed});

  @override
  State<_SecondaryCTA> createState() => _SecondaryCTAState();
}

class _SecondaryCTAState extends State<_SecondaryCTA> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final s = _isHovered ? 1.05 : 1.0;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        transform: Matrix4.diagonal3Values(s, s, 1.0),
        child: OutlinedButton(
          onPressed: widget.onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            side: BorderSide(width: 2, color: Theme.of(context).colorScheme.primary),
          ),
          child: Text(widget.label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
