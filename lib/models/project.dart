class Project {
  final String id;
  final Map<String, String> titles;
  final Map<String, String> categories;
  final Map<String, String> descriptions;
  final String folder;
  final Map<String, String> contents;
  final List<String> tags;
  final Map<String, String> links;

  const Project({
    required this.id,
    required this.titles,
    required this.categories,
    required this.descriptions,
    required this.folder,
    required this.contents,
    required this.tags,
    this.links = const {},
  });

  // ---------------------------------------------------------------------------
  // Localized content
  // ---------------------------------------------------------------------------

  String getTitle(String locale) {
    return titles[locale] ??
        titles['en'] ??
        titles.values.firstOrNull ??
        id;
  }

  String getCategory(String locale) {
    return categories[locale] ??
        categories['en'] ??
        categories.values.firstOrNull ??
        '';
  }

  String getDescription(String locale) {
    return descriptions[locale] ??
        descriptions['en'] ??
        descriptions.values.firstOrNull ??
        '';
  }

  String getContent(String locale) {
    return contents[locale] ??
        contents['en'] ??
        contents.values.firstOrNull ??
        '';
  }

  // ---------------------------------------------------------------------------
  // Project asset paths
  // ---------------------------------------------------------------------------

  /// Root directory of this project's assets.
  ///
  /// Example:
  /// assets/projects/hisn_al_muslim/
  String get assetRoot => 'assets/projects/$folder';

  /// Project images directory.
  ///
  /// Example:
  /// assets/projects/hisn_al_muslim/images/
  String get imagesRoot => '$assetRoot/images';

  /// Main project hero image.
  ///
  /// The actual project structure uses PNG for hero images.
  String get heroImage => '$imagesRoot/hero.png';

  /// Project logo.
  ///
  /// The actual project structure uses PNG for logos.
  String get logoImage => '$imagesRoot/logo.png';

  /// Available project screenshots.
  ///
  /// Screenshots use JPG in the current project structure.
  ///
  /// The list is intentionally generated from the standard naming convention.
  /// The UI should gracefully handle a missing optional image.
  List<String> get screenshotImages {
    return List<String>.generate(
      20,
      (index) {
        final number = (index + 1).toString().padLeft(2, '0');
        return '$imagesRoot/screenshot_$number.jpg';
      },
    );
  }

  /// Returns all known project images.
  List<String> get allImages {
    return <String>[
      heroImage,
      logoImage,
      ...screenshotImages,
    ];
  }

  // ---------------------------------------------------------------------------
  // JSON
  // ---------------------------------------------------------------------------

  factory Project.fromJson(
    Map<String, dynamic> json,
    Map<String, String> contents,
  ) {
    return Project(
      id: _stringValue(json['id']),
      titles: _localizedMap(json['title']),
      categories: _localizedMap(json['category']),
      descriptions: _localizedMap(json['description']),
      folder: _stringValue(json['folder']),
      contents: Map<String, String>.unmodifiable(contents),
      tags: _stringList(json['tags']),
      links: _stringMap(json['links']),
    );
  }

  // ---------------------------------------------------------------------------
  // JSON helpers
  // ---------------------------------------------------------------------------

  static String _stringValue(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    return '';
  }

  static Map<String, String> _localizedMap(dynamic value) {
    if (value is! Map) {
      return const <String, String>{};
    }

    final Map<String, String> result = <String, String>{};

    value.forEach((key, value) {
      if (key is String && value is String) {
        final String text = value.trim();

        if (text.isNotEmpty) {
          result[key] = text;
        }
      }
    });

    return Map<String, String>.unmodifiable(result);
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) {
      return const <String>[];
    }

    return List<String>.unmodifiable(
      value
          .whereType<String>()
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty),
    );
  }

  static Map<String, String> _stringMap(dynamic value) {
    if (value is! Map) {
      return const <String, String>{};
    }

    final Map<String, String> result = <String, String>{};

    value.forEach((key, value) {
      if (key is String && value is String) {
        final String text = value.trim();

        if (text.isNotEmpty) {
          result[key] = text;
        }
      }
    });

    return Map<String, String>.unmodifiable(result);
  }
}

/// Small extension used by Project localized getters.
extension FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull {
    if (isEmpty) {
      return null;
    }

    return first;
  }
}
