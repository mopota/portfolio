import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/localization/app_strings.dart';
import '../../core/localization/locale_cubit.dart';
import '../../core/widgets/back_to_top.dart';
import '../../core/widgets/sticky_nav_bar.dart';
import '../../data/project_repository.dart';
import '../../models/project.dart';

class ProjectDetailsPage extends StatefulWidget {
  final String projectId;

  const ProjectDetailsPage({
    super.key,
    required this.projectId,
  });

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String locale =
        context.watch<LocaleCubit>().state.languageCode;

    final Project? loadedProject =
        ProjectRepository.getProjectById(widget.projectId);

    final bool projectFound = loadedProject != null;

    final Project project = loadedProject ??
        const Project(
          id: 'not-found',
          titles: {
            'en': 'Project Not Found',
            'ar': 'المشروع غير موجود',
          },
          categories: {
            'en': '',
            'ar': '',
          },
          descriptions: {
            'en': '',
            'ar': '',
          },
          folder: '',
          contents: {
            'en': '# Project Not Found',
            'ar': '# المشروع غير موجود',
          },
          tags: [],
          links: {},
          images: ProjectImages(
            hero: 'hero.png',
            logo: 'logo.png',
            screenshots: [],
          ),
        );

    

    final bool isArabic = locale == 'ar';

    return Directionality(
      textDirection:
          isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            ListView(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 110),

                Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          _BackButton(
                            locale: locale,
                            onPressed: () =>
                                context.go('/'),
                          ),

                          const SizedBox(height: 28),

                          if (projectFound) ...[
                            _ProjectHeader(
                              project: project,
                              locale: locale,
                            ),

                            const SizedBox(height: 36),

                            _ProjectInfoGrid(
                              project: project,
                            ),

                            const SizedBox(height: 48),

                            _HeroImage(
                              project: project,
                            ),

                            const SizedBox(height: 56),

                            if (project.logoImage.isNotEmpty)
                              _ProjectLogo(
                                project: project,
                              ),

                            const SizedBox(height: 40),

                            _ProjectContent(
                              project: project,
                              locale: locale,
                            ),

                            const SizedBox(height: 64),

                            if (project.screenshotImages
                                .isNotEmpty)
                              _ScreenshotGallery(
                                project: project,
                              ),

                            const SizedBox(height: 72),

                            if (project.links.isNotEmpty)
                              _ProjectLinks(
                                project: project,
                                locale: locale,
                              ),

                            const SizedBox(height: 120),
                          ] else ...[
                            _NotFoundState(
                              locale: locale,
                            ),

                            const SizedBox(height: 160),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: StickyNavBar(),
            ),
          ],
        ),
        floatingActionButton: BackToTop(
          scrollController: _scrollController,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Back button
// -----------------------------------------------------------------------------

class _BackButton extends StatelessWidget {
  final String locale;
  final VoidCallback onPressed;

  const _BackButton({
    required this.locale,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = locale == 'ar';

    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        isArabic
            ? Icons.arrow_forward
            : Icons.arrow_back,
      ),
      label: Text(
        AppStrings.get(
          'back_to_projects',
          locale,
        ),
      ),
    )
        .animate()
        .fadeIn()
        .slideX(
          begin: isArabic ? 0.15 : -0.15,
        );
  }
}

// -----------------------------------------------------------------------------
// Header
// -----------------------------------------------------------------------------

class _ProjectHeader extends StatelessWidget {
  final Project project;
  final String locale;

  const _ProjectHeader({
    required this.project,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    final TextTheme textTheme =
        Theme.of(context).textTheme;

    final double width =
        MediaQuery.sizeOf(context).width;

    final bool isMobile = width < 600;

    final String category =
        project.getCategory(locale);

    final String title =
        project.getTitle(locale);

    final String description =
        project.getDescription(locale);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        if (category.isNotEmpty)
          Text(
            category.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              letterSpacing: isMobile ? 1.8 : 3.5,
              fontWeight: FontWeight.w900,
            ),
          )
              .animate()
              .fadeIn(delay: 150.ms),

        const SizedBox(height: 14),

        Text(
          title,
          softWrap: true,
          style: textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1.05,
            fontSize: isMobile
                ? 38
                : textTheme.displayLarge?.fontSize,
          ),
        )
            .animate()
            .fadeIn(delay: 250.ms)
            .slideY(begin: 0.08),

