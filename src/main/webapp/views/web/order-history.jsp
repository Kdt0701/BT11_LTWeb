<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head><title>Lịch sử đặt hàng</title></head>
<body>
<div class="container py-4">
<h2 class="fw-bold mb-3">Lịch sử đặt hàng</h2>
<c:if test="${param.success == '1'}"><div class="alert alert-success">Đặt hàng COD thành công.</div></c:if>
<c:if test="${param.cancelled == '1'}"><div class="alert alert-success">Đã hủy đơn hàng. Đơn được chuyển thẳng sang trạng thái Đơn hàng hủy.</div></c:if>
<c:if test="${param.error == 'locked'}"><div class="alert alert-warning">Đơn hàng đã được Admin xác nhận nên không thể chỉnh sửa hoặc hủy.</div></c:if>
<c:if test="${param.returnRequested == '1'}"><div class="alert alert-success">Đã gửi yêu cầu hoàn trả. Admin sẽ xem xét lý do và quyết định.</div></c:if>
<c:if test="${not empty param.returnError}"><div class="alert alert-warning">${param.returnError}</div></c:if>
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
<div class="mt-3 d-flex justify-content-end gap-2">
<c:if test="${o.status == 'Đơn hàng mới'}"><a href="<c:url value='/orders/edit'><c:param name='id' value='${o.orderId}'/></c:url>" class="btn btn-primary btn-sm">Chỉnh sửa / Hủy đơn</a></c:if>
<c:if test="${o.status == 'Đã giao'}">
    <c:choose>
        <c:when test="${o.returnStatus == 'PENDING'}"><span class="btn btn-outline-warning btn-sm disabled">Đang chờ Admin xử lý hoàn trả</span></c:when>
        <c:when test="${o.returnStatus == 'REJECTED'}"><span class="btn btn-outline-secondary btn-sm disabled">Yêu cầu hoàn trả đã bị từ chối</span></c:when>
        <c:when test="${o.returnStatus == 'APPROVED'}"><span class="btn btn-outline-success btn-sm disabled">Đã chấp nhận hoàn trả</span></c:when>
        <c:otherwise>
            <button type="button" class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#returnModal${o.orderId}">Yêu cầu hoàn trả</button>
        </c:otherwise>
    </c:choose>
</c:if>
</div>
<c:if test="${o.status == 'Đã giao' && (empty o.returnStatus || o.returnStatus == 'NONE')}">
<div class="small text-muted mt-2">Thời hạn hoàn trả: tối đa 7 ngày kể từ ngày giao hàng.</div>
<div class="modal fade" id="returnModal${o.orderId}" tabindex="-1">
  <div class="modal-dialog"><div class="modal-content">
    <form method="post" action="<c:url value='/orders/return'/>">
      <div class="modal-header"><h5 class="modal-title">Yêu cầu hoàn trả #${o.orderId}</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <div class="modal-body">
        <input type="hidden" name="id" value="${o.orderId}">
        <label class="form-label">Lý do hoàn trả <span class="text-danger">*</span></label>
        <textarea name="reason" class="form-control" rows="4" maxlength="1000" required placeholder="Nhập lý do để Admin xem xét..."></textarea>
        <div class="small text-muted mt-2">Yêu cầu chỉ được gửi trong vòng tối đa 7 ngày sau khi đơn được giao.</div>
      </div>
      <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button><button type="submit" class="btn btn-warning">Gửi yêu cầu</button></div>
    </form>
  </div></div>
</div>
</c:if>
<div class="small text-muted mt-2">COD · ${o.receiverName} · ${o.receiverPhone} · ${o.shippingAddress}</div>
</div></div>
</c:forEach>
</c:otherwise>
</c:choose>
</div>
</body>