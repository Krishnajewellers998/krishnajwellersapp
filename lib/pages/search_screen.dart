import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/jewellery_models.dart';
import '../widgets/jewellery_image_widget.dart';
import 'jewellery_detail_page.dart';

class SearchScreen extends StatefulWidget {
  final List<JewelleryItem> allItems;
  final String? initialQuery;

  const SearchScreen({
    super.key,
    required this.allItems,
    this.initialQuery,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;
  String _query = '';
  List<JewelleryItem> _results = [];
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
        _results = [];
        _hasSearched = false;
      });
      return;
    }
    final matched = widget.allItems.where((item) {
      if (item.name.toLowerCase().contains(qLower)) return true;
      if (item.category.toLowerCase().contains(qLower)) return true;
      if (item.description != null &&
          item.description!.toLowerCase().contains(qLower)) {
        return true;
      }
      for (final syn in item.synonyms) {
        if (syn.toLowerCase().contains(qLower)) return true;
      }
      return false;
    }).toList();

    setState(() {
      _results = matched;
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
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search jewellery...',
                                hintStyle: TextStyle(color: Color(0xFF888888), fontSize: 13),
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
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
          // Suggestions / results count strip
          if (!_hasSearched || _query.isEmpty)
            _buildPopularSuggestions()
          else
            _buildResultsHeader(),

          // Results or empty state
          Expanded(
            child: !_hasSearched || _query.isEmpty
                ? _buildDefaultContent()
                : _results.isEmpty
                    ? _buildNoResults()
                    : _buildResultsGrid(),
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
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: AppConstants.popularSearches.map((term) {
              return GestureDetector(
                onTap: () => _tapSuggestion(term),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader() {
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
            '${_results.length} result${_results.length == 1 ? '' : 's'}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultContent() {
    // Show all items as "browse" when no search typed yet
    final preview = widget.allItems.take(12).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            'ALL JEWELLERY',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: AppColors.goldDark,
            ),
          ),
        ),
        Expanded(child: _buildGrid(preview)),
      ],
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

  Widget _buildResultsGrid() {
    return _buildGrid(_results);
  }

  Widget _buildGrid(List<JewelleryItem> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final img = item.allImages.isNotEmpty ? item.allImages.first : item.singleImage;
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
      },
    );
  }
}
