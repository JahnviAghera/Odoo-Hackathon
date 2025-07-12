import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rewear/widgets/color_palette_row.dart';

class ColorAnalysisResultsPage extends StatelessWidget {
  final File imageFile;
  final Map<String, dynamic> analysisData;

  const ColorAnalysisResultsPage({
    super.key,
    required this.imageFile,
    required this.analysisData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Color Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(analysisData['conclusion'] ?? 'Your Palette'),
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
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            imageFile,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Your Personal Color Palette is',
          style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 4),
        Text(
          conclusion,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF004CFF),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisDetailSection(Map<String, dynamic> data) {
    return _buildSection(
      title: 'Analysis Details',
      child: Column(
        children: [
          _buildDetailRow('Skin Tone', data['skin_tone']),
          _buildDetailRow('Eye Color', data['eye_color']),
          _buildDetailRow('Hair Color', data['hair_color']),
          const SizedBox(height: 16),
          ColorPaletteRow(
            title: 'Seasonal Palette',
            colors: List<Color>.from(data['seasonal_palette'] ?? []),
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
          _buildPaletteRow('Clothing Colors', data['clothing_suggestions']),
          _buildPaletteRow('Makeup Colors', data['makeup_suggestions']),
          _buildPaletteRow('Hair Colors', data['hair_recommendations']),
          _buildPaletteRow('Jewelry & Accessories', data['jewelry_suggestions']),
          _buildPaletteRow('Colors to Avoid', data['colors_to_avoid']),
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
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Divider(height: 16),
        child,
      ],
    );
  }

  Widget _buildDetailRow(String title, Map<String, dynamic>? detail) {
    final String? value = detail?['name'];
    final Color? color = detail?['color'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              Text(
                value ?? 'N/A',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              if (color != null)
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

  Widget _buildPaletteRow(String title, dynamic colorList) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ColorPaletteRow(
        title: title,
        colors: List<Color>.from(colorList ?? []),
      ),
    );
  }

  Widget _buildIllustrationCard(String title, String imagePath) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
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
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
