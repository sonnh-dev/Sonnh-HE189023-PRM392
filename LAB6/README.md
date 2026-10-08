# LAB6 – Building a Responsive Movie Genre Browsing Screen

**Môn học:** PRM392  
**Sinh viên:** Sonnh – HE189023

Ứng dụng Flutter tìm kiếm, lọc thể loại và sắp xếp phim. Cách viết screen tương tự LAB4–5: khai báo state ở đầu, xử lý và dựng giao diện trong `build()`, tách hàm `_buildMovieCard()` ở cuối.

## Cấu trúc

```text
lib/
├── main.dart                   # Khởi chạy và cấu hình ứng dụng
├── data/
│   ├── movie_data.dart         # Lớp Movie và 6 phim mẫu
│   └── genre_data.dart         # Danh sách thể loại
└── screens/
    └── genre_screen.dart       # Enum, state, bộ lọc và toàn bộ giao diện
```

## Chức năng theo đề

| Phần | Nội dung |
| --- | --- |
| LAB6.1 | Tiêu đề **Find a Movie**, `SafeArea`, bố cục responsive. |
| LAB6.2 | Ô tìm kiếm, chip thể loại trong `Wrap`, dropdown sắp xếp. |
| LAB6.3 | Dưới 800 px: danh sách một cột. Từ 800 px: lưới hai cột. |

- Tìm theo tên không phân biệt hoa/thường, bỏ khoảng trắng ở hai đầu.
- Chọn nhiều thể loại: phim chỉ cần thuộc một thể loại đã chọn. Không chọn thể loại thì hiển thị mọi thể loại.
- Tìm kiếm và thể loại được áp dụng cùng lúc.
- Sắp xếp **A-Z**, **Z-A**, **Year** (mới nhất trước), **Rating** (cao nhất trước).
- Thẻ phim có ảnh, tên, năm, thể loại và điểm đánh giá.
- Có số kết quả, số thể loại đã chọn và thông báo khi không có kết quả.
- **Clear filters** xóa từ khóa, bỏ chọn thể loại và đưa sắp xếp về A-Z.
- Ảnh Picsum là ảnh minh họa. Nếu tải ảnh lỗi, hiển thị biểu tượng phim.
- Chỉ dùng Flutter/Dart, không thêm package bên thứ ba.

## Cách đọc screen

1. `MovieSort`: bốn lựa chọn sắp xếp, nằm ngay trong file screen.
2. Các biến state: từ khóa, thể loại đã chọn và cách sắp xếp hiện tại.
3. `_clearFilters()`: đưa bộ lọc về trạng thái ban đầu.
4. `build()`: dùng `where()` lọc phim, `sort()` sắp xếp và dựng giao diện. `onChanged`/`onSelected` gọi `setState` để cập nhật màn hình, giống cách xử lý input ở LAB4.
5. `_buildMovieCard()`: dựng thẻ phim bằng `Card`, `Row`, `Expanded` và `Column`, tương tự LAB5.

`LayoutBuilder` kiểm tra chiều rộng 800 logical pixels. Màn hình hẹp đưa các thẻ trực tiếp vào `ListView` bằng `.map()`, giống LAB5. Màn hình rộng dùng `GridView.count` hai cột. Toàn bộ nội dung cuộn trong `ListView` ngoài; lưới tắt cuộn riêng bằng `NeverScrollableScrollPhysics` và dùng `shrinkWrap`.

`Wrap` giúp chip và thanh sắp xếp tự xuống dòng. `MediaQuery.textScalerOf` điều chỉnh chiều cao hàng lưới theo cỡ chữ hệ thống. Bộ lọc chỉ được lưu trong phiên chạy.

## Chạy ứng dụng

Cần Flutter SDK tương thích với `pubspec.yaml`, Android SDK và thiết bị/emulator. Từ thư mục gốc repository:

```powershell
cd LAB6
flutter pub get
flutter run
```

Trong Android Studio/VS Code, mở thư mục `LAB6` và chạy `lib/main.dart`. Quyền `INTERNET` đã khai báo trong Android manifest để tải ảnh.

## DartPad

Đề yêu cầu demo một file, nên có bản gộp tại `dartpad/main.dart`. Sau khi sửa `lib/`, chạy từ thư mục `LAB6`:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\update_dartpad.ps1
```

Sao chép toàn bộ `dartpad/main.dart` vào [DartPad](https://dartpad.dev/) ở chế độ Flutter và chọn **Run**.

## Kiểm tra

Đã chạy `dart analyze lib dartpad/main.dart`: **No issues found**. Không viết hoặc chạy test theo yêu cầu. Chưa build APK hoặc chạy trên thiết bị/DartPad.
