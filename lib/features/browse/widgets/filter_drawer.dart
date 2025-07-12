import 'package:flutter/material.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({super.key});

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  RangeValues _distanceValues = const RangeValues(0, 50);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Filters',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 24),
          _buildFilterSection('Category', [
            'Tops',
            'Bottoms',
            'Dresses',
            'Shoes',
            'Accessories'
          ]),
          _buildFilterSection(
              'Size', ['XS', 'S', 'M', 'L', 'XL', 'One Size']),
          _buildFilterSection('Style',
              ['Casual', 'Formal', 'Sporty', 'Vintage', 'Boho']),
          _buildFilterSection(
              'Color', ['Red', 'Blue', 'Green', 'Black', 'White']),
          const SizedBox(height: 16),
          const Text('Distance (km)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          RangeSlider(
            values: _distanceValues,
            min: 0,
            max: 100,
            divisions: 10,
            labels: RangeLabels(
              _distanceValues.start.round().toString(),
              _distanceValues.end.round().toString(),
            ),
            onChanged: (values) {
              setState(() {
                _distanceValues = values;
              });
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // **INTEGRATION POINT**
              // Apply the selected filters and update the browse page.
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004CFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: options
              .map((option) => FilterChip(
                    label: Text(option),
                    onSelected: (selected) {
                      // Handle filter selection
                    },
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
