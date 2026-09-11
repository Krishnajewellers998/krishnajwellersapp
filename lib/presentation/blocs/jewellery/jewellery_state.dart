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
  final String? selectedCategory;
  final String? search;

  const JewelleryLoaded(this.items, {this.selectedCategory, this.search});

  @override
  List<Object?> get props => [items, selectedCategory, search];
}

class JewelleryError extends JewelleryState {
  final String message;

  const JewelleryError(this.message);

  @override
  List<Object?> get props => [message];
}
