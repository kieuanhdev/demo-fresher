class Product {
  final int id;
  final String name;
  final String code;
  final double price;
  final int stock;
  final int categoryId;
  final String? description;
  final String? image;

  const Product({
    required this.id,
    required this.name,
    required this.code,
    required this.price,
    required this.stock,
    required this.categoryId,
    this.description,
    this.image,
  });

  Product copyWith({
    int? id,
    String? name,
    String? code,
    double? price,
    int? stock,
    int? categoryId,
    String? description,
    String? image,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          other.id == id &&
          other.name == name &&
          other.code == code &&
          other.price == price &&
          other.stock == stock &&
          other.categoryId == categoryId &&
          other.description == description &&
          other.image == image;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        code,
        price,
        stock,
        categoryId,
        description,
        image,
      );
}
