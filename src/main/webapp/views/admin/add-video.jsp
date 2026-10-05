<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Thêm Video mới</title>
</head>
<body>
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between">
            <h6 class="m-0 font-weight-bold text-success">Thêm Video Mới</h6>
            <a href="<c:url value='/admin/video/list'/>" class="btn btn-secondary btn-sm">Danh sách</a>
        </div>
        <div class="card-body">
            <form action="<c:url value='/admin/video/add'/>" method="post" enctype="multipart/form-data">
                
                <div class="row">
                    <div class="col-md-8">
                        <div class="mb-3">
                            <label class="form-label">Tiêu đề Video <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="title" required placeholder="Nhập tiêu đề video...">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea class="form-control" name="description" rows="5" placeholder="Mô tả nội dung video..."></textarea>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="mb-3">
                            <label class="form-label">Video ID (Mã thủ công)</label>
                            <input type="text" class="form-control" name="videoId" required placeholder="VD: V001">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Danh mục <span class="text-danger">*</span></label>
                            <select class="form-select" name="categoryId" required>
                                <option value="">-- Chọn danh mục --</option>
                                <c:forEach items="${categories}" var="cate">
                                    <option value="${cate.categoryId}">${cate.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Poster / Thumbnail</label>
                            <input type="file" class="form-control" name="poster" accept="image/*">
                        </div>

                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="active" name="active" value="true" checked>
                            <label class="form-check-label" for="active">Kích hoạt ngay</label>
                        </div>
                    </div>
                </div>

                <hr>
                <button type="submit" class="btn btn-success px-4"><i class="fa-solid fa-floppy-disk me-2"></i>Lưu Video</button>
            </form>
        </div>
    </div>
</body>