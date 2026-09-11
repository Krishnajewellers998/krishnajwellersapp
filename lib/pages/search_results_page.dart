import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/jewellery_models.dart';
import '../widgets/jewellery_image_widget.dart';
import 'jewellery_detail_page.dart';

class SearchResultsPage extends StatelessWidget {
  final String query;
  final List<JewelleryItem> allItems;

  const SearchResultsPage({
    super.key,
    required this.query,
    required this.allItems,
  });

  @override
  Widget build(BuildContext context) {
    final q = query.toLowerCase().trim();
    final results = allItems.where((item) {
      if (item.name.toLowerCase().contains(q)) return true;
      if (item.category.toLowerCase().contains(q)) return true;
      if (item.description != null && item.description!.toLowerCase().contains(q)) return true;
      for (final syn in item.synonyms) {
        if (syn.toLowerCase().contains(q)) return true;
      }
      return false;
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
          'SEARCH: "$query"',
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 60, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  Text(
                    'No jewellery matched "$query"',
                    style: const TextStyle(fontSize: 15, color: AppColors.textMuted),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
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
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                            child: JewelleryImageWidget(
                              imagePath: img,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
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
                              Text(
                                item.category.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.goldDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
