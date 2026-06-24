import 'package:get/get.dart';

/// Giữ chỉ số tab đang hoạt động của bottom-nav cho home shell.
class ShellController extends GetxController {
  final index = 0.obs;
  void go(int i) => index.value = i;
}
