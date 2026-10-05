<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Cập nhật Video</title>
</head>
<body>
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between">
            <h6 class="m-0 font-weight-bold text-primary">Cập nhật Video: ${video.title}</h6>
            <a href="<c:url value='/admin/video/list'/>" class="btn btn-secondary btn-sm">Quay lại</a>
        </div>
        <div class="card-body">
            <form action="<c:url value='/admin/video/edit'/>" method="post" enctype="multipart/form-data">
                <input type="hidden" name="videoId" value="${video.videoId}">

                <div class="row">
                    <div class="col-md-8">
                        <div class="mb-3">
                            <label class="form-label">Tiêu đề Video</label>
                            <input type="text" class="form-control" name="title" value="${video.title}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea class="form-control" name="description" rows="5">${video.description}</textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Video ID</label>
                            <input type="text" class="form-control bg-light" value="${video.videoId}" disabled>
                            <small class="text-muted">Không thể thay đổi ID Video</small>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="mb-3">
                            <label class="form-label">Danh mục</label>
                            <select class="form-select" name="categoryId">
                                <c:forEach items="${categories}" var="cate">
                                    <option value="${cate.categoryId}" ${cate.categoryId == video.category.categoryId ? 'selected' : ''}>
                                        ${cate.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Poster hiện tại</label>
                            <div class="text-center mb-2">
                                <c:if test="${not empty video.poster}">
                                    <img src="<c:url value='/upload/video/${video.poster}'/>" class="img-fluid rounded shadow-sm" style="max-height: 150px;">
                                </c:if>
                            </div>
                            <label class="form-label">Chọn ảnh mới (Nếu thay đổi)</label>
                            <input type="file" class="form-control" name="poster" accept="image/*">
                        </div>

                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="active" name="active" value="true" ${video.active ? 'checked' : ''}>
                            <label class="form-check-label" for="active">Đang hoạt động</label>
                        </div>
                    </div>
                </div>

                <hr>
                <button type="submit" class="btn btn-primary px-4"><i class="fa-solid fa-pen-to-square me-2"></i>Lưu thay đổi</button>
            </form>
        </div>
    </div>
</body>