class ClothingItem {
  final String id;
  final String title;
  final String? description;
  final String? category;
  final String? imageUrl;
  final String? size;
  final String? condition;
  final List<String>? tags;
  final bool isAvailable;
  final int? price;

  ClothingItem({
    required this.id,
    required this.title,
    this.description,
    this.category,
    this.imageUrl,
    this.size,
    this.price,
    this.condition,
    this.tags,
    this.isAvailable = true,
  });

  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      size: json['size'],
      price: json['price'],
      condition: json['condition'],
      isAvailable: json['is_available'] ?? true,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      imageUrl: json['item_images'] != null && json['item_images'].isNotEmpty
          ? json['item_images'][0]['image_url']
          : null,
    );
  }
}
