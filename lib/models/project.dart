class Project {
  final String id;
  final Map<String, String> titles;
  final Map<String, String> categories;
  final Map<String, String> descriptions;
  final String folder;
  final Map<String, String> contents;
  final List<String> tags;
  final Map<String, String> links;
  final ProjectImages images;

  const Project({
    required this.id,
    required this.titles,
    required this.categories,
    required this.descriptions,
    required this.folder,
    required this.contents,
    required this.tags,
    required this.images,
    this.links = const {},
  });

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

  String get assetRoot => 'assets/projects/$folder';

  String get imagesRoot => '$assetRoot/images';

  String get heroImage => '$imagesRoot/${images.hero}';

  String get logoImage => '$imagesRoot/${images.logo}';

  List<String> get screenshotImages {
    return images.screenshots
        .map((image) => '$imagesRoot/$image')
        .toList(growable: false);
  }

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
      images: ProjectImages.fromJson(json['images']),
    );
  }

  static String _stringValue(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    return '';
  }

  static Map<String, String> _localizedMap(dynamic value) {
    if (value is! Map) {
      return const {};
    }

    final result = <String, String>{};

    value.forEach((key, value) {
      if (key is String && value is String) {
        final text = value.trim();

        if (text.isNotEmpty) {
          result[key] = text;
        }
      }
    });

    return Map.unmodifiable(result);
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return List.unmodifiable(
      value
          .whereType<String>()
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty),
    );
  }

  static Map<String, String> _stringMap(dynamic value) {
    if (value is! Map) {
      return const {};
    }

    final result = <String, String>{};

    value.forEach((key, value) {
      if (key is String && value is String) {
        final text = value.trim();

        if (text.isNotEmpty) {
          result[key] = text;
        }
      }
    });

    return Map.unmodifiable(result);
  }
}

class ProjectImages {
  final String hero;
  final String logo;
  final List<String> screenshots;

  const ProjectImages({
    required this.hero,
    required this.logo,
    required this.screenshots,
  });

  factory ProjectImages.fromJson(dynamic json) {
    if (json is! Map) {
      return const ProjectImages(
        hero: 'hero.png',
        logo: 'logo.png',
        screenshots: [],
      );
    }

    return ProjectImages(
      hero: _readString(json['hero'], 'hero.png'),
      logo: _readString(json['logo'], 'logo.png'),
      screenshots: _readList(json['screenshots']),
    );
  }

  static String _readString(dynamic value, String fallback) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    return fallback;
  }

  static List<String> _readList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return List.unmodifiable(
      value
          .whereType<String>()
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty),
    );
  }
}

extension FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
