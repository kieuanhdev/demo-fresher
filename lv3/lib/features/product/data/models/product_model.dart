import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.code,
    required super.price,
    required super.stock,
    required super.categoryId,
    super.description,
    super.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: _toInt(json['id']),
      name: (json['name'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      price: _toDouble(json['price']),
      stock: _toInt(json['stock']),
      categoryId: _toInt(json['category_id'] ?? json['categoryId']),
      description: json['description']?.toString(),
      image: json['image']?.toString(),
    );
  }

  /// Body cho create/update. Server yêu cầu category_id dạng snake_case.
  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        'price': price,
        'stock': stock,
        'category_id': categoryId,
        'description': description ?? '',
        'image': image ?? '',
      };

  factory ProductModel.fromEntity(Product p) => ProductModel(
        id: p.id,
        name: p.name,
        code: p.code,
        price: p.price,
        stock: p.stock,
        categoryId: p.categoryId,
        description: p.description,
        image: p.image,
      );

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static double _toDouble(dynamic v) {
    if (v is double) return v;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }
}
