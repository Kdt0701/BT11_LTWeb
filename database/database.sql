-- =========================================================
-- DATABASE INITIALIZATION SCRIPT FOR JPA/HIBERNATE PROJECT
-- DBMS: SQL Server
-- Database Name: kt_giuaky
-- =========================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'kt_giuaky')
BEGIN
    CREATE DATABASE kt_giuaky;
END
GO

USE kt_giuaky;
GO

-- Drop tables if exists (Xóa sạch tất cả biến thể tên bảng cũ để tránh xung đột)
IF OBJECT_ID('dbo.order_details', 'U') IS NOT NULL DROP TABLE dbo.order_details;
IF OBJECT_ID('dbo.orders', 'U') IS NOT NULL DROP TABLE dbo.orders;

IF OBJECT_ID('dbo.shares', 'U') IS NOT NULL DROP TABLE dbo.shares;
IF OBJECT_ID('dbo.share', 'U') IS NOT NULL DROP TABLE dbo.share;
IF OBJECT_ID('dbo.Share', 'U') IS NOT NULL DROP TABLE dbo.Share;
IF OBJECT_ID('dbo.Shares', 'U') IS NOT NULL DROP TABLE dbo.Shares;

IF OBJECT_ID('dbo.favorites', 'U') IS NOT NULL DROP TABLE dbo.favorites;
IF OBJECT_ID('dbo.favorite', 'U') IS NOT NULL DROP TABLE dbo.favorite;
IF OBJECT_ID('dbo.Favorite', 'U') IS NOT NULL DROP TABLE dbo.Favorite;
IF OBJECT_ID('dbo.Favorites', 'U') IS NOT NULL DROP TABLE dbo.Favorites;

IF OBJECT_ID('dbo.videos', 'U') IS NOT NULL DROP TABLE dbo.videos;
IF OBJECT_ID('dbo.video', 'U') IS NOT NULL DROP TABLE dbo.video;
IF OBJECT_ID('dbo.Video', 'U') IS NOT NULL DROP TABLE dbo.Video;

IF OBJECT_ID('dbo.categories', 'U') IS NOT NULL DROP TABLE dbo.categories;
IF OBJECT_ID('dbo.category', 'U') IS NOT NULL DROP TABLE dbo.category;
IF OBJECT_ID('dbo.Category', 'U') IS NOT NULL DROP TABLE dbo.Category;

IF OBJECT_ID('dbo.users', 'U') IS NOT NULL DROP TABLE dbo.users;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
GO

-- 1. Table: users (@Table(name = "users"))
CREATE TABLE users (
    username NVARCHAR(50) PRIMARY KEY,
    password NVARCHAR(100) NOT NULL,
    fullname NVARCHAR(255) NULL,
    email NVARCHAR(100) NULL,
    phone NVARCHAR(15) NULL,
    images NVARCHAR(500) NULL,
    admin BIT DEFAULT 0,
    active BIT DEFAULT 1
);
GO

-- 2. Table: categories (@Table(name = "categories"))
CREATE TABLE categories (
    categoryId INT IDENTITY(1,1) PRIMARY KEY,
    categoryName NVARCHAR(200) NOT NULL,
    code NVARCHAR(50),
    images NVARCHAR(500),
    status INT DEFAULT 1
);
GO

-- 3. Table: videos (@Table(name = "videos"))
CREATE TABLE videos (
    videoId NVARCHAR(50) PRIMARY KEY,
    title NVARCHAR(200) NOT NULL,
    poster NVARCHAR(500),
    views INT DEFAULT 0,
    price DECIMAL(18,2) NOT NULL DEFAULT 0,
    stock INT NOT NULL DEFAULT 0,
    description NVARCHAR(MAX),
    active BIT DEFAULT 1,
    categoryId INT,
    FOREIGN KEY (categoryId) REFERENCES categories(categoryId) ON DELETE SET NULL
);
GO

-- 4. Table: favorites (@Table(name = "favorites"))
CREATE TABLE favorites (
    favoriteId INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL,
    videoId NVARCHAR(50) NOT NULL,
    likeDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE,
    FOREIGN KEY (videoId) REFERENCES videos(videoId) ON DELETE CASCADE,
    CONSTRAINT UC_User_Video UNIQUE (username, videoId)
);
GO

