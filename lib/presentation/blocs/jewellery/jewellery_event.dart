import 'package:equatable/equatable.dart';

abstract class JewelleryEvent extends Equatable {
  const JewelleryEvent();

  @override
  List<Object?> get props => [];
}

class LoadJewelleryEvent extends JewelleryEvent {
  final String? category;
  final String? search;

  const LoadJewelleryEvent({this.category, this.search});

  @override
  List<Object?> get props => [category, search];
}

class LoadMoreJewelleryEvent extends JewelleryEvent {
  const LoadMoreJewelleryEvent();
}
