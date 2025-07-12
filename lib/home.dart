import 'package:flutter/material.dart';
import 'package:rewear/auth.dart';
import 'package:rewear/features/browse/pages/browse_page.dart';
import 'package:rewear/features/style_helper/pages/style_helper_page.dart';
import 'package:rewear/features/upload/pages/upload_clothing_page.dart';
import 'package:rewear/models/clothing_item.dart';
import 'package:rewear/supabase_client.dart';
import 'package:rewear/user_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryColor = const Color(0xFF004CFF);
  Map<String, dynamic>? _userData;
  List<ClothingItem> _trendingItems = [];
  List<ClothingItem> _recommendedItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  Future<void> _fetchUserData() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase
          .from('user_rewear')
          .select()
          .eq('id', userId)
          .single();
      if (mounted) {
        setState(() {
          _userData = data;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error fetching user data."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _fetchClothingItems() async {
    try {
      final response =
          await supabase.from('items').select('*, item_images(image_url)');
      if (mounted) {
        setState(() {
          _trendingItems =
              response.map((item) => ClothingItem.fromJson(item)).toList();
          _recommendedItems = _trendingItems.reversed.toList(); // Example logic
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error fetching clothing items."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });
    await Future.wait([
      _fetchUserData(),
      _fetchClothingItems(),
    ]);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    await supabase.auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_userData != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UserProfilePage(
                                            userData: _userData!),
                                      ),
                                    );
                                  }
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: _userData != null &&
                                              _userData!['profile_picture'] !=
                                                  null
                                          ? NetworkImage(
                                              _userData!['profile_picture'])
                                          : const AssetImage(
                                                  'assets/images/user_profile.jpg')
                                              as ImageProvider,
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Welcome back,",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          _userData != null
                                              ? _userData!['name']
                                              : "User",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.notifications_none),
                                    onPressed: () {
                                      // Navigate to notifications
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.logout),
                                    onPressed: _signOut,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                        /// CTA Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ctaButton("Upload Clothing", Icons.upload,
                                primaryColor, () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const UploadClothingPage(),
                                ),
                              );
                            }),
                            _ctaButton("Browse Items", Icons.search,
                                primaryColor, () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const BrowsePage(),
                                ),
                              );
                            }),
                            _ctaButton("Get Style Help", Icons.style,
                                primaryColor, () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const StyleHelperPage(),
                                ),
                              );
                            }),
                          ],
                        ),
                        const SizedBox(height: 24),

                        /// Trending Carousel
                        const Text(
                          "Trending Now",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _trendingItems.length,
                            itemBuilder: (context, index) =>
                                _trendingCard(_trendingItems[index]),
                          ),
                        ),
                        const SizedBox(height: 24),

                        /// Recommended for You
                        const Text(
                          "Recommended for You",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: _recommendedItems
                              .map((item) => _recommendedCard(item))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _ctaButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          label: Text(label, textAlign: TextAlign.center),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _trendingCard(ClothingItem item) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: item.imageUrl != null
                ? Image.network(
                    item.imageUrl!,
                    height: 100,
                    width: 140,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/placeholder.png', // Placeholder image
                    height: 100,
                    width: 140,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            item.category ?? '',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _recommendedCard(ClothingItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: item.imageUrl != null
                ? Image.network(
                    item.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/placeholder.png', // Placeholder image
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(item.description ?? '',
                  style: TextStyle(color: Colors.grey.shade600)),
            ],
          )
        ],
      ),
    );
  }
}