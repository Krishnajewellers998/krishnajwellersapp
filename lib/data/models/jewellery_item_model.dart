import '../../domain/entities/jewellery_item_entity.dart';

class JewelleryItemModel extends JewelleryItemEntity {
  const JewelleryItemModel({
    required super.id,
    required super.name,
    required super.category,
    super.description,
    super.image,
    super.photos,
    super.weight,
    super.purity,
    super.price,
    super.synonyms,
  });

  factory JewelleryItemModel.fromJson(Map<String, dynamic> json) {
    final photoList = json['photos'];
    final synList = json['synonyms'];

    List<String> parsedPhotos = [];
    if (photoList is List) {
      parsedPhotos = photoList.map((p) => p.toString()).toList();
    } else if (json['image'] != null && json['image'].toString().isNotEmpty) {
      parsedPhotos = [json['image'].toString()];
    }

    return JewelleryItemModel(
      id: json['id'],
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString() ?? (parsedPhotos.isNotEmpty ? parsedPhotos.first : ''),
      photos: parsedPhotos,
      weight: json['weight']?.toString(),
      purity: json['purity']?.toString() ?? '22K',
      price: json['price'] is num ? (json['price'] as num).toInt() : null,
      synonyms: synList is List ? synList.map((e) => e.toString()).toList() : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'image': image,
      'photos': photos,
      'weight': weight,
      'purity': purity,
      'price': price,
      'synonyms': synonyms,
    };
  }
}
