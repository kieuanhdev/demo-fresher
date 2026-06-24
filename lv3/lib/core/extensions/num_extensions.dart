/// Các helper cho số dùng xuyên suốt app (giá, tồn kho, v.v.).
extension NumX on num {
  /// `1234.5` → `"$1,234.50"`. Phân tách hàng nghìn, 2 chữ số thập phân.
  String toCurrency({String symbol = '\$', int decimals = 2}) {
    final fixed = toStringAsFixed(decimals);
    final parts = fixed.split('.');
    final intPart = parts[0];
    final neg = intPart.startsWith('-');
    final digits = neg ? intPart.substring(1) : intPart;

    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i != 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }

    final sign = neg ? '-' : '';
    final dec = parts.length > 1 ? '.${parts[1]}' : '';
    return '$sign$symbol$buf$dec';
  }

  /// Giới hạn về khoảng 0–1 và trả về chuỗi phần trăm, ví dụ `0.42` → `"42%"`.
  String toPercent() => '${(this * 100).clamp(0, 100).round()}%';
}
