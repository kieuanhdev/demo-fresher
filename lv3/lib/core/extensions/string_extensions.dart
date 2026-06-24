/// Các helper cho String dùng để hiển thị + validation.
extension StringX on String {
  /// `"hello world"` → `"Hello world"`.
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// `"hello world"` → `"Hello World"`.
  String get titleCase =>
      split(' ').map((w) => w.capitalized).join(' ');

  /// True khi rỗng sau khi trim.
  bool get isBlank => trim().isEmpty;

  bool get isValidEmail =>
      RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(trim());

  /// Cắt về [max] ký tự, thêm `…` ở cuối khi bị cắt bớt.
  String ellipsize(int max) =>
      length <= max ? this : '${substring(0, max).trimRight()}…';
}

/// Các helper tương tự cho String nullable, an toàn với null.
extension NullableStringX on String? {
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  String orDefault([String fallback = '-']) =>
      isNullOrBlank ? fallback : this!;
}
