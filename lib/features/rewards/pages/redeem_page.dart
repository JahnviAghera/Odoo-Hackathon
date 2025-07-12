import 'package:flutter/material.dart';
import 'package:rewear/supabase_client.dart';

class RedeemPage extends StatefulWidget {
  const RedeemPage({super.key});

  @override
  State<RedeemPage> createState() => _RedeemPageState();
}

class _RedeemPageState extends State<RedeemPage> {
  final _redeemCodeController = TextEditingController();

  Future<List<Map<String, dynamic>>> _fetchRewards() async {
    final response = await supabase.from('rewards').select().eq('is_active', true);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redeem Points'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _redeemCodeController,
              decoration: const InputDecoration(
                labelText: 'Enter Redeem Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final code = _redeemCodeController.text.trim();
                if (code.isEmpty) {
                  return;
                }
                try {
                  final userId = supabase.auth.currentUser!.id;
                  final result = await supabase.functions.invoke('redeem-code', body: {'userId': userId, 'code': code});
                  final points = result.data['points'];
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Successfully redeemed $points points!'),
                        backgroundColor: Colors.green),
                  );
                  _redeemCodeController.clear();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error redeeming code: $e'),
                        backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Redeem Code'),
            ),
            const SizedBox(height: 20),
            const Text('Or redeem your points for rewards:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchRewards(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final rewards = snapshot.data!;
                  return ListView.builder(
                    itemCount: rewards.length,
                    itemBuilder: (context, index) {
                      final reward = rewards[index];
                      return ListTile(
                        leading: reward['image_url'] != null
                            ? Image.network(reward['image_url'])
                            : const Icon(Icons.card_giftcard),
                        title: Text(reward['name']),
                        subtitle: Text(reward['description']),
                        trailing: Text('${reward['points_cost']} points'),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Redemption'),
                                content: Text('Are you sure you want to redeem ${reward['name']} for ${reward['points_cost']} points?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Redeem'),
                                    onPressed: () async {
                                      try {
                                        final userId = supabase.auth.currentUser!.id;
                                        await supabase.functions.invoke('redeem-reward', body: {'userId': userId, 'rewardId': reward['id']});
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text('Reward redeemed successfully!'),
                                              backgroundColor: Colors.green),
                                        );
                                      } catch (e) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text('Error redeeming reward: $e'),
                                              backgroundColor: Colors.red),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
