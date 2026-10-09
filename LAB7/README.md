# LAB7 – Building a Signup Form with Validation & Good UX

**Môn học:** PRM392  
**Sinh viên:** Sonnh – HE189023

Form đăng ký viết theo phong cách LAB4–6: dùng `StatefulWidget`, `setState` và dựng giao diện trực tiếp trong `build()`. Các hàm kiểm tra dữ liệu được tách vào `utils/auth_validate.dart` để dùng trong màn hình đăng ký.

## Cấu trúc

```text
LAB7/
├── lib/
│   ├── main.dart                   # Khởi chạy, MaterialApp và theme
│   ├── screens/
│   │   └── signup_screen.dart      # Form, validation và submit
│   └── utils/
│       └── auth_validate.dart      # Bốn hàm kiểm tra dữ liệu
├── tools/update_dartpad.ps1         # Gộp mã thành một file
├── dartpad/main.dart               # Bản một file dùng trên DartPad
├── web/index.html                  # Điểm khởi chạy bản web
├── screenshots/                    # Ba ảnh minh họa phiên bản trước khi rút gọn
├── submission/                     # File ZIP nộp bài
└── README.md
```

## Nội dung theo đề

| Phần | Triển khai |
| --- | --- |
| LAB7.1 | `Form`, `GlobalKey<FormState>`, bốn `TextFormField` và nút **Sign up**. |
| LAB7.2 | Kiểm tra dữ liệu bằng `validator`, lỗi dưới từng ô, `AutovalidateMode.onUserInteraction`. |
| LAB7.3 | Form nằm trong `ListView` để cuộn; người dùng tự chọn ô cần nhập, không quản lý focus bằng code. |
| LAB7.4 | Giả lập kiểm tra email trong 2 giây bằng `Future.delayed`. Khóa nút và các ô nhập trong khi chờ. |

Các quy tắc:

- **Full name:** bắt buộc, không chấp nhận chuỗi chỉ có khoảng trắng.
- **Email:** bắt buộc, dạng `name@example.com`, không có khoảng trắng bên trong. Khoảng trắng ở hai đầu được bỏ khi kiểm tra/lưu.
- **Password:** bắt buộc, ít nhất 8 ký tự và có ít nhất 1 chữ số.
- **Confirm password:** bắt buộc và phải giống hoàn toàn mật khẩu.
- Nếu form không hợp lệ, `_submit()` dừng ngay và hiển thị lỗi.
- Email bắt đầu bằng `taken` (không phân biệt hoa/thường) sẽ nhận thông báo **This email is already taken** sau khi chờ.
- Nếu dữ liệu hợp lệ và email được chấp nhận, hiển thị SnackBar **Signup successful. Welcome, ...!**.
- Hai ô mật khẩu dùng `obscureText: true` để ẩn nội dung.

Đây là demo trong bộ nhớ: không gọi API thật, không lưu tài khoản hoặc mật khẩu. Không thêm package bên thứ ba.

## Cách đọc code

1. Trong `signup_screen.dart`, các biến state gồm key của form, controller mật khẩu, họ tên, email và trạng thái gửi.
2. `auth_validate.dart` chứa bốn hàm `validateName()`, `validateEmail()`, `validatePassword()` và `validateConfirmPassword()`, trả về thông báo lỗi hoặc `null` nếu hợp lệ. Màn hình truyền `_passwordController.text` vào `validateConfirmPassword(value, password)` để so sánh; file validator không phụ thuộc vào controller hay widget.
3. `_submit()` gọi `validate()`, `save()`, chờ kiểm tra email rồi hiển thị kết quả. `onSaved` lưu họ tên và email đã bỏ khoảng trắng hai đầu.
4. `build()` dựng toàn bộ giao diện. Các ô nhập dùng `labelText`, `OutlineInputBorder` và `validator`; `onSaved` lưu họ tên và email.
5. `dispose()` giải phóng controller khi đóng màn hình. `mounted` tránh cập nhật màn hình đã đóng sau khi chờ.

Chọn từng ô để nhập dữ liệu, sau đó nhấn **Sign up** để gọi `_submit()`.

## Chạy ứng dụng

Cần Flutter SDK tương thích với `pubspec.yaml` (Dart `^3.13.4`). Từ thư mục gốc repository:

```powershell
cd LAB7
flutter pub get
flutter run
```

Mở thư mục `LAB7` trong Android Studio/VS Code, chọn thiết bị và chạy `lib/main.dart`.

Để chạy trên Chrome:

```powershell
flutter run -d chrome
```

## DartPad

Đề yêu cầu demo một file. Khi sửa code trong `lib/`, chạy lệnh sau từ thư mục `LAB7`:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\update_dartpad.ps1
```

Script gộp lần lượt `utils/auth_validate.dart`, `screens/signup_screen.dart` và `main.dart`, bỏ các dòng import nội bộ để tạo bản một file. Sao chép toàn bộ `dartpad/main.dart` vào [DartPad](https://dartpad.dev/) ở chế độ Flutter và chọn **Run**.

## Dữ liệu minh họa

| Trường hợp | Dữ liệu |
| --- | --- |
| Hợp lệ | Full name: `Nguyen Hoang Son`, email: `son@example.com`, password và confirm: `Flutter123`. |
| Bỏ trống | Nhấn **Sign up** khi chưa nhập: lỗi ở cả bốn ô. |
| Sai email | `son.example.com`. |
| Mật khẩu ngắn | `abc123`. |
| Mật khẩu không có số | `abcdefgh`. |
| Xác nhận sai | Password `Flutter123`, confirm `Flutter124`. |
| Email đã dùng | `taken@example.com`, các trường còn lại hợp lệ. |

## Kiểm tra

- `dart analyze lib dartpad/main.dart`: **No issues found**.
- `flutter build web --no-pub --no-web-resources-cdn`: build thành công.
- Ba ảnh bên dưới được chụp từ phiên bản trước khi rút gọn giao diện. Bản hiện tại vẫn khóa nút và các ô nhập khi chờ email.
- Không viết hoặc chạy test tự động theo yêu cầu trước đó. Chưa build APK hoặc chạy trên Android.

## Ảnh chụp và nộp bài

Các ảnh minh họa được giữ từ phiên bản trước khi rút gọn; hình thức ô nhập có thể khác bản hiện tại.

| Ảnh | Nội dung |
| --- | --- |
| [validation_errors.jpg](screenshots/validation_errors.jpg) | Form trống, lỗi ngay dưới cả bốn ô. |
| [email_taken.jpg](screenshots/email_taken.jpg) | Dữ liệu hợp lệ nhưng email đã dùng. |
| [signup_success.jpg](screenshots/signup_success.jpg) | Dữ liệu hợp lệ và thông báo thành công. |

File nộp bài: `submission/LAB7_Sonnh_HE189023.zip`. Bản ZIP gồm mã nguồn, cấu hình Android/web, README, bản DartPad và ảnh; không gồm cache, thư mục build hoặc cấu hình SDK riêng của máy. Giải nén, mở thư mục `LAB7` và chạy `flutter pub get` trước khi chạy ứng dụng.
