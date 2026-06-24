import 'dart:async';

import 'package:get/get.dart';

import '../error/failures.dart';
import 'base_controller.dart';

/// Một trang kết quả từ tầng data.
class PageResult<T> {
  final List<T> items;
  final int total;
  const PageResult(this.items, this.total);
}

/// Lớp cơ sở cho mọi màn hình danh sách có phân trang và tìm kiếm.
///
/// Gói gọn logic load / refresh / load-more / tìm kiếm có debounce mà
/// tài liệu hướng dẫn tập trung trong `HelperLoadata` + `BaseListDataController`.
/// Các lớp con chỉ cần triển khai [fetchPage].
abstract class BaseListController<T> extends BaseController {
  final items = <T>[].obs;
  final isLoadingMore = false.obs;
  final keyword = ''.obs;

  int pageSize = 10;
  int page = 1;
  int total = 0;
  Timer? _debounce;

  bool get hasMore => total > items.length;
  bool get isEmpty => items.isEmpty;

  /// Lấy một trang dữ liệu. Sử dụng [page], [pageSize] và [keyword] khi cần.
  Future<PageResult<T>> fetchPage(int page);

  /// Được gọi một lần sau khi trang đầu tiên tải xong (ví dụ: tải dữ liệu filter).
  Future<void> onFirstLoad() async {}

  @override
  void onInit() {
    super.onInit();
    onFirstLoad();
    refreshList();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  /// Tải lại từ trang 1 với các filter hiện tại.
  Future<void> refreshList() async {
    page = 1;
    final res = await runGuarded(() => fetchPage(page));
    if (res != null) {
      items.value = res.items;
      total = res.total;
    }
  }

  /// Nối thêm trang tiếp theo. Không làm gì khi đang tải hoặc đã hết dữ liệu.
  Future<void> loadMore() async {
    if (isLoadingMore.value || isLoading.value || !hasMore) return;
    isLoadingMore.value = true;
    try {
      final next = page + 1;
      final res = await fetchPage(next);
      items.addAll(res.items);
      page = next;
      total = res.total;
    } on Failure catch (f) {
      showError(f.message);
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Điểm vào cho tìm kiếm có debounce.
  void search(String value) {
    keyword.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), refreshList);
  }
}
