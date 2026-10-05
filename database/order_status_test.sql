USE kt_giuaky;
GO

-- Admin dùng trang /admin/orders để duyệt đơn.
-- File này chỉ dùng để kiểm tra chức năng lọc lịch sử của User.
-- Thay 1 bằng orderId thực tế trong database.

-- 1. Đơn hàng mới
UPDATE orders SET status = N'Đơn hàng mới' WHERE orderId = 1;

-- 2. Đã xác nhận
UPDATE orders SET status = N'Đã xác nhận' WHERE orderId = 1;

-- 3. Chuẩn bị hàng
UPDATE orders SET status = N'Chuẩn bị hàng' WHERE orderId = 1;

-- 4. Vận chuyển
UPDATE orders SET status = N'Vận chuyển' WHERE orderId = 1;

-- 5. Giao hàng
UPDATE orders SET status = N'Giao hàng' WHERE orderId = 1;

-- 6. Đã giao
UPDATE orders SET status = N'Đã giao' WHERE orderId = 1;

-- 7. Đơn hàng hủy
UPDATE orders SET status = N'Đơn hàng hủy' WHERE orderId = 1;

-- 8. Đơn hàng hoàn
UPDATE orders SET status = N'Đơn hàng hoàn' WHERE orderId = 1;

-- Kiểm tra danh sách đơn và trạng thái hiện tại
SELECT orderId, username, status, paymentMethod, totalAmount, orderDate
FROM orders
ORDER BY orderDate DESC;
GO


-- =========================================================
-- TEST HOÀN TRẢ ĐƠN HÀNG
-- =========================================================
-- Khi test trạng thái bằng SQL, nhớ đặt deliveredAt để hệ thống có mốc 7 ngày.
-- Ví dụ đơn #1 vừa được giao hôm nay:
UPDATE orders
SET status = N'Đã giao', deliveredAt = SYSDATETIME(), returnStatus = N'NONE'
WHERE orderId = 1;
GO

-- Test đơn đã quá 7 ngày: User sẽ không được gửi yêu cầu hoàn.
-- UPDATE orders SET status = N'Đã giao', deliveredAt = DATEADD(DAY, -8, SYSDATETIME()), returnStatus = N'NONE' WHERE orderId = 1;
-- GO
