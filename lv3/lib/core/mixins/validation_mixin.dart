import '../extensions/string_extensions.dart';

/// Các validator dùng lại cho form-field. Mix vào bất kỳ State/controller nào
/// dựng [Form] để các validator nhất quán giữa các màn hình.
///
/// Mỗi method trả về một `String? Function(String?)` khớp với
/// [TextFormField.validator].
mixin ValidationMixin {
  String? Function(String?) requiredField([String msg = 'Required']) =>
      (v) => v.isNullOrBlank ? msg : null;

  String? Function(String?) minLength(int n, [String? msg]) =>
      (v) => (v ?? '').trim().length < n
          ? (msg ?? 'Must be at least $n characters')
          : null;

  String? Function(String?) email([String msg = 'Invalid email']) =>
      (v) => (v ?? '').isValidEmail ? null : msg;

  /// Chạy lần lượt nhiều validator; trả về lỗi đầu tiên gặp được.
  String? Function(String?) compose(List<String? Function(String?)> rules) =>
      (v) {
        for (final rule in rules) {
          final err = rule(v);
          if (err != null) return err;
        }
        return null;
      };
}
