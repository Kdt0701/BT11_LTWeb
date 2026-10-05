<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head><title>Giỏ hàng</title></head>
<body>
<div class="container py-4">
    <h2 class="fw-bold mb-4">Giỏ hàng</h2>
    <c:choose>
        <c:when test="${empty cart}">
            <div class="alert alert-info">Giỏ hàng đang trống.</div>
            <a href="<c:url value='/home'/>" class="btn btn-primary">Tiếp tục mua hàng</a>
        </c:when>
        <c:otherwise>
            <div class="table-responsive">
            <table class="table table-bordered align-middle bg-white">
                <thead><tr><th>Sản phẩm</th><th>Đơn giá</th><th style="width:190px">Số lượng</th><th>Thành tiền</th><th></th></tr></thead>
                <tbody>
                <c:set var="total" value="0"/>
                <c:forEach var="item" items="${cart}">
                    <c:set var="sub" value="${item.value.subTotal}"/>
                    <c:set var="total" value="${total + sub}"/>
                    <tr>
                        <td>
                            <div class="d-flex align-items-center gap-3">
                                <img src="${item.value.video.poster}" style="width:70px;height:90px;object-fit:cover;" class="rounded">
                                <strong>${item.value.video.title}</strong>
                            </div>
                        </td>
                        <td><fmt:formatNumber value="${item.value.video.price}" type="number"/> đ</td>
                        <td>
                            <form action="<c:url value='/cart/update'/>" method="post" class="d-flex gap-2">
                                <input type="hidden" name="id" value="${item.key}">
                                <input type="number" name="quantity" min="1" max="${item.value.video.stock}" value="${item.value.quantity}" class="form-control">
                                <button class="btn btn-outline-primary">Sửa</button>
                            </form>
                            <small class="text-muted">Tối đa: ${item.value.video.stock}</small>
                        </td>
                        <td class="fw-bold"><fmt:formatNumber value="${sub}" type="number"/> đ</td>
                        <td><form action="<c:url value='/cart/delete'/>" method="post">
                            <input type="hidden" name="id" value="${item.key}">
                            <button class="btn btn-outline-danger"><i class="fa-solid fa-trash"></i></button>
                        </form></td>
                    </tr>
                </c:forEach>
                </tbody>
                <tfoot><tr><th colspan="3" class="text-end">Tổng:</th><th class="text-danger fs-5"><fmt:formatNumber value="${total}" type="number"/> đ</th><th></th></tr></tfoot>
            </table>
            </div>
            <div class="d-flex justify-content-between">
                <a href="<c:url value='/home'/>" class="btn btn-secondary">Tiếp tục mua hàng</a>
                <a href="<c:url value='/checkout'/>" class="btn btn-danger">Thanh toán COD</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>