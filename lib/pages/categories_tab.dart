import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';
import '../domain/entities/category_entity.dart';
import '../domain/entities/jewellery_item_entity.dart';
import '../presentation/blocs/categories/categories_bloc.dart';
import '../presentation/blocs/categories/categories_state.dart';
import '../presentation/blocs/jewellery/jewellery_bloc.dart';
import '../presentation/blocs/jewellery/jewellery_state.dart';
import '../widgets/jewellery_image_widget.dart';
import 'category_listing_page.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: const Text(
          'ALL CATEGORIES',
          style: TextStyle(
            color: AppColors.gold,
            fontFamily: 'serif',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: TextField(
              onChanged: (val) => setState(() => _filter = val.trim()),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.cream,
                hintText: 'Search jewellery categories...',
                prefixIcon: const Icon(Icons.search, color: AppColors.goldDark),
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
          Expanded(
            child: BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, catState) {
                final categories = catState is CategoriesLoaded ? catState.categories : <CategoryEntity>[];
                final filtered = categories.where((c) {
                  if (_filter.isEmpty) return true;
                  return c.name.toLowerCase().contains(_filter.toLowerCase());
                }).toList();

                if (catState is CategoriesLoading && categories.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.goldDark));
                }

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('No categories found', style: TextStyle(color: AppColors.textMuted)),
                  );
                }

                return BlocBuilder<JewelleryBloc, JewelleryState>(
                  builder: (context, jState) {
                    final jewellery = jState is JewelleryLoaded ? jState.items : <JewelleryItemEntity>[];

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, idx) {
                        final category = filtered[idx];
                        String img = category.image;
                        if (img.isEmpty) {
                          final match = jewellery.firstWhere(
                            (j) => j.category.toLowerCase() == category.name.toLowerCase(),
                            orElse: () => const JewelleryItemEntity(id: 0, name: '', category: ''),
                          );
                          img = match.displayImage;
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryListingPage(categoryName: category.name),
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
                                  color: Color(0x0C000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
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
                                    children: [
                                      Text(
                                        category.name.toUpperCase(),
                                        style: const TextStyle(
                                          fontFamily: 'serif',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'View Collection →',
                                        style: TextStyle(
                                          fontSize: 10,
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
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
