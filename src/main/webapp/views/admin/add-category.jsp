<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Thêm danh mục mới</title>
</head>
<body>
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
            <h6 class="m-0 font-weight-bold text-primary">Thêm danh mục mới</h6>
            <a href="<c:url value='/admin/category/list'/>" class="btn btn-secondary btn-sm">Quay lại</a>
        </div>
        <div class="card-body">
            <c:if test="${not empty message}">
                <div class="alert alert-danger">${message}</div>
            </c:if>

            <form action="<c:url value='/admin/category/add'/>" method="post" enctype="multipart/form-data">
                <div class="mb-3">
                    <label for="catename" class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="catename" name="catename" required placeholder="Nhập tên danh mục...">
                </div>

                <div class="mb-3">
                    <label for="icon" class="form-label">Icon / Hình ảnh</label>
                    <input type="file" class="form-control" id="icon" name="icon" accept="image/*">
                </div>

                <div class="mb-3">
                    <label for="status" class="form-label">Trạng thái</label>
                    <select class="form-select" id="status" name="status">
                        <option value="1">Hoạt động</option>
                        <option value="0">Khóa</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-success"><i class="fa-solid fa-floppy-disk me-2"></i>Lưu lại</button>
                <button type="reset" class="btn btn-outline-warning">Nhập lại</button>
            </form>
        </div>
    </div>
</body>