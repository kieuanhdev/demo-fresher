import 'package:get/get.dart';

import '../../../product/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';

/// Giỏ hàng lưu trong bộ nhớ. Được đăng ký vĩnh viễn để badge + nội dung
/// vẫn còn khi chuyển tab và điều hướng.
class CartController extends GetxController {
  final items = <CartItem>[].obs;

  /// Tổng số lượng trên tất cả các dòng (dùng cho badge điều hướng).
  int get count => items.fold(0, (sum, i) => sum + i.quantity);

  /// Tổng giá tiền của giỏ hàng.
  double get totalPrice => items.fold(0.0, (sum, i) => sum + i.lineTotal);

  bool get isEmpty => items.isEmpty;

  void add(Product product, {int qty = 1}) {
    final i = items.indexWhere((e) => e.product.id == product.id);
    if (i == -1) {
      items.add(CartItem(product: product, quantity: qty));
    } else {
      items[i] = items[i].copyWith(quantity: items[i].quantity + qty);
    }
  }

  void increment(int index) =>
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);

  void decrement(int index) {
    final q = items[index].quantity - 1;
    if (q <= 0) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(quantity: q);
    }
  }

  void removeAt(int index) => items.removeAt(index);

  void clear() => items.clear();
}
