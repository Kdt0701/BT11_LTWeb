<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><sitemesh:write property="title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <sitemesh:write property="head"/>
    <style>
        body { display: flex; min-height: 100vh; flex-direction: column; }
        .wrapper { display: flex; flex: 1; }
        .sidebar { min-width: 250px; background: #343a40; color: white; min-height: 100vh; }
        .sidebar a { color: white; text-decoration: none; padding: 10px 20px; display: block; }
        .sidebar a:hover { background: #495057; }
        .content { flex: 1; padding: 20px; background: #f8f9fa; }
    </style>
</head>
<body>
    <%@ include file="/common/admin/header.jsp" %>

    <div class="wrapper">
        <div class="sidebar">
            <div class="py-3 text-center">
                <h4>Admin Panel</h4>
            </div>
            <a href="<c:url value='/admin/home'/>"><i class="fa-solid fa-house me-2"></i>Trang chủ</a>
            <a href="<c:url value='/admin/profile'/>"><i class="fa-solid fa-user me-2"></i>Hồ sơ cá nhân</a>
            <a href="<c:url value='/admin/category/list'/>"><i class="fa-solid fa-list me-2"></i>Quản lý Danh mục</a>
            <a href="<c:url value='/admin/video/list'/>"><i class="fa-solid fa-video me-2"></i>Quản lý Video</a>
            <a href="<c:url value='/logout'/>" class="text-danger"><i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất</a>
        </div>

        <div class="content">
            <sitemesh:write property="body"/>
        </div>
    </div>

    <%@ include file="/common/admin/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>