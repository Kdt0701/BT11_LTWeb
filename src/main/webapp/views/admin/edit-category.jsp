<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Chỉnh sửa danh mục</title>
</head>
<body>
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
            <h6 class="m-0 font-weight-bold text-primary">Cập nhật danh mục: ${category.categoryName}</h6>
            <a href="<c:url value='/admin/category/list'/>" class="btn btn-secondary btn-sm">Quay lại</a>
        </div>
        <div class="card-body">
            <form action="<c:url value='/admin/category/edit'/>" method="post" enctype="multipart/form-data">
                <input type="hidden" name="categoryid" value="${category.categoryId}">

                <div class="mb-3">
                    <label for="catename" class="form-label">Tên danh mục</label>
                    <input type="text" class="form-control" id="catename" name="catename" value="${category.categoryName}" required>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="icon" class="form-label">Thay đổi Icon (Nếu cần)</label>
                        <input type="file" class="form-control" id="icon" name="icon" accept="image/*">
                    </div>
                    <div class="col-md-6 text-center">
                        <label class="form-label d-block">Icon hiện tại</label>
                        <c:if test="${not empty category.images}">
                            <img src="<c:url value='/upload/category/${category.images}'/>" height="100" class="img-thumbnail">
                        </c:if>
                        <c:if test="${empty category.images}">
                            <span class="badge bg-secondary">Chưa có icon</span>
                        </c:if>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="status" class="form-label">Trạng thái</label>
                    <select class="form-select" id="status" name="status">
                        <option value="1" ${category.status == 1 ? 'selected' : ''}>Hoạt động</option>
                        <option value="0" ${category.status == 0 ? 'selected' : ''}>Khóa</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-pen-to-square me-2"></i>Cập nhật</button>
            </form>
        </div>
    </div>
</body>