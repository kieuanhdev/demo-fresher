git# SDS Mobile

Ứng dụng Flutter quản lý **danh mục** và **sản phẩm**, có xác thực người dùng và giỏ hàng. Kết nối tới backend SDS Mobile API (REST).

## Công nghệ

| Hạng mục          | Lựa chọn                          |
| ----------------- | --------------------------------- |
| Framework         | Flutter (Dart SDK `^3.8.1`)       |
| State / DI / Route| [GetX](https://pub.dev/packages/get) `^4.6.6` |
| HTTP client       | [Dio](https://pub.dev/packages/dio) `^5.7.0` |
| Lưu trữ cục bộ    | [get_storage](https://pub.dev/packages/get_storage) `^2.1.1` |
| Lint              | flutter_lints `^5.0.0`            |

## Kiến trúc

Clean Architecture, tách theo **feature**. Mỗi feature có 3 lớp:

```
lib/
├── core/                  # Hạ tầng dùng chung
│   ├── base/              # BaseController, BaseListController, BaseView
│   ├── constants/         # Endpoint API, key storage
│   ├── di/                # Initial binding (đăng ký dependency toàn cục)
│   ├── error/             # Exceptions, Failures
│   ├── extensions/        # Extension cho context / num / string
│   ├── mixins/            # ValidationMixin
│   ├── network/           # DioClient, AuthInterceptor
│   ├── routes/            # AppRoutes, AppPages
│   ├── storage/           # StorageService
│   ├── theme/             # Màu, kích thước, theme
│   └── widgets/           # Widget tái dùng (button, input, scaffold, shimmer...)
└── features/
    ├── auth/              # Đăng nhập, đăng ký
    ├── category/          # CRUD danh mục
    ├── product/           # CRUD sản phẩm (có phân trang)
    ├── cart/              # Giỏ hàng
    ├── home/              # Shell điều hướng chính
    └── splash/            # Màn khởi động
```

Luồng phụ thuộc mỗi feature: `presentation → domain → data`

- **domain**: `entities`, `repositories` (abstract), `usecases` — logic nghiệp vụ thuần.
- **data**: `models`, `datasources` (gọi API), `repositories` (impl) — chuyển đổi dữ liệu.
- **presentation**: `controllers` (GetX), `views`, `bindings` — UI + state.

## Tính năng

- **Auth** — đăng nhập / đăng ký, lưu token qua `AuthInterceptor` + `get_storage`.
- **Danh mục** — danh sách, tạo, sửa, xóa.
- **Sản phẩm** — danh sách phân trang, tạo, sửa, xóa.
- **Giỏ hàng** — thêm sản phẩm, quản lý item.
- **Điều hướng** — shell chính + chuyển trang kiểu Cupertino toàn cục.

## Cấu hình API

Endpoint khai báo trong [lib/core/constants/api_constants.dart](lib/core/constants/api_constants.dart). Host tự dò theo platform:

| Môi trường              | Host        |
| ----------------------- | ----------- |
| Android emulator        | `10.0.2.2`  |
| iOS sim / web / desktop | `localhost` |
| Thiết bị thật           | dùng `--dart-define=API_HOST=<IP_LAN>` |

Base URL: `http://<host>:1997/api/v1`

Chạy trên thiết bị thật (cùng Wi-Fi với PC):

```bash
flutter run --dart-define=API_HOST=192.168.1.50
```

## Bắt đầu

```bash
# Cài dependency
flutter pub get

# Chạy app
flutter run

# Chạy test
flutter test
```

## API tham khảo

Collection Postman: `SDS Mobile API.postman_collection.json` (thư mục gốc repo).
