import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/sticky_nav_bar.dart';
import '../../core/widgets/back_to_top.dart';
import '../../data/project_repository.dart';
import '../../models/project.dart';
import '../../core/localization/locale_cubit.dart';
import '../../core/localization/app_strings.dart';

class ProjectDetailsPage extends StatefulWidget {
  final String projectId;
  const ProjectDetailsPage({super.key, required this.projectId});

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
    final locale = context.watch<LocaleCubit>().state.languageCode;
    final project = ProjectRepository.getProjectById(widget.projectId) ?? Project(
        id: 'not-found',
        images: project.images, 
        titles: {'en': 'Project Not Found'},
        categories: {'en': ''},
        descriptions: {'en': ''},
        folder: '',
        contents: {'en': '# Project Not Found'},
        tags: [],
      );

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: [
              const SizedBox(height: 120),
              
              // Header Section
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () => context.go('/'),
                          icon: Icon(locale == 'ar' ? Icons.arrow_forward : Icons.arrow_back),
                          label: Text(AppStrings.get('back_to_projects', locale)),
                        ).animate().fadeIn().slideX(begin: locale == 'ar' ? 0.2 : -0.2),
                        const SizedBox(height: 32),
                        
                        Text(
                          project.getCategory(locale).toUpperCase(),
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w900,
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                        
                        const SizedBox(height: 16),
                        
                        Text(
                          project.getTitle(locale),
                          style: textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            fontSize: locale == 'ar' ? 60 : null,
                          ),
                        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                        
                        const SizedBox(height: 48),
                        
                        // Project Info Grid
                        _ProjectInfoGrid(project: project),
                        
                        const SizedBox(height: 64),
                        
                        // Hero Image Placeholder
                        Container(
                          height: 500,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.rocket_launch, size: 100, color: colorScheme.primary.withValues(alpha: 0.2)),
                                const SizedBox(height: 16),
                                Text(
                                  AppStrings.get('footer_rights', locale), // Using a placeholder for visual text
                                  style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.3))
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: 500.ms).scale(),
                        
                        const SizedBox(height: 80),
                        
                        // Content
                        MarkdownBody(
                          data: project.getContent(locale),
                          styleSheet: MarkdownStyleSheet(
                            h2: textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              height: 2.5,
                              fontSize: 32,
                            ),
                            h3: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 2,
                              color: colorScheme.primary,
                            ),
                            p: textTheme.bodyLarge?.copyWith(
                              height: 1.8,
                              fontSize: 18,
                              color: colorScheme.onSurface.withValues(alpha: 0.8),
                            ),
                            listBullet: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ).animate().fadeIn(delay: 700.ms),
                        
                        const SizedBox(height: 100),
                        
                        // Links
                        if (project.links.isNotEmpty) ...[
                          Text(
                            AppStrings.get('project_resources', locale),
                            style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 32),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: project.links.entries.map((e) => _LinkButton(label: e.key, url: e.value)).toList(),
                          ),
                        ],
                        
                        const SizedBox(height: 150),
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
      floatingActionButton: BackToTop(scrollController: _scrollController),
    );
  }
}

class _ProjectInfoGrid extends StatelessWidget {
  final Project project;
  const _ProjectInfoGrid({required this.project});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state.languageCode;
    return Wrap(
      spacing: 40,
      runSpacing: 24,
      children: [
        _InfoItem(label: AppStrings.get('project_role', locale), value: AppStrings.get('project_role_lead', locale)),
        _InfoItem(label: AppStrings.get('project_tech', locale), isTags: true, tags: project.tags),
        if (project.links.containsKey('GitHub Pages'))
          _InfoItem(label: AppStrings.get('project_live', locale), value: AppStrings.get('project_status_prod', locale)),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String? value;
  final bool isTags;
  final List<String>? tags;

  const _InfoItem({required this.label, this.value, this.isTags = false, this.tags});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        if (isTags)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags!.map((tag) => _MiniTag(label: tag)).toList(),
          )
        else
          Text(
            value!,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String label;
  const _MiniTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String label;
  final String url;
  const _LinkButton({required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.open_in_new, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      ),
    );
  }
}
