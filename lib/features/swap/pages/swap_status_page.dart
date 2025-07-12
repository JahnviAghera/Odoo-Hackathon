import 'package:flutter/material.dart';

class SwapStatusPage extends StatelessWidget {
  const SwapStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with actual swap request data
    final List<Map<String, dynamic>> swapRequests = [
      {
        'item_offered': 'My Red T-Shirt',
        'item_requested': 'Vintage Denim Jacket',
        'status': 'Pending'
      },
      {
        'item_offered': 'My Blue Jeans',
        'item_requested': 'Floral Summer Dress',
        'status': 'Accepted'
      },
      {
        'item_offered': 'My Black Hat',
        'item_requested': 'Leather Ankle Boots',
        'status': 'Completed'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swap Requests'),
      ),
      body: ListView.builder(
        itemCount: swapRequests.length,
        itemBuilder: (context, index) {
          final request = swapRequests[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                  '${request['item_offered']} for ${request['item_requested']}'),
              trailing: Chip(
                label: Text(request['status']),
                backgroundColor: _getStatusColor(request['status']),
                labelStyle: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Accepted':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
