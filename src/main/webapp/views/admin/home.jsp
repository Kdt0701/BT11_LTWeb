<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <title>Trang chủ Admin</title>
</head>
<body>
    <div class="container-fluid">
        <h1 class="h3 mb-4 text-gray-800">Chào mừng, ${sessionScope.account.fullname}</h1>
        
        <div class="row">
            <div class="col-xl-4 col-md-6 mb-4">
                <div class="card border-left-primary shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Thông tin cá nhân</div>
                                <a href="<c:url value='/admin/profile'/>" class="btn btn-sm btn-primary mt-2">Cập nhật ngay</a>
                            </div>
                            <div class="col-auto">
                                <i class="fa-solid fa-user fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-4 col-md-6 mb-4">
                <div class="card border-left-success shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Quản lý Video</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">CRUD Video</div>
                                <a href="<c:url value='/admin/video/list'/>" class="btn btn-sm btn-success mt-2">Truy cập</a>
                            </div>
                            <div class="col-auto">
                                <i class="fa-solid fa-video fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-4 col-md-6 mb-4">
                <div class="card border-left-info shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Quản lý Danh mục</div>
                                <a href="<c:url value='/admin/category/list'/>" class="btn btn-sm btn-info mt-2">Truy cập</a>
                            </div>
                            <div class="col-auto">
                                <i class="fa-solid fa-list fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>