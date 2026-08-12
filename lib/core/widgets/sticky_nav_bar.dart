import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../theme/theme_cubit.dart';
import '../localization/locale_cubit.dart';
import '../localization/app_strings.dart';

class StickyNavBar extends StatelessWidget {
  final VoidCallback? onWorkTap;
  final VoidCallback? onAboutTap;
  final VoidCallback? onContactTap;

  const StickyNavBar({
    super.key,
    this.onWorkTap,
    this.onAboutTap,
    this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = context.watch<LocaleCubit>().state.languageCode;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.7),
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.05),
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => context.go('/'),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'MT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (MediaQuery.of(context).size.width > 600)
                      Text(
                        AppStrings.get('hero_title', locale).toUpperCase(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              if (MediaQuery.of(context).size.width > 850) ...[
                _NavButton(label: AppStrings.get('nav_work', locale), onTap: onWorkTap ?? () => context.go('/')),
                _NavButton(label: AppStrings.get('nav_about', locale), onTap: onAboutTap ?? () => context.go('/')),
                _NavButton(label: AppStrings.get('nav_services', locale), onTap: () {}),
              ],
              const SizedBox(width: 8),
              
              // Language Selector
              _LanguageSwitcher(),
              
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    context.watch<ThemeCubit>().state == ThemeMode.light
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    size: 18,
                  ),
                  onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: onContactTap ?? () => context.go('/'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(100, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  AppStrings.get('nav_talk', locale), 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentLocale = context.watch<LocaleCubit>().state.languageCode;

    return PopupMenuButton<String>(
      onSelected: (code) => context.read<LocaleCubit>().setLocale(code),
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleCubit.supportedLanguages.firstWhere((l) => l['code'] == currentLocale)['flag']!,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              currentLocale.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
      itemBuilder: (context) => LocaleCubit.supportedLanguages.map((lang) {
        return PopupMenuItem<String>(
          value: lang['code'],
          child: Row(
            children: [
              Text(lang['flag']!, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 12),
              Text(lang['name']!, style: const TextStyle(fontWeight: FontWeight.w500)),
              if (currentLocale == lang['code']) ...[
                const Spacer(),
                Icon(Icons.check, size: 16, color: colorScheme.primary),
              ]
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _NavButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavButton({required this.label, required this.onTap});

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextButton(
        onPressed: widget.onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: _isHovered ? Theme.of(context).colorScheme.primary : null,
                  ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: _isHovered ? 20 : 0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