        if (description.isNotEmpty) ...[
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: 850),
            child: Text(
              description,
              style: textTheme.titleMedium?.copyWith(
                height: 1.6,
                color: colorScheme.onSurface
                    .withValues(alpha: 0.72),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 350.ms),
        ],
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Project info
// -----------------------------------------------------------------------------

class _ProjectInfoGrid extends StatelessWidget {
  final Project project;

  const _ProjectInfoGrid({
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final String locale =
        context.watch<LocaleCubit>().state.languageCode;

    return Wrap(
      spacing: 32,
      runSpacing: 24,
      children: [
        _InfoItem(
          label: AppStrings.get(
            'project_role',
            locale,
          ),
          value: AppStrings.get(
            'project_role_lead',
            locale,
          ),
        ),

        _InfoItem(
          label: AppStrings.get(
            'project_tech',
            locale,
          ),
          isTags: true,
          tags: project.tags,
        ),

        if (project.links.containsKey('GitHub Pages'))
          _InfoItem(
            label: AppStrings.get(
              'project_live',
              locale,
            ),
            value: AppStrings.get(
              'project_status_prod',
              locale,
            ),
          ),
      ],
    )
        .animate()
        .fadeIn(delay: 450.ms);
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String? value;
  final bool isTags;
  final List<String>? tags;

  const _InfoItem({
    required this.label,
    this.value,
    this.isTags = false,
    this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    final TextTheme textTheme =
        Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 520,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurface
                  .withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),

          const SizedBox(height: 8),

          if (isTags)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (tags ?? const <String>[])
                  .map(
                    (tag) => _MiniTag(
                      label: tag,
                    ),
                  )
                  .toList(),
            )
          else
            Text(
              value ?? '',
              softWrap: true,
              style:
                  textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Hero image
// -----------------------------------------------------------------------------

class _HeroImage extends StatelessWidget {
  final Project project;

  const _HeroImage({
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: colorScheme.surfaceContainer,
          child: Image.asset(
            project.heroImage,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) {
              return _ImageFallback(
                icon: Icons.image_not_supported_outlined,
                label: 'Hero image unavailable',
              );
            },
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 500.ms)
        .scale(
          begin: const Offset(0.98, 0.98),
        );
  }
}

// -----------------------------------------------------------------------------
// Logo
// -----------------------------------------------------------------------------

class _ProjectLogo extends StatelessWidget {
  final Project project;

  const _ProjectLogo({
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 92,
      height: 92,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.outline
              .withValues(alpha: 0.12),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          project.logoImage,
          fit: BoxFit.contain,
          errorBuilder:
              (context, error, stackTrace) {
            return Icon(
              Icons.apps,
              color: colorScheme.primary,
              size: 40,
            );
          },
        ),
      ),
    ).animate().fadeIn(delay: 550.ms);
  }
}

// -----------------------------------------------------------------------------
// Markdown content
// -----------------------------------------------------------------------------

class _ProjectContent extends StatelessWidget {
  final Project project;
  final String locale;

  const _ProjectContent({
    required this.project,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    final TextTheme textTheme =
        Theme.of(context).textTheme;

    final String content =
        project.getContent(locale).trim();

    if (content.isEmpty) {
      return _ContentUnavailable(
        locale: locale,
      );
    }

    return MarkdownBody(
      data: content,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        h1: textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w900,
          height: 1.25,
        ),
        h2: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w900,
          height: 1.5,
        ),
        h3: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          height: 1.6,
          color: colorScheme.primary,
        ),
        p: textTheme.bodyLarge?.copyWith(
          height: 1.8,
          fontSize: 17,
          color: colorScheme.onSurface
              .withValues(alpha: 0.82),
        ),
        listBullet:
            textTheme.bodyLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        blockquote:
            textTheme.bodyLarge?.copyWith(
          height: 1.7,
          color: colorScheme.onSurface
              .withValues(alpha: 0.72),
        ),
      ),
    ).animate().fadeIn(delay: 650.ms);
  }
}

