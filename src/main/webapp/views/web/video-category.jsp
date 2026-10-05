<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<head>
    <title>Sản phẩm</title>
</head>

<body>
    <div class="container mt-4 mb-5">
        
        <c:if test="${isAll}">
            <h2 class="text-center text-uppercase fw-bold mb-5 border-bottom pb-3">
                <i class="fa-solid fa-film text-danger"></i> Tất cả sản phẩm
            </h2>
        </c:if>
        <c:if test="${!isAll}">
            <h2 class="text-uppercase fw-bold mb-4">
                Danh mục: ${cateName}
            </h2>
        </c:if>

        <c:forEach items="${allCategories}" var="cate">
            
            <c:if test="${not empty cate.videos}">
                <div class="category-section mb-5">
                    <div class="d-flex align-items-center mb-3 p-2 bg-light border-start border-4 border-primary shadow-sm rounded">
                        <h4 class="mb-0 text-primary fw-bold me-3">
                            ${cate.categoryName}
                        </h4>
                        <span class="badge bg-secondary rounded-pill">${cate.videos.size()} Video</span>
                        <c:if test="${isAll}">
                            <a href="<c:url value='/video/category?id=${cate.categoryId}'/>" class="ms-auto btn btn-sm btn-outline-primary">
                                Xem riêng mục này <i class="fa-solid fa-arrow-right"></i>
                            </a>
                        </c:if>
                    </div>

                    <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4">
                        <c:forEach items="${cate.videos}" var="v">
                            <div class="col">
                                <div class="card h-100 shadow-sm border-0 video-card">
                                    <div style="position: relative; overflow: hidden;">
                                        <a href="<c:url value='/video/detail?id=${v.videoId}'/>">
                                            <c:choose>
                                                <c:when test="${not empty v.poster && v.poster.startsWith('http')}">
                                                    <img src="${v.poster}" class="card-img-top rounded" alt="${v.title}" style="aspect-ratio: 2/3; object-fit: cover;">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="<c:url value='/upload/video/${v.poster}'/>" class="card-img-top rounded" alt="${v.title}" style="aspect-ratio: 2/3; object-fit: cover;">
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            <div class="play-overlay d-flex align-items-center justify-content-center position-absolute top-0 start-0 w-100 h-100" 
                                                 style="background: rgba(0,0,0,0.4); opacity: 0; transition: 0.3s;">
                                                <i class="fa-regular fa-circle-play text-white fa-3x"></i>
                                            </div>
                                        </a>
                                    </div>

                                    <div class="card-body p-3">
                                        <h6 class="card-title fw-bold text-primary mb-2 text-truncate" title="${v.title}">
                                            <a href="<c:url value='/video/detail?id=${v.videoId}'/>" class="text-decoration-none">
                                                ${v.title}
                                            </a>
                                        </h6>

                                        <ul class="list-unstyled small text-muted mb-0">
                                            <li class="mb-1">
                                                <strong>Mã video:</strong> <span class="text-dark">${v.videoId}</span>
                                            </li>
                                            <li class="mb-1">
                                                <strong>Category:</strong> <span class="badge bg-info text-dark">${v.category.categoryName}</span>
                                            </li>
                                            <li class="mb-1">
                                                <strong>View:</strong> ${v.views} <i class="fa-solid fa-eye"></i>
                                            </li>
                                            
                                            <li class="d-flex gap-3 mt-2 pt-2 border-top">
                                                <span class="text-primary" title="Lượt chia sẻ">
                                                    <i class="fa-solid fa-share"></i> Share(${v.shares.size()})
                                                </span>
                                                <span class="text-danger" title="Lượt thích">
                                                    <i class="fa-solid fa-thumbs-up"></i> Like(${v.favorites.size()})
                                                </span>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </c:forEach>
        
        <c:if test="${empty allCategories}">
            <div class="alert alert-info text-center">Chưa có danh mục hoặc video nào.</div>
        </c:if>
    </div>

    <style>
        .video-card:hover { transform: translateY(-5px); transition: 0.3s; }
        .video-card:hover .play-overlay { opacity: 1 !important; }
        .video-card { transition: all 0.3s ease-in-out; }
    </style>
</body>