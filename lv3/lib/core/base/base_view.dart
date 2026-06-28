import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/app_shimmer.dart';
import '../widgets/state_views.dart';
import 'base_controller.dart';

/// Trang cơ sở gắn với một [BaseController]. Cung cấp state machine phản ứng
/// loading → error → empty → content để các view không phải lặp lại.
/// Phản chiếu `BaseGetWidget` từ tài liệu hướng dẫn.
abstract class BaseView<T extends BaseController> extends GetView<T> {
  const BaseView({super.key});

  /// Bọc giao diện lại với lớp màn chặn khi đang thao tác (Loading Overlay)
  Widget withLoadingOverlay({required Widget child}) {
    return Stack(
      children: [
        child,
        Obx(() {
          if (controller.isLoadingOverlay.value) {
            return const Stack(
              children: [
                ModalBarrier(
                  color: Colors.black54,
                  dismissible: false,
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  /// Lớp bọc phản ứng:
  /// - hiển thị [loading] (mặc định là shimmer) ở lần tải đầu khi chưa có dữ liệu
  /// - hiển thị view lỗi (kèm retry) khi thất bại mà chưa có dữ liệu
  /// - hiển thị [empty] khi không có dữ liệu
  /// - ngược lại hiển thị [content]
  Widget stateBuilder({
    required bool Function() isEmpty,
    required Widget Function() content,
    required VoidCallback onRetry,
    Widget? loading,
    Widget? empty,
  }) {
    return Obx(() {
      if (controller.isShowLoading.value && isEmpty()) {
        return loading ?? const ListSkeleton();
      }
      if (controller.error.value != null && isEmpty()) {
        return ErrorStateView(message: controller.error.value!, onRetry: onRetry);
      }
      if (isEmpty()) return empty ?? const SizedBox.shrink();
      return content();
    });
  }
}
