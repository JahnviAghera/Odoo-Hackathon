import 'package:flutter/material.dart';
import 'package:rewear/models/clothing_item.dart';

class SwapRequestModal extends StatefulWidget {
  final ClothingItem itemToSwap;

  const SwapRequestModal({super.key, required this.itemToSwap});

  @override
  State<SwapRequestModal> createState() => _SwapRequestModalState();
}

class _SwapRequestModalState extends State<SwapRequestModal> {
  ClothingItem? _selectedItem;

  @override
  Widget build(BuildContext context) {
    // Replace with actual user's items
    final List<ClothingItem> userItems = [
      ClothingItem(id: '1', title: 'My Red T-Shirt', size: 'M'),
      ClothingItem(id: '2', title: 'My Blue Jeans', size: 'L'),
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Send Swap Request',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Select one of your items to trade:'),
          const SizedBox(height: 8),
          DropdownButtonFormField<ClothingItem>(
            value: _selectedItem,
            items: userItems.map((item) {
              return DropdownMenuItem<ClothingItem>(
                value: item,
                child: Text(item.title),
              );
            }).toList(),
            onChanged: (item) {
              setState(() {
                _selectedItem = item;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Choose an item',
            ),
          ),
          const SizedBox(height: 16),
          const Center(child: Text('OR')),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Handle using points
              },
              child: const Text('Redeem with 100 Points'),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // **INTEGRATION POINT**
                // Send the swap request to your backend.
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Swap request sent!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004CFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Send Request'),
            ),
          ),
        ],
      ),
    );
  }
}
