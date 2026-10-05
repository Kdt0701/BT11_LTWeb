<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Quản lý Video</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
        <h2>Danh sách Video</h2>
        
        <div class="d-flex gap-2">
            <form action="<c:url value='/admin/video/list'/>" method="get" class="d-flex">
                <input class="form-control me-2" type="search" name="keyword" 
                       placeholder="Tìm theo tiêu đề..." value="${keyword}" aria-label="Search">
                <button class="btn btn-outline-primary" type="submit">
                    <i class="fa-solid fa-magnifying-glass"></i> Tìm
                </button>
            </form>

            <a href="<c:url value='/admin/video/add'/>" class="btn btn-success text-nowrap">
                <i class="fa-solid fa-plus"></i> Thêm mới
            </a>
        </div>
    </div>

    <table class="table table-bordered table-hover shadow bg-white">
        <thead class="table-dark">
            <tr>
                <th>Poster</th>
                <th>Tiêu đề</th>
                <th>Lượt xem</th>
                <th>Trạng thái</th>
                <th>Danh mục</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${videos}" var="v">
                <tr>
                    <td>
                        <c:if test="${not empty v.poster}">
                            <img src="<c:url value='/upload/video/${v.poster}'/>" width="100" class="rounded">
                        </c:if>
                    </td>
                    <td>${v.title}</td>
                    <td>${v.views}</td>
                    <td>
                        <span class="badge ${v.active ? 'bg-success' : 'bg-secondary'}">
                            ${v.active ? 'Hoạt động' : 'Khóa'}
                        </span>
                    </td>
                    <td>${v.category.categoryName}</td>
                    <td>
                        <a href="<c:url value='/admin/video/edit?id=${v.videoId}'/>" class="btn btn-primary btn-sm">Sửa</a>
                        <a href="<c:url value='/admin/video/delete?id=${v.videoId}'/>" class="btn btn-danger btn-sm" onclick="return confirm('Xóa video này?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <div class="d-flex justify-content-center mt-4">
        <nav aria-label="Page navigation">
            <ul class="pagination shadow-sm">
                
                <c:if test="${tag > 1}">
                    <li class="page-item">
                        <a class="page-link" href="<c:url value='/admin/video/list?index=${tag-1}'/>" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                </c:if>

                <c:forEach begin="1" end="${endPage}" var="i">
                    <li class="page-item ${tag == i ? 'active' : ''}">
                        <a class="page-link" href="<c:url value='/admin/video/list?index=${i}'/>">${i}</a>
                    </li>
                </c:forEach>

                <c:if test="${tag < endPage}">
                    <li class="page-item">
                        <a class="page-link" href="<c:url value='/admin/video/list?index=${tag+1}'/>" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </div>
</body>