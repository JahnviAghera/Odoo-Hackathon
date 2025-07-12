import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rewear/widgets/color_palette_row.dart';

class ColorAnalysisResultsPage extends StatelessWidget {
  final File imageFile;

  const ColorAnalysisResultsPage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    // **INTEGRATION POINT**
    // The `analysisData` map is placeholder data. You would replace this
    // with the actual response from the Gemini API.
    final analysisData = {
      'conclusion': 'Warm Autumn',
      'skin_tone': {'name': 'Warm Ivory', 'color': const Color(0xFFF3D9C4)},
      'eye_color': {'name': 'Hazel', 'color': const Color(0xFF9B8A3E)},
      'hair_color': {'name': 'Auburn', 'color': const Color(0xFFA52A2A)},
      'seasonal_palette': [
        const Color(0xFFC6783B),
        const Color(0xFF8B4513),
        const Color(0xFF2E8B57),
        const Color(0xFFD2B48C),
        const Color(0xFFCD5C5C),
      ],
      'clothing_suggestions': [
        const Color(0xFFDAA520),
        const Color(0xFF800000),
        const Color(0xFF6B8E23),
      ],
      'makeup_suggestions': [
        const Color(0xFFE5AA70),
        const Color(0xFFD2691E),
        const Color(0xFFBDB76B),
      ],
      'hair_recommendations': [
        const Color(0xFF5E2C04),
        const Color(0xFFB87333),
      ],
      'jewelry_suggestions': [
        const Color(0xFFFFD700), // Gold
        const Color(0xFFB87333), // Bronze
      ],
      'colors_to_avoid': [
        const Color(0xFF0000FF),
        const Color(0xFF8A2BE2),
        const Color(0xFFFFFFFF),
      ],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Color Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(analysisData['conclusion'] as String),
            const SizedBox(height: 24),
            _buildAnalysisDetailSection(analysisData),
            const SizedBox(height: 24),
            _buildColorRecommendationsSection(analysisData),
            const SizedBox(height: 24),
            _buildFashionIllustrationsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String conclusion) {
    return Column(
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              imageFile,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Your Personal Color Palette is',
          style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
        ),
        Text(
          conclusion,
          style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004CFF)),
        ),
      ],
    );
  }

  Widget _buildAnalysisDetailSection(Map<String, dynamic> data) {
    return _buildSection(
      title: 'Analysis Details',
      child: Column(
        children: [
          _buildDetailRow('Skin Tone', data['skin_tone']['name'],
              data['skin_tone']['color']),
          _buildDetailRow(
              'Eye Color', data['eye_color']['name'], data['eye_color']['color']),
          _buildDetailRow('Hair Color', data['hair_color']['name'],
              data['hair_color']['color']),
          const SizedBox(height: 16),
          ColorPaletteRow(
            title: 'Your Seasonal Palette',
            colors: data['seasonal_palette'] as List<Color>,
          ),
        ],
      ),
    );
  }

  Widget _buildColorRecommendationsSection(Map<String, dynamic> data) {
    return _buildSection(
      title: 'Color Recommendations',
      child: Column(
        children: [
          ColorPaletteRow(
            title: 'Clothing Colors',
            colors: data['clothing_suggestions'] as List<Color>,
          ),
          const SizedBox(height: 16),
          ColorPaletteRow(
            title: 'Makeup Colors',
            colors: data['makeup_suggestions'] as List<Color>,
          ),
          const SizedBox(height: 16),
          ColorPaletteRow(
            title: 'Hair Colors',
            colors: data['hair_recommendations'] as List<Color>,
          ),
          const SizedBox(height: 16),
          ColorPaletteRow(
            title: 'Jewelry & Accessories',
            colors: data['jewelry_suggestions'] as List<Color>,
          ),
          const SizedBox(height: 16),
          ColorPaletteRow(
            title: 'Colors to Avoid',
            colors: data['colors_to_avoid'] as List<Color>,
          ),
        ],
      ),
    );
  }

  Widget _buildFashionIllustrationsSection() {
    return _buildSection(
      title: 'Fashion Illustrations',
      child: Column(
        children: [
          _buildIllustrationCard('Casual Style', 'assets/images/placeholder.png'),
          _buildIllustrationCard('Business Style', 'assets/images/placeholder.png'),
          _buildIllustrationCard('Evening Style', 'assets/images/placeholder.png'),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Divider(height: 16),
        child,
      ],
    );
  }

  Widget _buildDetailRow(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade400),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIllustrationCard(String title, String imagePath) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
