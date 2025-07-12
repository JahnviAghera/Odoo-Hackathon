class ClothingItem {
  final List<String> imageUrls;
  final String title;
  final String description;
  final String category;
  final String size;
  final String condition;
  final List<String> tags;

  ClothingItem({
    required this.imageUrls,
    required this.title,
    required this.description,
    required this.category,
    required this.size,
    required this.condition,
    required this.tags,
  });

  ClothingItem copyWith({
    List<String>? imageUrls,
    String? title,
    String? description,
    String? category,
    String? size,
    String? condition,
    List<String>? tags,
  }) {
    return ClothingItem(
      imageUrls: imageUrls ?? this.imageUrls,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      size: size ?? this.size,
      condition: condition ?? this.condition,
      tags: tags ?? this.tags,
    );
  }
}
