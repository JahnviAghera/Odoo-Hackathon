import 'package:flutter/material.dart';
import 'package:rewear/features/browse/widgets/item_card.dart';
import 'package:rewear/models/clothing_item.dart';

class BodyTypeResultsPage extends StatelessWidget {
  final Map<String, dynamic> analysisData;

  const BodyTypeResultsPage({super.key, required this.analysisData});

  @override
  Widget build(BuildContext context) {
    final bodyType = analysisData['body_type'] as String;
    final clothingSuggestions =
        List<String>.from(analysisData['clothing_suggestions'] as List);
    // Placeholder for recommended items
    final recommendedItems = [
      ClothingItem(id: '1', title: 'Classic Blue Jeans'),
      ClothingItem(id: '2', title: 'White Button-Down'),
      ClothingItem(id: '3', title: 'Black Blazer'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Body Type'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(bodyType),
            const SizedBox(height: 24),
            _buildClothingSuggestions(clothingSuggestions),
            const SizedBox(height: 24),
            _buildRecommendedItems(recommendedItems),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String bodyType) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.accessibility_new,
              size: 80, color: Color(0xFF004CFF)),
          const SizedBox(height: 16),
          Text(
            'Your Body Type is',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),
          Text(
            bodyType,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildClothingSuggestions(List<String> suggestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Clothing Suggestions',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Divider(height: 16),
        Wrap(
          spacing: 8.0,
          children: suggestions
              .map((suggestion) => Chip(label: Text(suggestion)))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRecommendedItems(List<ClothingItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended For You',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Divider(height: 16),
        SizedBox(
          height: 250, // Adjust height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 160,
                child: ItemCard(item: items[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}