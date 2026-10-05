<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Hồ sơ cá nhân</title>
</head>
<body>
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Cập nhật thông tin</h6>
        </div>
        <div class="card-body">
            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form method="post" enctype="multipart/form-data">
                <div class="row">
                    <div class="col-md-4 text-center">
                        <c:choose>
                            <c:when test="${not empty user.images}">
                                <img src="<c:url value='/upload/user/${user.images}'/>" class="rounded-circle img-thumbnail mb-3" style="width: 200px; height: 200px; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <img src="https://via.placeholder.com/200" class="rounded-circle img-thumbnail mb-3">
                            </c:otherwise>
                        </c:choose>
                        <div class="mb-3">
                            <label class="form-label">Chọn ảnh mới</label>
                            <input type="file" name="images" class="form-control" accept="image/*">
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="mb-3">
                            <label>Tên đăng nhập</label>
                            <input type="text" class="form-control" value="${user.username}" disabled>
                        </div>
                        <div class="mb-3">
                            <label>Họ và tên</label>
                            <input type="text" name="fullname" class="form-control" value="${user.fullname}" required>
                        </div>
                        <div class="mb-3">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control" value="${user.email}">
                        </div>
                        <div class="mb-3">
                            <label>Số điện thoại</label>
                            <input type="text" name="phone" class="form-control" value="${user.phone}">
                        </div>
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</body>