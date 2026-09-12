class CategoryModel {
  final String name;
  final String? image;
  final List<String> synonyms;

  CategoryModel({
    required this.name,
    this.image,
    this.synonyms = const [],
  });

  factory CategoryModel.fromJson(dynamic json) {
    if (json is String) {
      return CategoryModel(name: json);
    }
    if (json is Map<String, dynamic>) {
      return CategoryModel(
        name: json['name'] ?? '',
        image: json['image'],
        synonyms: (json['synonyms'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );
    }
    return CategoryModel(name: '');
  }
}

class JewelleryItem {
  final int id;
  final String name;
  final String category;
  final String? description;
  final String? weight;
  final String? singleImage;
  final List<String> images;
  final List<String> synonyms;

  JewelleryItem({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.weight,
    this.singleImage,
    this.images = const [],
    this.synonyms = const [],
  });

  List<String> get allImages {
    final list = <String>[];
    if (singleImage != null && singleImage!.isNotEmpty) {
      list.add(singleImage!);
    }
    for (final img in images) {
      if (img.isNotEmpty && !list.contains(img)) {
        list.add(img);
      }
    }
    return list;
  }

  factory JewelleryItem.fromJson(Map<String, dynamic> json) {
    List<String> imgList = [];
    if (json['photos'] is List) {
      imgList = (json['photos'] as List).map((e) => e.toString()).toList();
    } else if (json['images'] is List) {
      imgList = (json['images'] as List).map((e) => e.toString()).toList();
    }
    return JewelleryItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString(),
      weight: json['weight']?.toString(),
      singleImage: json['image']?.toString(),
      images: imgList,
      synonyms: (json['synonyms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class GoldRatesModel {
  final int rate24K;
  final int rate22K;
  final int rate18K;
  final String? updatedAt;

  GoldRatesModel({
    required this.rate24K,
    required this.rate22K,
    required this.rate18K,
    this.updatedAt,
  });

  factory GoldRatesModel.fromJson(Map<String, dynamic> json) {
    final rates = json['goldRates'] ?? json;
    return GoldRatesModel(
      rate24K: int.tryParse(rates['24K']?.toString() ?? '0') ?? 0,
      rate22K: int.tryParse(rates['22K']?.toString() ?? '0') ?? 0,
      rate18K: int.tryParse(rates['18K']?.toString() ?? '0') ?? 0,
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}
