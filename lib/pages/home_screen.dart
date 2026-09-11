import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../domain/entities/gold_rates_entity.dart';
import '../models/jewellery_models.dart';
import '../presentation/blocs/categories/categories_bloc.dart';
import '../presentation/blocs/categories/categories_event.dart';
import '../presentation/blocs/gold_rates/gold_rates_bloc.dart';
import '../presentation/blocs/gold_rates/gold_rates_event.dart';
import '../presentation/blocs/gold_rates/gold_rates_state.dart';
import '../presentation/blocs/jewellery/jewellery_bloc.dart';
import '../presentation/blocs/jewellery/jewellery_event.dart';
import '../services/jewellery_repository.dart';
import '../widgets/gold_rates_card.dart';
import '../widgets/jewellery_image_widget.dart';
import 'category_listing_page.dart';
import 'jewellery_detail_page.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoldRatesEntity? _rates;
  List<CategoryModel> _categories = [];
  List<JewelleryItem> _jewellery = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    context.read<GoldRatesBloc>().add(FetchGoldRatesOnce());
    context.read<CategoriesBloc>().add(LoadCategoriesEvent());
    context.read<JewelleryBloc>().add(const LoadJewelleryEvent(category: 'All'));

    final results = await Future.wait([
      JewelleryRepository.fetchGoldRates(),
      JewelleryRepository.fetchCategories(),
      JewelleryRepository.fetchJewellery(),
    ]);
    if (mounted) {
      final r = results[0] as dynamic;
      setState(() {
        _rates = GoldRatesEntity(
          rate24K: r.rate24K as int,
          rate22K: r.rate22K as int,
          rate18K: r.rate18K as int,
        );
        _categories = results[1] as List<CategoryModel>;
        _jewellery = results[2] as List<JewelleryItem>;
        _isLoading = false;
      });
    }
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(allItems: _jewellery),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: AppColors.black,
          elevation: 4,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF080808), Color(0xFF171717), Color(0xFF080808)],
                ),
                border: Border(bottom: BorderSide(color: Color(0x59D4AF37), width: 1)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gold, width: 1.5),
                    ),
                    child: ClipOval(
                      child: JewelleryImageWidget(
                        imagePath: AppConstants.logoImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppConstants.storeName.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontFamily: 'serif',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          '${AppConstants.storeCity} • ${AppConstants.storeEstablished}'.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFFAAAAAA),
                            fontSize: 8.5,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // WhatsApp quick tap
                  IconButton(
                    icon: const Icon(Icons.chat, color: Color(0xFF25D366), size: 24),
                    onPressed: () => _launch(AppConstants.whatsappUrl),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.goldDark,
        onRefresh: _loadAllData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Gold Rates Card (Live reactive stream via GoldRatesBloc)
              BlocBuilder<GoldRatesBloc, GoldRatesState>(
                builder: (context, state) {
                  if (state is GoldRatesLoaded) {
                    return GoldRatesCard(rates: state.rates, isLoading: false);
                  }
                  return GoldRatesCard(
                    rates: _rates ?? const GoldRatesEntity(rate24K: 158000, rate22K: 145305, rate18K: 118886),
                    isLoading: state is GoldRatesLoading,
                  );
                },
              ),

              // 2. Promotional Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.goldBorder),
                    ),
                    child: JewelleryImageWidget(
                      imagePath: AppConstants.bannerImage,
                      height: 145,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 3. Search Bar (tappable — opens full SearchScreen)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: GestureDetector(
                  onTap: _openSearch,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.goldBorder),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x10000000),
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 14, right: 8),
                          child: Icon(Icons.search, color: AppColors.goldDark, size: 22),
                        ),
                        const Expanded(
                          child: Text(
                            'Search rings, chains, jhumki, haar...',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.goldDark, AppColors.gold],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 4. Section: Jewellery Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OUR COLLECTION',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            color: AppColors.goldDark,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Browse by Category',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'serif',
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${_categories.length} Categories',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 5. Category Grid
              _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(color: AppColors.goldDark),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.88,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          String? displayImg = category.image;
                          if (displayImg == null || displayImg.isEmpty) {
                            final match = _jewellery.firstWhere(
                              (j) => j.category.toLowerCase() == category.name.toLowerCase(),
                              orElse: () => JewelleryItem(id: 0, name: '', category: ''),
                            );
                            displayImg = match.allImages.isNotEmpty ? match.allImages.first : match.singleImage;
                          }
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryListingPage(categoryName: category.name),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.goldBorder, width: 1),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0E000000),
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
                                      child: JewelleryImageWidget(imagePath: displayImg, fit: BoxFit.cover),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Text(
                                          category.name.toUpperCase(),
                                          style: const TextStyle(
                                            fontFamily: 'serif',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textMain,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          'Explore Designs →',
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
                      ),
                    ),

              const SizedBox(height: 25),

              // 6. Featured Recent Designs
              if (_jewellery.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HANDCRAFTED LUXURY',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldDark,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Featured Jewellery Pieces',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'serif',
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 210,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    scrollDirection: Axis.horizontal,
                    itemCount: _jewellery.take(8).length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, idx) {
                      final item = _jewellery[idx];
                      final img = item.allImages.isNotEmpty ? item.allImages.first : item.singleImage;
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => JewelleryDetailPage(item: item)),
                        ),
                        child: Container(
                          width: 145,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.goldBorder),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0D000000),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                                  child: JewelleryImageWidget(imagePath: img, fit: BoxFit.cover),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name.toUpperCase(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: 'serif',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item.weight != null && item.weight!.isNotEmpty
                                          ? '${item.weight}g'
                                          : item.category,
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
                ),
              ],

              const SizedBox(height: 25),

              // 7. Family & Legacy Section
              Container(
                color: AppColors.cream,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 14),
                child: Column(
                  children: [
                    const Text(
                      'OUR FAMILY',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Our Family, Our Legacy',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'serif',
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'A jewellery business is built with trust, relationships and generations of dedication.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 18),

                    // Family grid from constants
                    for (int i = 0; i < AppConstants.familyMembers.length; i += 2) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _FamilyMemberCard(
                              imagePath: AppConstants.familyMembers[i]['image']!,
                              name: AppConstants.familyMembers[i]['name']!,
                              role: AppConstants.familyMembers[i]['role']!,
                            ),
                          ),
                          if (i + 1 < AppConstants.familyMembers.length) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: _FamilyMemberCard(
                                imagePath: AppConstants.familyMembers[i + 1]['image']!,
                                name: AppConstants.familyMembers[i + 1]['name']!,
                                role: AppConstants.familyMembers[i + 1]['role']!,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (i + 2 < AppConstants.familyMembers.length)
                        const SizedBox(height: 10),
                    ],

                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.goldBorder),
                      ),
                      child: Text(
                        AppConstants.familyQuote,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textMain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 8. Showroom Visit & Contact Box
              Padding(
                padding: const EdgeInsets.all(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.goldBorder),
                    boxShadow: const [
                      BoxShadow(color: Color(0x0C000000), blurRadius: 8, offset: Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on, color: AppColors.goldDark, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'VISIT SHOWROOM',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: AppColors.goldDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppConstants.storeName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'serif',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppConstants.storeAddress,
                        style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.black,
                            foregroundColor: AppColors.gold,
                            side: const BorderSide(color: AppColors.gold),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => _launch(AppConstants.googleMapsUrl),
                          icon: const Icon(Icons.map, size: 18),
                          label: const Text('Open in Google Maps', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.goldBorder),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE1306C)),
                              foregroundColor: const Color(0xFFE1306C),
                            ),
                            onPressed: () => _launch(AppConstants.instagramUrl),
                            icon: const Icon(Icons.camera_alt_outlined, size: 16),
                            label: const Text('Instagram'),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF1877F2)),
                              foregroundColor: const Color(0xFF1877F2),
                            ),
                            onPressed: () => _launch(AppConstants.facebookUrl),
                            icon: const Icon(Icons.facebook, size: 16),
                            label: const Text('Facebook'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 9. Luxury Footer
              Container(
                color: AppColors.black,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      AppConstants.storeName.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontFamily: 'serif',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppConstants.storeTagline} • ${AppConstants.storeCity}',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.storeFooterText,
                      style: const TextStyle(color: Colors.white38, fontSize: 9.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FamilyMemberCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String role;

  const _FamilyMemberCard({
    required this.imagePath,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.goldBorder),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: JewelleryImageWidget(
              imagePath: imagePath,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'serif',
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            role,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.goldDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
