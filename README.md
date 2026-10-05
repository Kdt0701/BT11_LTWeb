# BT11_LTWeb - Chức năng User và quản lý đơn hàng

## 1. Mô tả

Project bài kiểm tra quá trình Java Web. Phiên bản hiện tại tập trung vào các chức năng mua hàng của **User** và quy trình **Admin xác nhận, cập nhật, xử lý hoàn trả đơn hàng**.

Công nghệ chính:

- Java / Jakarta Servlet
- JSP / JSTL
- JPA / Hibernate
- Maven
- SQL Server
- MVC
- Tomcat

## 2. Chức năng User

### 2.1. Giỏ hàng

User có thể:

- Xem sản phẩm.
- Thêm sản phẩm vào giỏ hàng.
- Sửa số lượng.
- Xóa sản phẩm.
- Số lượng không được vượt quá tồn kho.
- Thanh toán bằng **COD**.

### 2.2. Đơn hàng mới

Sau khi thanh toán COD, đơn được tạo với trạng thái:

`Đơn hàng mới`

Trước khi Admin xác nhận, User được phép:

- Thêm sản phẩm vào đơn.
- Xóa sản phẩm khỏi đơn.
- Sửa số lượng.
- Thay đổi số lượng trong giới hạn tồn kho.
- Hủy đơn hàng.

Khi User hủy đơn ở trạng thái `Đơn hàng mới`, hệ thống tự động chuyển sang:

`Đơn hàng hủy`

Không cần Admin duyệt.

### 2.3. Khóa đơn sau khi Admin xác nhận

Khi Admin chuyển đơn từ `Đơn hàng mới` sang trạng thái tiếp theo, User không còn được:

- Thêm sản phẩm.
- Xóa sản phẩm.
- Sửa số lượng.
- Hủy đơn.

Rule này được kiểm tra ở **backend**, không chỉ ẩn nút trên giao diện.

### 2.4. Lịch sử đặt hàng

User có thể xem lịch sử đơn hàng và lọc theo các trạng thái:

1. Đơn hàng mới
2. Đã xác nhận
3. Chuẩn bị hàng
4. Vận chuyển
5. Giao hàng
6. Đã giao
7. Đơn hàng hủy
8. Đơn hàng hoàn

## 3. Hoàn trả đơn hàng

User chỉ có thể gửi yêu cầu hoàn trả khi:

- Đơn có trạng thái `Đã giao`.
- Chưa quá **7 ngày kể từ thời điểm giao hàng**.
- User phải nhập lý do hoàn trả.

Yêu cầu ban đầu có trạng thái:

`returnStatus = PENDING`

Trong thời gian chờ Admin xử lý, đơn vẫn giữ trạng thái `Đã giao`.

### Admin xử lý yêu cầu hoàn

Admin xem lý do hoàn trả và chọn một trong hai phương án:

**Chấp nhận hoàn:**

```text
returnStatus = APPROVED
status = Đơn hàng hoàn
```

**Từ chối hoàn:**

```text
returnStatus = REJECTED
status = Đã giao
```

Hệ thống không cho phép chuyển thủ công sang `Đơn hàng hoàn` nếu chưa có yêu cầu hoàn trả được Admin chấp nhận.

## 4. Quy trình đơn hàng

```text
User thêm sản phẩm
        |
        v
     Giỏ hàng
        |
        v
   Thanh toán COD
        |
        v
  Đơn hàng mới
        |
        +-----------------------------+
        |                             |
        | User chỉnh sửa / hủy        | Admin xác nhận
        |                             |
        v                             v
 Đơn hàng hủy                 Đã xác nhận
                                      |
                                      v
                                Chuẩn bị hàng
                                      |
                                      v
                                  Vận chuyển
                                      |
                                      v
                                   Giao hàng
                                      |
                                      v
                                   Đã giao
                                      |
                                      v
                            User yêu cầu hoàn
                                      |
                                      v
                               Admin xem lý do
                                /           \
                         Chấp nhận         Từ chối
                            |                  |
                            v                  v
                     Đơn hàng hoàn         Đã giao
```

## 5. Các file liên quan đến hoàn trả

- `database/order_return.sql`: migration thêm các cột phục vụ hoàn trả.
- `database/order_status_test.sql`: script kiểm tra các trạng thái đơn hàng và mốc `deliveredAt`.
- `database/ORDER_WORKFLOW.md`: mô tả luồng User/Admin.
- `Order.java`: lưu thời điểm giao, lý do và trạng thái yêu cầu hoàn.
- `OrderDAO_20133056.java`: contract xử lý yêu cầu và duyệt hoàn trả.
- `OrderDAOImpl_20133056.java`: kiểm tra quyền, trạng thái và thời hạn 7 ngày ở backend.
- `OrderService_20133056.java` / `OrderServiceImpl_20133056.java`: tầng service.
- `OrderHistoryController_20133056.java`: User gửi yêu cầu hoàn trả.
- `OrderAdminController_20133056.java`: Admin xử lý yêu cầu hoàn trả.
- `views/web/order-history.jsp`: User xem lịch sử và gửi yêu cầu hoàn.
- `views/admin/order-detail.jsp`: Admin xem lý do và duyệt/từ chối hoàn.

## 6. Cập nhật database

Nếu database hiện tại chưa có các cột hoàn trả, chạy:

```sql
-- database/order_return.sql
```

Các cột được bổ sung:

| Cột | Ý nghĩa |
|---|---|
| `deliveredAt` | Thời điểm đơn được chuyển sang `Đã giao` |
| `returnReason` | Lý do User yêu cầu hoàn |
| `returnStatus` | `NONE`, `PENDING`, `APPROVED`, `REJECTED` |
| `returnRequestedAt` | Thời điểm User gửi yêu cầu hoàn |

## 7. Kiểm tra thời hạn 7 ngày

Khi Admin/User chuyển đơn sang `Đã giao`, hệ thống ghi `deliveredAt`.

Ví dụ đơn vừa giao:

```sql
UPDATE orders
SET status = N'Đã giao',
    deliveredAt = SYSDATETIME(),
    returnStatus = N'NONE'
WHERE orderId = 1;
```

Test đơn quá hạn:

```sql
UPDATE orders
SET status = N'Đã giao',
    deliveredAt = DATEADD(DAY, -8, SYSDATETIME()),
    returnStatus = N'NONE'
WHERE orderId = 1;
```

Trong trường hợp thứ hai, User không thể gửi yêu cầu hoàn trả.

## 8. Tài khoản / quyền

- **User:** mua hàng, quản lý đơn mới, xem lịch sử và gửi yêu cầu hoàn trả.
- Tài khoản mẫu: user01 123456
                 user02 123456
- **Admin:** xem tất cả đơn hàng, xác nhận/cập nhật trạng thái và xử lý yêu cầu hoàn trả.
- Tài khoản mẫu: admin 123456

Các chức năng xử lý đơn hàng của Admin yêu cầu tài khoản có quyền Admin.

## 9. Chạy project

1. Import project vào Eclipse/STS.
2. Maven Update Project.
3. Kiểm tra cấu hình SQL Server trong project.
4. Chạy các script database cần thiết.
5. Cấu hình Tomcat.
6. Run on Server.
7. Đăng nhập bằng tài khoản User để kiểm tra luồng mua hàng.
8. Đăng nhập bằng tài khoản Admin để kiểm tra duyệt đơn và xử lý hoàn trả.

