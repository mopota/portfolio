class Project {
  final String id;
  final Map<String, String> titles;
  final Map<String, String> categories;
  final Map<String, String> descriptions;
  final String folder;
  final Map<String, String> contents; // Localized MD content
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

  String getTitle(String locale) => titles[locale] ?? titles['en']!;
  String getCategory(String locale) => categories[locale] ?? categories['en']!;
  String getDescription(String locale) => descriptions[locale] ?? descriptions['en']!;
  String getContent(String locale) => contents[locale] ?? contents['en']!;

  factory Project.fromJson(Map<String, dynamic> json, Map<String, String> contents) {
    return Project(
      id: json['id'] as String,
      titles: Map<String, String>.from(json['title']),
      categories: Map<String, String>.from(json['category']),
      descriptions: Map<String, String>.from(json['description']),
      folder: json['folder'] as String,
      contents: contents,
      tags: List<String>.from(json['tags'] ?? []),
      links: Map<String, String>.from(json['links'] ?? {}),
    );
  }
}
