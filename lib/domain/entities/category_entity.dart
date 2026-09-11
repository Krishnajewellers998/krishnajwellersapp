import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String name;
  final String image;
  final List<String> synonyms;

  const CategoryEntity({
    required this.name,
    required this.image,
    this.synonyms = const [],
  });

  @override
  List<Object?> get props => [name, image, synonyms];
}
