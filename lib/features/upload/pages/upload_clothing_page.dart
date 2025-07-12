import 'package:flutter/material.dart';
import 'package:rewear/features/upload/models/clothing_item.dart';
import 'package:rewear/features/upload/widgets/attributes_step.dart';
import 'package:rewear/features/upload/widgets/details_step.dart';
import 'package:rewear/features/upload/widgets/image_upload_step.dart';
import 'package:rewear/features/upload/widgets/tags_step.dart';
import 'package:rewear/supabase_client.dart';

class UploadClothingPage extends StatefulWidget {
  const UploadClothingPage({super.key});

  @override
  State<UploadClothingPage> createState() => _UploadClothingPageState();
}

class _UploadClothingPageState extends State<UploadClothingPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  late ClothingItem _clothingItem;

  @override
  void initState() {
    super.initState();
    _clothingItem = ClothingItem(
      imageUrls: [],
      title: '',
      description: '',
      category: '',
      size: '',
      condition: '',
      tags: [],
    );
  }

  void _nextStep(dynamic data) {
    if (_currentStep == 0) {
      _clothingItem = _clothingItem.copyWith(imageUrls: data as List<String>);
    } else if (_currentStep == 1) {
      _clothingItem = _clothingItem.copyWith(
          title: data['title'], description: data['description']);
    } else if (_currentStep == 2) {
      _clothingItem = _clothingItem.copyWith(
          category: data['category'],
          size: data['size'],
          condition: data['condition']);
    } else if (_currentStep == 3) {
      _clothingItem = _clothingItem.copyWith(tags: data as List<String>);
    }

    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
        _pageController.animateToPage(_currentStep,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _pageController.animateToPage(_currentStep,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Clothing'),
        leading: _currentStep == 0
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: List.generate(5, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    decoration: BoxDecoration(
                      color: index <= _currentStep
                          ? const Color(0xFF004CFF)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ImageUploadStep(onNext: _nextStep),
                DetailsStep(onNext: (data) => _nextStep(data)),
                AttributesStep(onNext: (data) => _nextStep(data)),
                TagsStep(onNext: (data) => _nextStep(data)),
                _buildSubmitStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitStep() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                size: 100, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'Ready to Submit?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'You\'ve provided all the necessary details. Press the button below to list your item.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                try {
                  final userId = supabase.auth.currentUser!.id;
                  await supabase.from('items').insert({
                    'title': _clothingItem.title,
                    'description': _clothingItem.description,
                    'category': _clothingItem.category,
                    'size': _clothingItem.size,
                    'condition': _clothingItem.condition,
                    'tags': _clothingItem.tags,
                    'image_urls': _clothingItem.imageUrls,
                    'user_id': userId,
                  });

                  // Award points to the user
                  await supabase.functions.invoke('award-points', body: {'userId': userId, 'points': 10});

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Item submitted successfully! You earned 10 points.'),
                        backgroundColor: Colors.green),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error submitting item: $e'),
                        backgroundColor: Colors.red),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004CFF),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Submit Item',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
