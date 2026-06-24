class Category {
  final int id;
  final String name;

  const Category({required this.id, required this.name});

  Category copyWith({int? id, String? name}) =>
      Category(id: id ?? this.id, name: name ?? this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}
