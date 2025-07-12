import 'package:flutter/material.dart';
import 'package:rewear/features/browse/widgets/item_card.dart';
import 'package:rewear/models/clothing_item.dart';
import 'package:rewear/supabase_client.dart';

class BodyTypeResultsPage extends StatefulWidget {
  final Map<String, dynamic> analysisData;

  const BodyTypeResultsPage({super.key, required this.analysisData});

  @override
  State<BodyTypeResultsPage> createState() => _BodyTypeResultsPageState();
}

class _BodyTypeResultsPageState extends State<BodyTypeResultsPage> {
  List<ClothingItem> _recommendedItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecommendedItems();
  }

  Future<void> _fetchRecommendedItems() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final bodyType = widget.analysisData['body_type'] as String;
      final response = await supabase
          .from('items')
          .select()
          .eq('body_type', bodyType);

      // Remove the checks for response.error and response.data
      // if (response == null || response.error != null) {
      //   throw Exception(response?.error?.message ?? 'Unknown error');
      // }

      final List<dynamic> data = response; // Directly use the response as data
      _recommendedItems = data.map((item) => ClothingItem.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching items: $e');
      // Handle error appropriately, e.g., show a snackbar
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? bodyType;
    List<String>? clothingSuggestions;

    try {
      bodyType = widget.analysisData['body_type'] as String?;
      clothingSuggestions =
          List<String>.from(widget.analysisData['clothing_suggestions'] as List);
    } catch (e) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Body Type'),
        ),
        body: const Center(
          child: Text('Error: Could not parse analysis data.'),
        ),
      );
    }

    if (bodyType == null || clothingSuggestions == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Body Type'),
        ),
        body: const Center(
          child: Text('Error: Missing body type or clothing suggestions.'),
        ),
      );
    }

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
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildRecommendedItems(_recommendedItems),
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
              .map((suggestion) => Chip(label: Text(
            suggestion.length > 20 ? '${suggestion.substring(0, 20)}...' : suggestion,
          )))
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
