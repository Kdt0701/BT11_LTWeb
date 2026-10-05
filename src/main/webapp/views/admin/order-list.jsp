<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head><title>Quản lý đơn hàng</title></head>
<body>
<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h2 class="fw-bold mb-1">Quản lý đơn hàng</h2>
            <p class="text-muted mb-0">Admin xem tất cả đơn và duyệt/cập nhật trạng thái.</p>
        </div>
        <span class="badge bg-warning text-dark fs-6">COD</span>
    </div>

    <c:if test="${param.error == '1'}"><div class="alert alert-danger">Không thể cập nhật trạng thái đơn hàng.</div></c:if>

    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <div class="d-flex flex-wrap gap-2">
                <a href="<c:url value='/admin/orders'/>" class="btn ${empty selectedStatus ? 'btn-dark' : 'btn-outline-dark'}">Tất cả</a>
                <c:forEach var="st" items="${statuses}">
                    <c:url var="filterUrl" value="/admin/orders"><c:param name="status" value="${st}"/></c:url>
                    <a href="${filterUrl}" class="btn ${selectedStatus == st ? 'btn-primary' : 'btn-outline-primary'}">${st}</a>
                </c:forEach>
            </div>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="alert alert-info">Không có đơn hàng ở trạng thái này.</div>
        </c:when>
        <c:otherwise>
            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th>Mã đơn</th><th>Khách hàng</th><th>Ngày đặt</th>
                                <th>Thanh toán</th><th>Tổng tiền</th><th>Trạng thái</th><th></th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="o" items="${orders}">
                            <tr>
                                <td class="fw-bold">#${o.orderId}</td>
                                <td>${o.user.fullname}<br><small class="text-muted">${o.user.username}</small></td>
                                <td>${o.orderDate}</td>
                                <td>${o.paymentMethod}</td>
                                <td class="text-danger fw-bold"><fmt:formatNumber value="${o.totalAmount}" type="number"/> đ</td>
                                <td><span class="badge bg-primary">${o.status}</span></td>
                                <td><a class="btn btn-sm btn-outline-primary" href="<c:url value='/admin/orders/detail?id=${o.orderId}'/>">Xem / duyệt</a></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
