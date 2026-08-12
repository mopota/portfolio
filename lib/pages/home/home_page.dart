import 'package:flutter/material.dart';
import '../../core/widgets/sticky_nav_bar.dart';
import '../../core/widgets/back_to_top.dart';
import 'sections/hero_section.dart';
import 'sections/about_section.dart';
import 'sections/skills_section.dart';
import 'sections/projects_section.dart';
import 'sections/contact_section.dart';
import 'sections/footer_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: [
              const SizedBox(height: 80), // Spacer for sticky nav
              HeroSection(
                key: _heroKey,
                onExploreProjects: () => _scrollTo(_projectsKey),
                onContactMe: () => _scrollTo(_contactKey),
              ),
              AboutSection(key: _aboutKey),
              const SkillsSection(),
              ProjectsSection(key: _projectsKey),
              ContactSection(key: _contactKey),
              const FooterSection(),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: StickyNavBar(
              onWorkTap: () => _scrollTo(_projectsKey),
              onAboutTap: () => _scrollTo(_aboutKey),
              onContactTap: () => _scrollTo(_contactKey),
            ),
          ),
        ],
      ),
      floatingActionButton: BackToTop(scrollController: _scrollController),
    );
  }
}
