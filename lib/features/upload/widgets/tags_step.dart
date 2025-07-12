import 'package:flutter/material.dart';

class TagsStep extends StatefulWidget {
  final Function(List<String>) onNext;

  const TagsStep({super.key, required this.onNext});

  @override
  State<TagsStep> createState() => _TagsStepState();
}

class _TagsStepState extends State<TagsStep> {
  final List<String> _availableTags = [
    'Vintage',
    'Boho',
    'Casual',
    'Formal',
    'Sporty',
    'Minimalist',
    'Streetwear',
    'Y2K',
  ];
  final List<String> _selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Tags',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Help others find your item by adding relevant tags.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _availableTags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
                selectedColor: const Color(0xFF004CFF).withOpacity(0.8),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onNext(_selectedTags),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004CFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}
