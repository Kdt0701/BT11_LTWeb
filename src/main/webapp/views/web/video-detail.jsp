<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<head>
    <title>${video.title} | Chi tiết</title>
</head>

<body>
    <div class="container mt-5 mb-5">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<c:url value='/home'/>">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="<c:url value='/video/category?id=${video.category.categoryId}'/>">${video.category.categoryName}</a></li>
                <li class="breadcrumb-item active" aria-current="page">${video.title}</li>
            </ol>
        </nav>

        <div class="card shadow-sm">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4 text-center border-end">
                        <c:choose>
                            <c:when test="${not empty video.poster && video.poster.startsWith('http')}">
                                <img src="${video.poster}" class="img-fluid rounded shadow" alt="${video.title}" style="max-height: 400px;">
                            </c:when>
                            <c:otherwise>
                                <img src="<c:url value='/upload/video/${video.poster}'/>" class="img-fluid rounded shadow" alt="${video.title}" style="max-height: 400px;">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="col-md-8">
                        <h3 class="text-primary fw-bold mb-3">${video.title}</h3>
                        
                        <table class="table table-borderless">
                            <tr>
                                <th style="width: 150px;">Mã video:</th>
                                <td><span class="badge bg-secondary">${video.videoId}</span></td>
                            </tr>
                            <tr>
                                <th>Category name:</th>
                                <td><span class="badge bg-info text-dark">${video.category.categoryName}</span></td>
                            </tr>
                            <tr>
                                <th>Giá:</th>
                                <td><strong class="text-danger">${video.price} đ</strong></td>
                            </tr>
                            <tr>
                                <th>Tồn kho:</th>
                                <td>${video.stock}</td>
                            </tr>
                            <tr>
                                <th>View:</th>
                                <td>${video.views} <i class="fa-solid fa-eye text-muted"></i></td>
                            </tr>
                            <tr>
                                <th>Tương tác:</th>
                                <td>
                                    <button class="btn btn-outline-primary btn-sm me-2">
                                        <i class="fa-solid fa-share"></i> Share (${shareCount})
                                    </button>
                                    
                                    <button class="btn btn-outline-danger btn-sm">
                                        <i class="fa-solid fa-thumbs-up"></i> Like (${likeCount})
                                    </button>
                                </td>
                            </tr>
                        </table>

                        <hr>
                        
                        <div>
                            <h5 class="fw-bold">Mô tả nội dung:</h5>
                            <p class="text-secondary" style="text-align: justify;">
                                ${video.description}
                            </p>
                        </div>

                        <hr>
                        <div class="d-flex align-items-center gap-3">
                            <c:choose>
                                <c:when test="${video.active && video.stock > 0}">
                                    <form action="<c:url value='/cart/add'/>" method="post" class="d-flex align-items-center gap-2">
                                        <input type="hidden" name="id" value="${video.videoId}">
                                        <label for="detailQuantity" class="fw-bold mb-0">Số lượng:</label>
                                        <input id="detailQuantity" type="number" name="quantity" value="1" min="1" max="${video.stock}" class="form-control" style="width:90px;">
                                        <button type="submit" class="btn btn-danger">
                                            <i class="fa-solid fa-cart-plus me-1"></i> Thêm vào giỏ
                                        </button>
                                    </form>
                                    <span class="text-muted small">Tối đa ${video.stock} sản phẩm</span>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="btn btn-secondary" disabled>Hết hàng</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="mt-3">
            <a href="javascript:history.back()" class="btn btn-secondary">
                <i class="fa-solid fa-arrow-left"></i> Quay lại
            </a>
        </div>
    </div>
</body>