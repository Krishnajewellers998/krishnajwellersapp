import 'package:equatable/equatable.dart';

class JewelleryItemEntity extends Equatable {
  final dynamic id;
  final String name;
  final String category;
  final String description;
  final String image;
  final List<String> photos;
  final String? weight;
  final String purity;
  final int? price;
  final List<String> synonyms;

  const JewelleryItemEntity({
    required this.id,
    required this.name,
    required this.category,
    this.description = '',
    this.image = '',
    this.photos = const [],
    this.weight,
    this.purity = '22K',
    this.price,
    this.synonyms = const [],
  });

  String get displayImage {
    if (photos.isNotEmpty) return photos.first;
    return image;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        description,
        image,
        photos,
        weight,
        purity,
        price,
        synonyms,
      ];
}
