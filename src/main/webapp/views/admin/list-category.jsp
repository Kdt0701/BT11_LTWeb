<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Quản lý Danh mục</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Danh sách Danh mục</h2>
        <a href="<c:url value='/admin/category/add'/>" class="btn btn-success"><i class="fa-solid fa-plus"></i> Thêm mới</a>
    </div>

    <table class="table table-bordered table-hover shadow bg-white">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Tên danh mục</th>
                <th>Icon</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${categories}" var="cate">
                <tr>
                    <td>${cate.categoryId}</td>
                    <td>${cate.categoryName}</td>
                    <td>
                        <c:if test="${not empty cate.images}">
                            <img src="<c:url value='/upload/category/${cate.images}'/>" width="50" height="50" style="object-fit: cover">
                        </c:if>
                    </td>
                    <td>
                        <a href="<c:url value='/admin/category/edit?id=${cate.categoryId}'/>" class="btn btn-primary btn-sm">Sửa</a>
                        <a href="<c:url value='/admin/category/delete?id=${cate.categoryId}'/>" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc muốn xóa?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>