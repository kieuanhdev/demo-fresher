import '../../../product/domain/entities/product.dart';

/// Một dòng sản phẩm trong giỏ hàng kèm số lượng của nó.
class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1});

  double get lineTotal => product.price * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          other.product == product &&
          other.quantity == quantity;

  @override
  int get hashCode => Object.hash(product, quantity);
}
