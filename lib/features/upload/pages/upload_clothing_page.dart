import 'package:flutter/material.dart';
import 'package:rewear/features/upload/widgets/attributes_step.dart';
import 'package:rewear/features/upload/widgets/details_step.dart';
import 'package:rewear/features/upload/widgets/image_upload_step.dart';
import 'package:rewear/features/upload/widgets/tags_step.dart';

class UploadClothingPage extends StatefulWidget {
  const UploadClothingPage({super.key});

  @override
  State<UploadClothingPage> createState() => _UploadClothingPageState();
}

class _UploadClothingPageState extends State<UploadClothingPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  void _nextStep(List<String> imageUrls) {
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
                DetailsStep(onNext: () => _nextStep([])),
                AttributesStep(onNext: () => _nextStep([])),
                TagsStep(onNext: () => _nextStep([])),
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
              onPressed: () {
                // **INTEGRATION POINT**
                // This is where you would collect all the data from the previous
                // steps and send it to your Supabase backend.
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Item submitted successfully!'),
                      backgroundColor: Colors.green),
                );
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
