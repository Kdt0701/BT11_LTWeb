<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Trang chủ - IoTStar Cinema</title>
    <style>
        /* CSS riêng cho trang Home */
        .hero-banner {
            position: relative;
            background-size: cover;
            background-position: center;
            height: 500px;
            display: flex;
            align-items: center;
            color: white;
            margin-bottom: 2rem;
        }
        /* Lớp phủ đen mờ để chữ rõ hơn */
        .hero-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to right, rgba(0,0,0,0.9), rgba(0,0,0,0.3));
        }
        .hero-content {
            position: relative;
            z-index: 2;
            max-width: 600px;
        }
        
        /* Card phim */
        .movie-card {
            transition: all 0.3s ease;
            border: none;
            background: transparent;
        }
        .movie-card:hover {
            transform: scale(1.05);
            z-index: 10;
        }
        .poster-wrapper {
            position: relative;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .play-btn {
            position: absolute;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            opacity: 0;
            transition: 0.3s;
        }
        .movie-card:hover .play-btn { opacity: 1; }
        .movie-card:hover .poster-wrapper { box-shadow: 0 8px 25px rgba(0,0,0,0.4); }
    </style>
</head>

<body>

    <c:if test="${not empty featuredVideo}">
        <div class="hero-banner" 
             style="background-image: url('<c:choose>
                    <c:when test="${featuredVideo.poster.startsWith('http')}">${featuredVideo.poster}</c:when>
                    <c:otherwise><c:url value='/upload/video/${featuredVideo.poster}'/></c:otherwise>
                </c:choose>');">
            <div class="hero-overlay"></div>
            <div class="container">
                <div class="hero-content">
                    <span class="badge bg-danger mb-2">PHIM HOT</span>
                    <h1 class="display-4 fw-bold text-uppercase">${featuredVideo.title}</h1>
                    <p class="lead text-white-50" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                        ${featuredVideo.description}
                    </p>
                    <a href="<c:url value='/video/detail?id=${featuredVideo.videoId}'/>" class="btn btn-danger btn-lg rounded-pill px-4">
                        <i class="fa-solid fa-play me-2"></i> Xem Ngay
                    </a>
                </div>
            </div>
        </div>
    </c:if>

    <div class="container pb-5">
        <h3 class="fw-bold mb-4 border-start border-4 border-danger ps-3">Phim Mới Cập Nhật</h3>
        
        <div class="row row-cols-2 row-cols-md-4 row-cols-lg-5 g-4">
            <c:forEach items="${listVideo}" var="v">
                <div class="col">
                    <div class="movie-card">
                        <a href="<c:url value='/video/detail?id=${v.videoId}'/>" class="text-decoration-none">
                            <div class="poster-wrapper mb-2">
                                <c:choose>
                                    <c:when test="${not empty v.poster && v.poster.startsWith('http')}">
                                        <img src="${v.poster}" class="w-100" style="aspect-ratio: 2/3; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="<c:url value='/upload/video/${v.poster}'/>" class="w-100" style="aspect-ratio: 2/3; object-fit: cover;">
                                    </c:otherwise>
                                </c:choose>
                                <div class="play-btn">
                                    <i class="fa-regular fa-circle-play fa-3x text-white"></i>
                                </div>
                            </div>
                            
                            <h6 class="text-dark fw-bold text-truncate mb-1" title="${v.title}">${v.title}</h6>
                            <div class="d-flex justify-content-between small text-muted">
                                <span>${v.category.categoryName}</span>
                                <span><i class="fa-solid fa-eye"></i> ${v.views}</span>
                            </div>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

</body>