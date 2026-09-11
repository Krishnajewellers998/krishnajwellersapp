import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.name,
    required super.image,
    super.synonyms,
  });

  factory CategoryModel.fromJson(dynamic json) {
    if (json is String) {
      return CategoryModel(name: json, image: '');
    }
    if (json is Map<String, dynamic>) {
      final synList = json['synonyms'];
      return CategoryModel(
        name: json['name']?.toString() ?? '',
        image: json['image']?.toString() ?? '',
        synonyms: synList is List ? synList.map((e) => e.toString()).toList() : const [],
      );
    }
    return const CategoryModel(name: '', image: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'synonyms': synonyms,
    };
  }
}
