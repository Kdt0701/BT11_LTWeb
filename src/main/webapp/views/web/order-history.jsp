<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head><title>Lịch sử đặt hàng</title></head>
<body>
<div class="container py-4">
<h2 class="fw-bold mb-3">Lịch sử đặt hàng</h2>
<c:if test="${param.success == '1'}"><div class="alert alert-success">Đặt hàng COD thành công.</div></c:if>
<div class="mb-4 d-flex flex-wrap gap-2">
<c:url var="allUrl" value="/orders"/><a href="${allUrl}" class="btn ${empty selectedStatus ? 'btn-dark' : 'btn-outline-dark'}">Tất cả</a>
<c:forEach var="st" items="${['Đơn hàng mới','Đã xác nhận','Chuẩn bị hàng','Vận chuyển','Giao hàng','Đã giao','Đơn hàng hủy','Đơn hàng hoàn']}">
<c:url var="statusUrl" value="/orders"><c:param name="status" value="${st}"/></c:url>
<a href="${statusUrl}" class="btn ${selectedStatus == st ? 'btn-dark' : 'btn-outline-dark'}">${st}</a>
</c:forEach>
</div>
<c:choose>
<c:when test="${empty orders}"><div class="alert alert-info">Không có đơn hàng ở trạng thái này.</div></c:when>
<c:otherwise>
<c:forEach var="o" items="${orders}">
<div class="card mb-3 shadow-sm">
<div class="card-header d-flex justify-content-between"><strong>#${o.orderId}</strong><span class="badge bg-primary">${o.status}</span></div>
<div class="card-body">
<c:forEach var="d" items="${o.details}">
<div class="d-flex justify-content-between border-bottom py-2"><span>${d.video.title} × ${d.quantity}</span><span><fmt:formatNumber value="${d.subTotal}" type="number"/> đ</span></div>
</c:forEach>
<div class="text-end mt-3"><strong>Tổng: <span class="text-danger"><fmt:formatNumber value="${o.totalAmount}" type="number"/> đ</span></strong></div>
<div class="small text-muted mt-2">COD · ${o.receiverName} · ${o.receiverPhone} · ${o.shippingAddress}</div>
</div></div>
</c:forEach>
</c:otherwise>
</c:choose>
</div>
</body>