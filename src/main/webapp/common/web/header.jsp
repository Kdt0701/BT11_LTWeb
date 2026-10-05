<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top shadow">
    <div class="container">
        <a class="navbar-brand fw-bold text-uppercase" href="<c:url value='/home'/>">
            <i class="fa-solid fa-film text-danger me-2"></i>IoTStar Cinema
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link active" href="<c:url value='/home'/>">Trang Chủ</a></li>
                
                <li class="nav-item">
                    <a class="nav-link fw-bold" href="<c:url value='/video/category'/>">
                        <i class="fa-solid fa-layer-group"></i> SẢN PHẨM
                    </a>
                </li>
                
                <c:if test="${sessionScope.account.admin}">
                    <li class="nav-item"><a class="nav-link text-warning" href="<c:url value='/admin/home'/>">Quản trị</a></li>
                </c:if>
            </ul>

            <ul class="navbar-nav">
                <c:if test="${sessionScope.account == null}">
                    <li class="nav-item"><a class="btn btn-danger btn-sm rounded-pill px-4" href="<c:url value='/login'/>">Đăng nhập</a></li>
                </c:if>
                <c:if test="${sessionScope.account != null}">
                    <li class="nav-item">
                        <a class="nav-link position-relative" href="<c:url value='/cart'/>">
                            <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            Chào, ${sessionScope.account.fullname}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="<c:url value='/user/profile'/>">Hồ sơ</a></li>
                            <li><a class="dropdown-item" href="<c:url value='/orders'/>">Lịch sử đặt hàng</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="<c:url value='/logout'/>">Đăng xuất</a></li>
                        </ul>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>