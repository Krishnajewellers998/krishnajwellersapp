import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/jewellery_models.dart';
import '../services/jewellery_repository.dart';
import '../widgets/jewellery_image_widget.dart';
import 'jewellery_detail_page.dart';

class CategoryListingPage extends StatefulWidget {
  final String categoryName;

  const CategoryListingPage({super.key, required this.categoryName});

  @override
  State<CategoryListingPage> createState() => _CategoryListingPageState();
}

class _CategoryListingPageState extends State<CategoryListingPage> {
  List<JewelleryItem> _items = [];
  List<JewelleryItem> _similarItems = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final all = await JewelleryRepository.fetchJewellery();
    final filtered = all.where((item) {
      return item.category.toLowerCase().trim() == widget.categoryName.toLowerCase().trim();
    }).toList();

    final others = all.where((item) {
      return item.category.toLowerCase().trim() != widget.categoryName.toLowerCase().trim();
    }).toList();
    others.shuffle();

    if (mounted) {
      setState(() {
        _items = filtered;
        _similarItems = others.take(6).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayItems = _items.where((item) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return item.name.toLowerCase().contains(q) ||
          (item.description != null && item.description!.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.gold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName.toUpperCase(),
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search box inside category
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.goldBgGradientTop,
              border: Border(bottom: BorderSide(color: AppColors.goldBorder)),
            ),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
              maxLines: 1,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search within ${widget.categoryName}...',
                hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, color: AppColors.goldDark, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: AppColors.goldBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: AppColors.goldBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.goldDark),
                  )
                : CustomScrollView(
                    slivers: [
                      if (displayItems.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.inventory_2_outlined, size: 50, color: AppColors.goldDark.withValues(alpha: 0.5)),
                                const SizedBox(height: 12),
                                Text(
                                  'No designs found in "${widget.categoryName}"',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.all(12),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = displayItems[index];
                                return _buildProductCard(item);
                              },
                              childCount: displayItems.length,
                            ),
                          ),
                        ),
                      
                      // Similar Products Section
                      if (_similarItems.isNotEmpty && _searchQuery.isEmpty) ...[
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16, 30, 16, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'SIMILAR PRODUCTS',
                                  style: TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.goldDark,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'You May Also Like',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'serif',
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textMain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(12),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = _similarItems[index];
                                return _buildProductCard(item);
                              },
                              childCount: _similarItems.length,
                            ),
                          ),
                        ),
                      ],
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 80), // Bottom padding
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(JewelleryItem item) {
    final img = item.allImages.isNotEmpty ? item.allImages.first : item.singleImage;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JewelleryDetailPage(item: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.goldBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0E000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Photo
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                child: Container(
                  color: const Color(0xFFFBF9F5),
                  child: JewelleryImageWidget(
                    imagePath: img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Details Bar
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.weight != null && item.weight!.isNotEmpty
                            ? '${item.weight}g'
                            : 'Fine Gold',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.goldDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.goldDark),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
