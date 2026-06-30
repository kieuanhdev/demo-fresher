# SDS Mobile

Ứng dụng Flutter quản lý **danh mục** và **sản phẩm**, tích hợp xác thực người dùng (Authentication) và chức năng giỏ hàng. Ứng dụng kết nối tới hệ thống backend SDS Mobile API (RESTful).

---

## 🚀 Công nghệ sử dụng

| Hạng mục          | Lựa chọn                          |
| ----------------- | --------------------------------- |
| Framework         | Flutter (Dart SDK `^3.8.1`)       |
| State / DI / Route| [GetX](https://pub.dev/packages/get) `^4.6.6` |
| HTTP client       | [Dio](https://pub.dev/packages/dio) `^5.7.0` |
| Lưu trữ cục bộ    | [get_storage](https://pub.dev/packages/get_storage) `^2.1.1` |
| Lint              | flutter_lints `^5.0.0`            |

---

## 🏗 Kiến trúc

Dự án áp dụng **Clean Architecture**, tách biệt theo từng tính năng (Feature-based). Mỗi tính năng bao gồm 3 lớp chính: `presentation`, `domain`, và `data`.

```text
lib/
├── core/                  # Hạ tầng và các thành phần dùng chung
│   ├── base/              # BaseController, BaseListController, BaseView
│   ├── constants/         # Endpoint API, key storage
│   ├── di/                # Initial binding (đăng ký dependency toàn cục)
│   ├── error/             # Exceptions, Failures
│   ├── extensions/        # Extension cho context / num / string
│   ├── mixins/            # ValidationMixin
│   ├── network/           # DioClient, AuthInterceptor
│   ├── routes/            # AppRoutes, AppPages
│   ├── storage/           # StorageService
│   ├── theme/             # Màu sắc, kích thước, theme
│   └── widgets/           # Widget tái sử dụng (button, input, scaffold, shimmer...)
└── features/
    ├── auth/              # Đăng nhập, đăng ký
    ├── category/          # CRUD danh mục
    ├── product/           # CRUD sản phẩm (có phân trang)
    ├── cart/              # Giỏ hàng
    ├── home/              # Shell điều hướng chính
    └── splash/            # Màn hình khởi động
```

### Luồng dữ liệu (Data Flow)
Luồng phụ thuộc của mỗi tính năng tuân theo thứ tự: 
`presentation` → `domain` → `data`

- **Domain**: Bao gồm `entities`, `repositories` (abstract interface), `usecases` — chứa logic nghiệp vụ thuần túy, không phụ thuộc framework.
- **Data**: Bao gồm `models`, `datasources` (gọi API), `repositories` (implementation) — xử lý và chuyển đổi dữ liệu.
- **Presentation**: Bao gồm `controllers` (GetX), `views`, `bindings` — quản lý giao diện (UI) và trạng thái (State).

---

## ✨ Tính năng nổi bật

- **Xác thực (Auth)** — Đăng nhập / Đăng ký, lưu trữ token an toàn qua `AuthInterceptor` và `get_storage`.
- **Quản lý danh mục** — Xem danh sách, tạo mới, chỉnh sửa, và xóa danh mục (CRUD).
- **Quản lý sản phẩm** — Xem danh sách (có hỗ trợ phân trang), tạo mới, chỉnh sửa, và xóa sản phẩm.
- **Giỏ hàng** — Thêm sản phẩm vào giỏ, quản lý số lượng và danh sách sản phẩm đã chọn.
- **Điều hướng (Navigation)** — Sử dụng shell điều hướng chính kết hợp với chuyển trang phong cách Cupertino mượt mà.

---

## ⚙️ Cấu hình API

Các endpoint được khai báo tập trung tại [`lib/core/constants/api_constants.dart`](lib/core/constants/api_constants.dart). Hệ thống tự động dò tìm host dựa trên nền tảng (platform) đang chạy:

| Môi trường              | Host        |
| ----------------------- | ----------- |
| Android emulator        | `10.0.2.2`  |
| iOS sim / web / desktop | `localhost` |
| Thiết bị thật           | Truyền tham số `--dart-define=API_HOST=<IP_LAN>` |

**Base URL**: `http://<host>:1997/api/v1`

### Chạy trên thiết bị thật (cùng mạng Wi-Fi với PC):

```bash
flutter run --dart-define=API_HOST=192.168.1.50
```
*(Thay `192.168.1.50` bằng địa chỉ IP máy chủ của bạn)*

---

## 🛠 Hướng dẫn cài đặt và chạy ứng dụng

1. **Cài đặt các thư viện phụ thuộc (Dependencies)**:
   ```bash
   flutter pub get
   ```

2. **Chạy ứng dụng**:
   ```bash
   flutter run
   ```

3. **Chạy test (nếu có)**:
   ```bash
   flutter test
   ```

---

## 📚 Tài liệu API tham khảo

- **Postman Collection**: File cấu trúc API có sẵn tại thư mục gốc của dự án `SDS Mobile API.postman_collection.json`. (Bạn có thể import file này vào Postman để kiểm tra các API).
