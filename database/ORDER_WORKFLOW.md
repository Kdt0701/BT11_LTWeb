# Luồng giỏ hàng - COD - đơn hàng

## User
1. Đăng nhập.
2. Vào SẢN PHẨM hoặc chi tiết sản phẩm.
3. Chọn **Thêm vào giỏ**.
4. Vào **Giỏ hàng** để:
   - sửa số lượng;
   - số lượng không vượt quá tồn kho;
   - xóa sản phẩm;
   - tiếp tục mua hàng.
5. Chọn **Thanh toán COD**.
6. Nhập thông tin nhận hàng và tạo đơn.
7. Đơn mới có trạng thái `Đơn hàng mới`.
8. Vào **Lịch sử đặt hàng** để lọc theo 8 trạng thái.

## Admin
1. Đăng nhập bằng tài khoản có `admin = 1`.
2. Vào **Quản lý đơn hàng**.
3. Xem tất cả đơn hàng hoặc lọc theo trạng thái.
4. Chọn **Xem / duyệt** để xem chi tiết đơn.
5. Chọn trạng thái mới và cập nhật.

## 8 trạng thái
- Đơn hàng mới
- Đã xác nhận
- Chuẩn bị hàng
- Vận chuyển
- Giao hàng
- Đã giao
- Đơn hàng hủy
- Đơn hàng hoàn

## Kiểm tra database
Có file `database/order_status_test.sql` để đổi trạng thái thủ công và kiểm tra bộ lọc lịch sử của User.