-- 5. Table: shares (@Table(name = "shares"))
CREATE TABLE shares (
    shareId INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL,
    videoId NVARCHAR(50) NOT NULL,
    emails NVARCHAR(MAX),
    shareDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE,
    FOREIGN KEY (videoId) REFERENCES videos(videoId) ON DELETE CASCADE
);
GO

-- =========================================================
-- SAMPLE DATA INSERTION
-- =========================================================

INSERT INTO users (username, password, email, fullname, images, phone, admin, active) VALUES
('admin', '123456', 'admin@iotstar.vn', N'Quản Trị Viên', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500', '0901234567', 1, 1),
('user01', '123456', 'nguyenvana@gmail.com', N'Nguyễn Văn A', 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500', '0912345678', 0, 1),
('user02', '123456', 'tranthib@gmail.com', N'Trần Thị B', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500', '0923456789', 0, 1),
('user03', '123456', 'levanc@gmail.com', N'Lê Văn C', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500', '0934567890', 0, 1);

INSERT INTO categories (categoryName, code, images, status) VALUES
(N'Lập Trình Java', 'JAVA', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=500', 1),
(N'Lập Trình Web', 'WEB', 'https://images.unsplash.com/photo-1547658719-da2b51169166?w=500', 1),
(N'Cơ Sở Dữ Liệu', 'DATABASE', 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=500', 1),
(N'Giải Trí & Công Nghệ', 'TECH', 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=500', 1);

INSERT INTO videos (videoId, title, poster, views, price, stock, description, active, categoryId) VALUES
('VID001', N'Hướng Dẫn Hướng Đối Tượng Java OOP', 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=500', 1500, 99000, 20, N'Bài giảng chi tiết về OOP trong Java dành cho người mới bắt đầu.', 1, 1),
('VID002', N'Tạo Web App với JSP/Servlet và JPA', 'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=500', 3200, 149000, 15, N'Hướng dẫn xây dựng ứng dụng CRUD hoàn chỉnh với Jakarta EE.', 1, 2),
('VID003', N'Thiết Kế Cơ Sở Dữ Liệu Chuẩn hóa SQL', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=500', 850, 129000, 12, N'Các bước thiết kế CSDL từ dạng chuẩn 1NF đến 3NF trong SQL Server.', 1, 3),
('VID004', N'Xu Hướng Công Nghệ AI 2026', 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=500', 5400, 199000, 10, N'Tổng hợp các công nghệ trí tuệ nhân tạo đột phá trong năm nay.', 1, 4);

INSERT INTO favorites (username, videoId, likeDate) VALUES
('user01', 'VID001', '2026-03-01 08:30:00'),
('user01', 'VID002', '2026-03-02 10:15:00'),
('user02', 'VID002', '2026-03-03 14:20:00'),
('user03', 'VID004', '2026-03-04 19:45:00');

INSERT INTO shares (username, videoId, emails, shareDate) VALUES
('user01', 'VID002', 'friend1@gmail.com, friend2@gmail.com', '2026-03-02 11:00:00'),
('user02', 'VID004', 'colleague@company.com', '2026-03-04 20:00:00');
GO

-- =========================================================
-- ORDER / COD / SHOPPING CART SUPPORT
-- =========================================================
CREATE TABLE orders (
    orderId BIGINT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL,
    status NVARCHAR(30) NOT NULL DEFAULT N'Đơn hàng mới',
    paymentMethod NVARCHAR(30) NOT NULL DEFAULT N'COD',
    totalAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    shippingAddress NVARCHAR(255) NOT NULL,
    receiverName NVARCHAR(100) NOT NULL,
    receiverPhone NVARCHAR(20) NOT NULL,
    orderDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    deliveredAt DATETIME2 NULL,
    returnReason NVARCHAR(1000) NULL,
    returnStatus NVARCHAR(20) NOT NULL DEFAULT N'NONE',
    returnRequestedAt DATETIME2 NULL,
    FOREIGN KEY (username) REFERENCES users(username)
);
GO

CREATE TABLE order_details (
    orderDetailId BIGINT IDENTITY(1,1) PRIMARY KEY,
    orderId BIGINT NOT NULL,
    videoId NVARCHAR(50) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unitPrice DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE,
    FOREIGN KEY (videoId) REFERENCES videos(videoId)
);
GO
