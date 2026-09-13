import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/jewellery_item_entity.dart';
import '../presentation/blocs/jewellery/jewellery_bloc.dart';
import '../presentation/blocs/jewellery/jewellery_event.dart';
import '../presentation/blocs/jewellery/jewellery_state.dart';
import '../widgets/jewellery_image_widget.dart';
import '../widgets/recommended_jewellery_widget.dart';
import 'jewellery_detail_page.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({
    super.key,
    this.initialQuery,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;
  String _query = '';
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _query = widget.initialQuery!;
      _runSearch(_query);
      _hasSearched = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runSearch(String q) {
    final qLower = q.toLowerCase().trim();
    if (qLower.isEmpty) {
      setState(() {
        _hasSearched = false;
      });
      return;
    }
    
    // Dispatch event to BLoC to fetch from backend
    context.read<JewelleryBloc>().add(LoadJewelleryEvent(search: qLower));

    setState(() {
      _hasSearched = true;
      _query = q;
    });
  }

  void _tapSuggestion(String term) {
    _controller.text = term;
    _controller.selection =
        TextSelection.fromPosition(TextPosition(offset: term.length));
    _runSearch(term);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: AppColors.black,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF080808), Color(0xFF171717), Color(0xFF080808)],
                ),
                border: Border(bottom: BorderSide(color: Color(0x50D4AF37))),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: AppColors.gold, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Search field
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: AppColors.goldBorder),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(Icons.search, color: AppColors.gold, size: 20),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              maxLines: 1,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              decoration: const InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: 'Search jewellery...',
                                hintStyle: TextStyle(color: Color(0xFF888888), fontSize: 13),
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: _runSearch,
                              onSubmitted: _runSearch,
                            ),
                          ),
                          if (_controller.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.close, color: AppColors.goldLight, size: 18),
                              onPressed: () {
                                _controller.clear();
                                _runSearch('');
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results or empty state
          Expanded(
            child: BlocBuilder<JewelleryBloc, JewelleryState>(
              builder: (context, state) {
                if (!_hasSearched || _query.isEmpty) {
                  return Column(
                    children: [
                      _buildPopularSuggestions(),
                      Expanded(child: _buildDefaultContent()),
                    ],
                  );
                }
                
                if (state is JewelleryLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.goldDark));
                }
                
                if (state is JewelleryLoaded) {
                  return Column(
                    children: [
                      _buildResultsHeader(state.items.length),
                      Expanded(
                        child: state.items.isEmpty
                            ? _buildNoResults()
                            : _buildResultsGrid(state),
                      ),
                    ],
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSuggestions() {
    return Container(
      color: AppColors.goldBgGradientTop,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'POPULAR SEARCHES',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: AppColors.goldDark,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AppConstants.popularSearches.map((term) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _tapSuggestion(term),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.goldBorder),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0A000000), blurRadius: 4),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.trending_up, size: 12, color: AppColors.goldDark),
                          const SizedBox(width: 5),
                          Text(
                            term,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMain,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader(int count) {
    return Container(
      color: AppColors.goldBgGradientTop,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '"$_query"',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          Text(
            '$count result${count == 1 ? '' : 's'}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultContent() {
    // With BLoC we don't have allItems directly, so we just show an empty or prompt state
    return const Center(
      child: Text(
        'Enter a search term to find beautiful jewellery',
        style: TextStyle(color: AppColors.textMuted),
      )
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: AppColors.goldDark.withValues(alpha: 0.4)),
          const SizedBox(height: 14),
          Text(
            'No results for "$_query"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try a different keyword\nor browse popular categories below',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: AppConstants.popularSearches.take(6).map((t) {
                return GestureDetector(
                  onTap: () => _tapSuggestion(t),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.goldBorder),
                    ),
                    child: Text(t,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.goldDark)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsGrid(JewelleryLoaded state) {
    final items = state.items;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildGridItem(items[index]);
              },
              childCount: items.length,
            ),
          ),
        ),
        if (state.hasReachedMax)
           SliverToBoxAdapter(
             child: Column(
               children: [
                 const Padding(
                   padding: EdgeInsets.only(bottom: 20, top: 20),
                   child: Center(
                     child: Text("No more results", style: TextStyle(color: AppColors.textMuted)),
                   )
                 ),
                 if (items.isEmpty && state.recommendedItems.isNotEmpty)
                   RecommendedJewelleryWidget(items: state.recommendedItems),
                 const SizedBox(height: 60),
               ]
             )
           )
        else 
           SliverToBoxAdapter(
             child: Padding(
               padding: const EdgeInsets.only(bottom: 80),
               child: Center(
                 child: OutlinedButton(
                   onPressed: () {
                     context.read<JewelleryBloc>().add(const LoadMoreJewelleryEvent());
                   },
                   child: const Text("Load More"),
                 )
               )
             )
           )
      ],
    );
  }

  Widget _buildGridItem(JewelleryItemEntity item) {
        final img = item.displayImage;
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => JewelleryDetailPage(item: item)),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.goldBorder),
              boxShadow: const [
                BoxShadow(color: Color(0x0D000000), blurRadius: 6, offset: Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                    child: JewelleryImageWidget(imagePath: img, fit: BoxFit.cover),
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
                          fontSize: 13,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.weight != null && item.weight!.isNotEmpty
                                ? '${item.weight}g'
                                : item.category,
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.goldDark,
                                fontWeight: FontWeight.w600),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 11, color: AppColors.goldDark),
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
