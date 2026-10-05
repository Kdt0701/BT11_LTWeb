<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top shadow">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold text-uppercase" href="<c:url value='/admin/home'/>">
            <i class="fa-solid fa-user-shield text-warning me-2"></i>IoTStar Admin
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="adminNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/home'/>">
                        <i class="fa-solid fa-house"></i> Trang Chủ
                    </a>
                </li>
                
                <li class="nav-item">
				    <a class="nav-link fw-bold" href="<c:url value='/video/category'/>">
				        <i class="fa-solid fa-layer-group"></i> SẢN PHẨM
				    </a>
				</li>
                
                <li class="nav-item">
                    <a class="nav-link text-warning active" href="<c:url value='/admin/home'/>">
                        <i class="fa-solid fa-gauge"></i> Dashboard
                    </a>
                </li>
            </ul>

            <ul class="navbar-nav">
                <c:if test="${sessionScope.account != null}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                            <c:if test="${not empty sessionScope.account.images}">
                                <img src="<c:url value='/upload/user/${sessionScope.account.images}'/>" 
                                     class="rounded-circle me-2" style="width: 30px; height: 30px; object-fit: cover;">
                            </c:if>
                            <span class="text-light">Chào, ${sessionScope.account.fullname}</span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end dropdown-menu-dark shadow">
                            <li><a class="dropdown-item" href="<c:url value='/admin/profile'/>"><i class="fa-solid fa-id-card me-2"></i>Hồ sơ</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="<c:url value='/logout'/>"><i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất</a></li>
                        </ul>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

<div style="height: 60px;"></div>