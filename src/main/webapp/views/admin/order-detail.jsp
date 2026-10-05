<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head><title>Chi tiết đơn hàng</title></head>
<body>
<div class="container-fluid">
    <a href="<c:url value='/admin/orders'/>" class="btn btn-secondary mb-3"><i class="fa-solid fa-arrow-left"></i> Danh sách đơn</a>

    <c:choose>
        <c:when test="${empty order}">
            <div class="alert alert-danger">Không tìm thấy đơn hàng.</div>
        </c:when>
        <c:otherwise>
            <c:if test="${param.updated == '1'}"><div class="alert alert-success">Đã cập nhật trạng thái đơn hàng.</div></c:if>
            <c:if test="${param.returnReviewed == '1'}"><div class="alert alert-success">Đã xử lý yêu cầu hoàn trả.</div></c:if>
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="card shadow-sm">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h4 class="mb-0">Đơn hàng #${order.orderId}</h4>
                            <span class="badge bg-primary fs-6">${order.status}</span>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table align-middle">
                                    <thead><tr><th>Sản phẩm</th><th>Đơn giá</th><th>SL</th><th>Thành tiền</th></tr></thead>
                                    <tbody>
                                    <c:forEach var="d" items="${order.details}">
                                        <tr>
                                            <td>${d.video.title}<br><small class="text-muted">${d.video.videoId}</small></td>
                                            <td><fmt:formatNumber value="${d.unitPrice}" type="number"/> đ</td>
                                            <td>${d.quantity}</td>
                                            <td class="fw-bold"><fmt:formatNumber value="${d.subTotal}" type="number"/> đ</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                    <tfoot><tr><th colspan="3" class="text-end">Tổng:</th><th class="text-danger"><fmt:formatNumber value="${order.totalAmount}" type="number"/> đ</th></tr></tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card shadow-sm mb-3">
                        <div class="card-header fw-bold">Thông tin khách hàng</div>
                        <div class="card-body">
                            <p><strong>Tài khoản:</strong> ${order.user.username}</p>
                            <p><strong>Họ tên:</strong> ${order.receiverName}</p>
                            <p><strong>SĐT:</strong> ${order.receiverPhone}</p>
                            <p><strong>Địa chỉ:</strong> ${order.shippingAddress}</p>
                            <p><strong>Thanh toán:</strong> ${order.paymentMethod}</p>
                            <p class="mb-0"><strong>Ngày đặt:</strong> ${order.orderDate}</p>
                        </div>
                    </div>

                    <c:if test="${order.returnStatus == 'PENDING'}">
                    <div class="card shadow-sm mb-3 border-warning">
                        <div class="card-header fw-bold bg-warning-subtle">Yêu cầu hoàn trả đang chờ xử lý</div>
                        <div class="card-body">
                            <p><strong>Thời gian yêu cầu:</strong> ${order.returnRequestedAt}</p>
                            <div class="alert alert-light border"><strong>Lý do User:</strong><br>${order.returnReason}</div>
                            <div class="d-flex gap-2">
                                <form method="post" action="<c:url value='/admin/orders/return'/>">
                                    <input type="hidden" name="id" value="${order.orderId}"><input type="hidden" name="decision" value="approve">
                                    <button type="submit" class="btn btn-success">Chấp nhận hoàn</button>
                                </form>
                                <form method="post" action="<c:url value='/admin/orders/return'/>">
                                    <input type="hidden" name="id" value="${order.orderId}"><input type="hidden" name="decision" value="reject">
                                    <button type="submit" class="btn btn-outline-danger">Từ chối hoàn</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    </c:if>
                    <c:if test="${order.returnStatus == 'REJECTED'}"><div class="alert alert-secondary"><strong>Hoàn trả:</strong> Admin đã từ chối yêu cầu. Lý do User: ${order.returnReason}</div></c:if>
                    <c:if test="${order.returnStatus == 'APPROVED'}"><div class="alert alert-success"><strong>Hoàn trả:</strong> Đã được Admin chấp nhận.</div></c:if>

                    <div class="card shadow-sm">
                        <div class="card-header fw-bold">Duyệt / cập nhật trạng thái</div>
                        <div class="card-body">
                            <form method="post" action="<c:url value='/admin/orders/status'/>">
                                <input type="hidden" name="id" value="${order.orderId}">
                                <label class="form-label">Trạng thái đơn hàng</label>
                                <select name="status" class="form-select mb-3">
                                    <c:forEach var="st" items="${statuses}">
                                        <option value="${st}" ${order.status == st ? 'selected' : ''}>${st}</option>
                                    </c:forEach>
                                </select>
                                <button type="submit" class="btn btn-success w-100"><i class="fa-solid fa-check"></i> Cập nhật trạng thái</button>
                            </form>
                            <div class="alert alert-light border mt-3 mb-0 small">
                                <strong>Quy trình:</strong> User đặt COD → <b>Đơn hàng mới</b> → Admin duyệt → các trạng thái giao hàng tiếp theo.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
