import '../../domain/entities/category.dart';

class CategoryModel {
  final int id;
  final String name;

  const CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: _toInt(json['id']),
      name: (json['name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'name': name};

  Category toEntity() => Category(id: id, name: name);

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    if (v is num) return v.toInt();
    return 0;
  }
}