// -----------------------------------------------------------------------------
// Screenshot gallery
// -----------------------------------------------------------------------------

class _ScreenshotGallery extends StatelessWidget {
  final Project project;

  const _ScreenshotGallery({
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    final TextTheme textTheme =
        Theme.of(context).textTheme;

    final String locale =
        context.watch<LocaleCubit>().state.languageCode;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          locale == 'ar'
              ? 'صور المشروع'
              : 'Project Screenshots',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 24),

        LayoutBuilder(
          builder: (context, constraints) {
            final double width =
                constraints.maxWidth;

            final int columns = width >= 1000
                ? 3
                : width >= 650
                    ? 2
                    : 1;

            final double spacing =
                columns == 1 ? 12 : 18;

            final double itemWidth =
                (width -
                        (spacing * (columns - 1))) /
                    columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: project.screenshotImages
                  .map(
                    (image) => SizedBox(
                      width: itemWidth,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(22),
                        child: Container(
                          color: colorScheme
                              .surfaceContainer,
                          child: Image.asset(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return const SizedBox(
                                height: 260,
                                child: _ImageFallback(
                                  icon: Icons.broken_image_outlined,
                                  label:
                                      'Image unavailable',
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    ).animate().fadeIn(delay: 750.ms);
  }
}

// -----------------------------------------------------------------------------
// Links
// -----------------------------------------------------------------------------

class _ProjectLinks extends StatelessWidget {
  final Project project;
  final String locale;

  const _ProjectLinks({
    required this.project,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme =
        Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get(
            'project_resources',
            locale,
          ),
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 24),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: project.links.entries
              .map(
                (entry) => _LinkButton(
                  label: entry.key,
                  url: entry.value,
                ),
              )
              .toList(),
        ),
      ],
    ).animate().fadeIn(delay: 850.ms);
  }
}

class _LinkButton extends StatelessWidget {
  final String label;
  final String url;

  const _LinkButton({
    required this.label,
    required this.url,
  });

  Future<void> _openUrl() async {
    final Uri? uri = Uri.tryParse(url);

    if (uri == null) {
      return;
    }

    await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: _openUrl,
      icon: const Icon(
        Icons.open_in_new,
        size: 18,
      ),
      label: Text(
        label,
        overflow: TextOverflow.ellipsis,
      ),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Not found
// -----------------------------------------------------------------------------

class _NotFoundState extends StatelessWidget {
  final String locale;

  const _NotFoundState({
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme =
        Theme.of(context).textTheme;

    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 80,
        ),
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 72,
              color: colorScheme.primary,
            ),

            const SizedBox(height: 24),

            Text(
              locale == 'ar'
                  ? 'المشروع غير موجود'
                  : 'Project Not Found',
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home_outlined),
              label: Text(
                locale == 'ar'
                    ? 'العودة للرئيسية'
                    : 'Back Home',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Empty content
// -----------------------------------------------------------------------------

class _ContentUnavailable extends StatelessWidget {
  final String locale;

  const _ContentUnavailable({
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description_outlined,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              locale == 'ar'
                  ? 'محتوى المشروع غير متاح حاليًا.'
                  : 'Project content is currently unavailable.',
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Image fallback
// -----------------------------------------------------------------------------

class _ImageFallback extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ImageFallback({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 52,
            color: colorScheme.primary
                .withValues(alpha: 0.35),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurface
                  .withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Mini tag
// -----------------------------------------------------------------------------

class _MiniTag extends StatelessWidget {
  final String label;

  const _MiniTag({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer
            .withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
