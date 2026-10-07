-- =========================================================
-- BT11 LTWeb - CHỨC NĂNG HOÀN TRẢ ĐƠN HÀNG
-- DBMS: SQL Server
-- Database: kt_giuaky
-- =========================================================

-- Kiểm tra database trước khi USE để tránh chạy nhầm trên master.
IF DB_ID(N'kt_giuaky') IS NULL
BEGIN
    THROW 50001, N'Không tìm thấy database kt_giuaky. Hãy chạy database/database.sql trước.', 1;
END
GO

USE kt_giuaky;
GO

-- =========================================================
-- 1. BỔ SUNG CÁC CỘT CHO BẢNG orders
-- =========================================================

IF COL_LENGTH(N'dbo.orders', N'deliveredAt') IS NULL
BEGIN
    ALTER TABLE dbo.orders ADD deliveredAt DATETIME2 NULL;
END
GO

IF COL_LENGTH(N'dbo.orders', N'returnReason') IS NULL
BEGIN
    ALTER TABLE dbo.orders ADD returnReason NVARCHAR(1000) NULL;
END
GO

IF COL_LENGTH(N'dbo.orders', N'returnStatus') IS NULL
BEGIN
    ALTER TABLE dbo.orders
    ADD returnStatus NVARCHAR(20) NOT NULL
        CONSTRAINT DF_orders_returnStatus DEFAULT N'NONE';
END
GO

IF COL_LENGTH(N'dbo.orders', N'returnRequestedAt') IS NULL
BEGIN
    ALTER TABLE dbo.orders ADD returnRequestedAt DATETIME2 NULL;
END
GO

-- =========================================================
-- 2. CHUẨN HÓA DỮ LIỆU CŨ
-- Các đơn đã giao nhưng chưa có deliveredAt sẽ được gán
-- thời điểm hiện tại để hệ thống có thể kiểm tra hạn 7 ngày.
-- =========================================================

UPDATE dbo.orders
SET deliveredAt = SYSDATETIME()
WHERE status = N'Đã giao'
  AND deliveredAt IS NULL;
GO

UPDATE dbo.orders
SET returnStatus = N'NONE'
WHERE returnStatus IS NULL;
GO

-- =========================================================
-- 3. KIỂM TRA ĐƠN ĐÃ GIAO
-- =========================================================

SELECT
    orderId,
    username,
    status,
    orderDate,
    deliveredAt,
    DATEADD(DAY, 7, deliveredAt) AS returnDeadline,
    returnStatus,
    returnRequestedAt,
    returnReason
FROM dbo.orders
WHERE status = N'Đã giao'
ORDER BY deliveredAt DESC;
GO

-- =========================================================
-- 4. KIỂM TRA CÁC YÊU CẦU HOÀN TRẢ ĐANG CHỜ ADMIN
-- =========================================================

SELECT
    orderId,
    username,
    status,
    deliveredAt,
    returnStatus,
    returnRequestedAt,
    returnReason
FROM dbo.orders
WHERE returnStatus = N'PENDING'
ORDER BY returnRequestedAt DESC;
GO

-- =========================================================
-- 5. KIỂM TRA ĐƠN CỦA USER02
-- =========================================================

SELECT
    orderId,
    username,
    status,
    orderDate,
    deliveredAt,
    DATEADD(DAY, 7, deliveredAt) AS returnDeadline,
    returnStatus,
    returnRequestedAt,
    returnReason
FROM dbo.orders
WHERE username = N'user02'
ORDER BY orderDate DESC;
GO

-- =========================================================
-- 6. KIỂM TRA CÁC ĐƠN CÒN TRONG HẠN HOÀN 7 NGÀY
-- =========================================================

SELECT
    orderId,
    username,
    deliveredAt,
    DATEADD(DAY, 7, deliveredAt) AS returnDeadline,
    returnStatus
FROM dbo.orders
WHERE status = N'Đã giao'
  AND deliveredAt IS NOT NULL
  AND DATEADD(DAY, 7, deliveredAt) >= SYSDATETIME()
ORDER BY returnDeadline ASC;
GO

-- =========================================================
-- 7. KIỂM TRA CÁC ĐƠN ĐÃ QUÁ HẠN 7 NGÀY
-- =========================================================

SELECT
    orderId,
    username,
    deliveredAt,
    DATEADD(DAY, 7, deliveredAt) AS returnDeadline,
    returnStatus
FROM dbo.orders
WHERE status = N'Đã giao'
  AND deliveredAt IS NOT NULL
  AND DATEADD(DAY, 7, deliveredAt) < SYSDATETIME()
ORDER BY returnDeadline DESC;
GO

-- =========================================================
-- 8. RESET YÊU CẦU HOÀN TRẢ CHO TEST (TÙY CHỌN)
-- Bỏ comment và thay orderId khi cần reset một đơn về NONE.
-- =========================================================

-- UPDATE dbo.orders
-- SET returnStatus = N'NONE',
--     returnReason = NULL,
--     returnRequestedAt = NULL
-- WHERE orderId = 1;
-- GO
