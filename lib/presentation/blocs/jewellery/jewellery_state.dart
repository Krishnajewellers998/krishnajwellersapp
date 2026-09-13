import 'package:equatable/equatable.dart';
import '../../../domain/entities/jewellery_item_entity.dart';

abstract class JewelleryState extends Equatable {
  const JewelleryState();

  @override
  List<Object?> get props => [];
}

class JewelleryInitial extends JewelleryState {}

class JewelleryLoading extends JewelleryState {}

class JewelleryLoaded extends JewelleryState {
  final List<JewelleryItemEntity> items;
  final List<JewelleryItemEntity> recommendedItems;
  final String? selectedCategory;
  final String? search;
  final bool hasReachedMax;
  final int page;

  const JewelleryLoaded({
    required this.items,
    this.recommendedItems = const [],
    this.selectedCategory,
    this.search,
    this.hasReachedMax = false,
    this.page = 1,
  });

  JewelleryLoaded copyWith({
    List<JewelleryItemEntity>? items,
    List<JewelleryItemEntity>? recommendedItems,
    String? selectedCategory,
    String? search,
    bool? hasReachedMax,
    int? page,
  }) {
    return JewelleryLoaded(
      items: items ?? this.items,
      recommendedItems: recommendedItems ?? this.recommendedItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      search: search ?? this.search,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [items, recommendedItems, selectedCategory, search, hasReachedMax, page];
}

class JewelleryError extends JewelleryState {
  final String message;

  const JewelleryError(this.message);

  @override
  List<Object?> get props => [message];
}
