import 'package:flutter/material.dart';

class AttributesStep extends StatefulWidget {
  final VoidCallback onNext;

  const AttributesStep({super.key, required this.onNext});

  @override
  State<AttributesStep> createState() => _AttributesStepState();
}

class _AttributesStepState extends State<AttributesStep> {
  String? _selectedCategory;
  String? _selectedSize;
  String? _selectedCondition;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Item Attributes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select the category, size, and condition of your item.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          _buildDropdown('Category', ['Tops', 'Bottoms', 'Dresses', 'Shoes'],
              _selectedCategory, (val) {
            setState(() => _selectedCategory = val);
          }),
          const SizedBox(height: 24),
          _buildDropdown('Size', ['XS', 'S', 'M', 'L', 'XL'], _selectedSize,
              (val) {
            setState(() => _selectedSize = val);
          }),
          const SizedBox(height: 24),
          _buildDropdown(
              'Condition', ['New', 'Like New', 'Good', 'Fair'], _selectedCondition,
              (val) {
            setState(() => _selectedCondition = val);
          }),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onNext,
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

  Widget _buildDropdown(String label, List<String> items, String? selectedValue,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
