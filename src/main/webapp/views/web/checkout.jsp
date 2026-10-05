<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head><title>Thanh toán COD</title></head>
<body>
<div class="container py-4">
<h2 class="fw-bold mb-4">Thanh toán đơn hàng</h2>
<c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
<div class="row g-4">
<div class="col-md-7">
<form action="<c:url value='/checkout'/>" method="post" class="card card-body shadow-sm">
<h5>Thông tin nhận hàng</h5>
<label class="form-label mt-2">Họ tên</label>
<input name="receiverName" class="form-control" value="${sessionScope.account.fullname}" required>
<label class="form-label mt-2">Số điện thoại</label>
<input name="receiverPhone" class="form-control" value="${sessionScope.account.phone}" required>
<label class="form-label mt-2">Địa chỉ giao hàng</label>
<textarea name="shippingAddress" class="form-control" rows="4" required></textarea>
<label class="form-label mt-3">Phương thức thanh toán</label>
<input class="form-control" value="COD - Thanh toán khi nhận hàng" disabled>
<button class="btn btn-danger mt-4" type="submit">Đặt hàng</button>
</form>
</div>
<div class="col-md-5">
<div class="card card-body shadow-sm">
<h5>Đơn hàng</h5>
<c:set var="total" value="0"/>
<c:forEach var="item" items="${cart}">
<c:set var="sub" value="${item.value.subTotal}"/><c:set var="total" value="${total + sub}"/>
<div class="d-flex justify-content-between border-bottom py-2"><span>${item.value.video.title} × ${item.value.quantity}</span><strong><fmt:formatNumber value="${sub}" type="number"/> đ</strong></div>
</c:forEach>
<div class="d-flex justify-content-between pt-3"><strong>Tổng cộng</strong><strong class="text-danger"><fmt:formatNumber value="${total}" type="number"/> đ</strong></div>
</div>
</div>
</div>
</div>
</body>