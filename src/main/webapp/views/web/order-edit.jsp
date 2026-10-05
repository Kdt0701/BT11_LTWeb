<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head><title>Chỉnh sửa đơn hàng #${order.orderId}</title></head>
<body>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div><h2 class="fw-bold mb-1">Chỉnh sửa đơn hàng #${order.orderId}</h2><div class="text-muted">Chỉ được thao tác khi đơn đang ở trạng thái <strong>Đơn hàng mới</strong>.</div></div>
        <a href="<c:url value='/orders'/>" class="btn btn-outline-secondary">Quay lại lịch sử</a>
    </div>

    <c:if test="${param.updated == '1'}"><div class="alert alert-success">Đã cập nhật đơn hàng.</div></c:if>
    <c:if test="${not empty param.error}"><div class="alert alert-danger">${param.error}</div></c:if>

    <div class="card shadow-sm mb-4">
        <div class="card-header fw-bold">Thêm sản phẩm vào đơn</div>
        <div class="card-body">
            <form method="post" action="<c:url value='/orders/edit/add'/>" class="row g-2 align-items-end">
                <input type="hidden" name="id" value="${order.orderId}">
                <div class="col-md-7"><label class="form-label">Sản phẩm</label><select class="form-select" name="videoId" required><c:forEach var="v" items="${videos}"><c:if test="${v.active && v.stock > 0}"><option value="${v.videoId}">${v.title} — <fmt:formatNumber value="${v.price}" type="number"/> đ (còn ${v.stock})</option></c:if></c:forEach></select></div>
                <div class="col-md-3"><label class="form-label">Số lượng</label><input class="form-control" type="number" name="quantity" value="1" min="1" required></div>
                <div class="col-md-2"><button class="btn btn-primary w-100" type="submit">Thêm</button></div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header fw-bold">Sản phẩm trong đơn</div>
        <div class="card-body p-0">
            <c:choose><c:when test="${empty order.details}"><div class="p-4 text-muted">Đơn chưa có sản phẩm. Hãy thêm sản phẩm ở trên.</div></c:when><c:otherwise>
            <div class="table-responsive"><table class="table align-middle mb-0"><thead><tr><th>Sản phẩm</th><th>Đơn giá</th><th style="width:220px">Số lượng</th><th>Thành tiền</th><th></th></tr></thead><tbody>
            <c:forEach var="d" items="${order.details}"><tr>
                <td>${d.video.title}</td><td><fmt:formatNumber value="${d.unitPrice}" type="number"/> đ</td>
                <td><form method="post" action="<c:url value='/orders/edit/update'/>" class="d-flex gap-2"><input type="hidden" name="id" value="${order.orderId}"><input type="hidden" name="detailId" value="${d.orderDetailId}"><input class="form-control" type="number" name="quantity" value="${d.quantity}" min="1" required><button class="btn btn-outline-primary" type="submit">Sửa</button></form></td>
                <td><fmt:formatNumber value="${d.subTotal}" type="number"/> đ</td>
                <td><form method="post" action="<c:url value='/orders/edit/delete'/>" onsubmit="return confirm('Xóa sản phẩm này khỏi đơn?');"><input type="hidden" name="id" value="${order.orderId}"><input type="hidden" name="detailId" value="${d.orderDetailId}"><button class="btn btn-outline-danger" type="submit">Xóa</button></form></td>
            </tr></c:forEach>
            </tbody></table></div>
            </c:otherwise></c:choose>
            <div class="p-3 text-end border-top"><strong>Tổng: <span class="text-danger"><fmt:formatNumber value="${order.totalAmount}" type="number"/> đ</span></strong></div>
        </div>
    </div>

    <div class="mt-3 d-flex justify-content-between align-items-center">
        <span class="text-muted">Hủy đơn sẽ hoàn lại số lượng sản phẩm về tồn kho và chuyển thẳng sang <strong>Đơn hàng hủy</strong>.</span>
        <form method="post" action="<c:url value='/orders/cancel'/>" onsubmit="return confirm('Bạn chắc chắn muốn hủy đơn hàng này?');"><input type="hidden" name="id" value="${order.orderId}"><button class="btn btn-danger" type="submit">Hủy đơn hàng</button></form>
    </div>
</div>
</body>
