-- Chạy 1 lần trên database BT11 để bổ sung chức năng hoàn trả đơn hàng.
IF COL_LENGTH('orders', 'deliveredAt') IS NULL
    ALTER TABLE orders ADD deliveredAt DATETIME2 NULL;
IF COL_LENGTH('orders', 'returnReason') IS NULL
    ALTER TABLE orders ADD returnReason NVARCHAR(1000) NULL;
IF COL_LENGTH('orders', 'returnStatus') IS NULL
    ALTER TABLE orders ADD returnStatus NVARCHAR(20) NOT NULL CONSTRAINT DF_orders_returnStatus DEFAULT N'NONE';
IF COL_LENGTH('orders', 'returnRequestedAt') IS NULL
    ALTER TABLE orders ADD returnRequestedAt DATETIME2 NULL;
GO

-- Kiểm tra các yêu cầu hoàn trả đang chờ Admin.
SELECT orderId, username, status, deliveredAt, returnStatus, returnRequestedAt, returnReason
FROM orders
WHERE returnStatus = N'PENDING'
ORDER BY returnRequestedAt DESC;
GO
