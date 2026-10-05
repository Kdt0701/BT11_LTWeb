package vn.iotstar.dao.impl;

import java.math.BigDecimal;
import java.util.List;
import jakarta.persistence.*;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.OrderDAO_20133056;
import vn.iotstar.entity.Order;
import vn.iotstar.entity.OrderDetail;
import vn.iotstar.entity.Video;

public class OrderDAOImpl_20133056 implements OrderDAO_20133056 {
    @Override
    public void insert(Order order) {
        EntityManager em = JPAConfig.getEnityManager();
        EntityTransaction tx = em.getTransaction();
        try { tx.begin(); em.persist(order); tx.commit(); }
        catch (Exception e) { if (tx.isActive()) tx.rollback(); throw e; }
        finally { em.close(); }
    }

    @Override
    public List<Order> findByUsername(String username, String status) {
        EntityManager em = JPAConfig.getEnityManager();
        try {
            String jpql = "SELECT DISTINCT o FROM Order o JOIN FETCH o.details d JOIN FETCH d.video "
                    + "WHERE o.user.username = :username "
                    + (blank(status) ? "" : "AND o.status = :status ") + "ORDER BY o.orderDate DESC";
            TypedQuery<Order> q = em.createQuery(jpql, Order.class);
            q.setParameter("username", username);
            if (!blank(status)) q.setParameter("status", status);
            return q.getResultList();
        } finally { em.close(); }
    }

    @Override
    public List<Order> findAll(String status) {
        EntityManager em = JPAConfig.getEnityManager();
        try {
            String jpql = "SELECT DISTINCT o FROM Order o JOIN FETCH o.user JOIN FETCH o.details d JOIN FETCH d.video "
                    + (blank(status) ? "" : "WHERE o.status = :status ") + "ORDER BY o.orderDate DESC";
            TypedQuery<Order> q = em.createQuery(jpql, Order.class);
            if (!blank(status)) q.setParameter("status", status);
            return q.getResultList();
        } finally { em.close(); }
    }

    @Override
    public Order findById(Long orderId) {
        EntityManager em = JPAConfig.getEnityManager();
        try {
            TypedQuery<Order> q = em.createQuery("SELECT DISTINCT o FROM Order o JOIN FETCH o.user "
                    + "JOIN FETCH o.details d JOIN FETCH d.video WHERE o.orderId = :id", Order.class);
            q.setParameter("id", orderId);
            List<Order> result = q.getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally { em.close(); }
    }

    @Override
    public void updateStatus(Long orderId, String status) {
        EntityManager em = JPAConfig.getEnityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Order order = em.find(Order.class, orderId);
            if (order == null) throw new IllegalArgumentException("Không tìm thấy đơn hàng #" + orderId);
            if ("Đơn hàng hoàn".equals(status) && !"APPROVED".equals(order.getReturnStatus())) {
                throw new IllegalStateException("Chỉ được chuyển sang Đơn hàng hoàn sau khi Admin chấp nhận yêu cầu hoàn trả.");
            }
            if ("PENDING".equals(order.getReturnStatus()) && !"Đã giao".equals(status)) {
                throw new IllegalStateException("Yêu cầu hoàn trả đang chờ xử lý. Hãy chấp nhận hoặc từ chối yêu cầu trước.");
            }
            order.setStatus(status);
            if ("Đã giao".equals(status) && order.getDeliveredAt() == null) {
                order.setDeliveredAt(java.time.LocalDateTime.now());
            }
            tx.commit();
        } catch (Exception e) { if (tx.isActive()) tx.rollback(); throw e; }
        finally { em.close(); }
    }

    @Override
    public void addDetail(Long orderId, String username, String videoId, int quantity) {
        EntityManager em = JPAConfig.getEnityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            if (quantity < 1) throw new IllegalArgumentException("Số lượng phải lớn hơn 0.");
            tx.begin();
            Order order = findPendingOrder(em, orderId, username);
            Video video = em.find(Video.class, videoId);
            if (video == null || !video.isActive()) throw new IllegalArgumentException("Sản phẩm không tồn tại hoặc đã ngừng bán.");
            OrderDetail existing = null;
            for (OrderDetail d : order.getDetails()) if (d.getVideo().getVideoId().equals(videoId)) { existing = d; break; }
            int newQty = quantity + (existing == null ? 0 : existing.getQuantity());
            if (newQty > video.getStock()) throw new IllegalArgumentException("Số lượng vượt quá tồn kho hiện tại.");
            if (existing == null) {
                OrderDetail d = OrderDetail.builder().order(order).video(video).quantity(quantity).unitPrice(video.getPrice()).build();
                order.getDetails().add(d); em.persist(d);
            } else existing.setQuantity(newQty);
            video.setStock(video.getStock() - quantity);
            recalculate(order);
            tx.commit();
        } catch (Exception e) { if (tx.isActive()) tx.rollback(); throw e; }
        finally { em.close(); }
    }

    @Override
    public void updateDetail(Long orderId, String username, Long detailId, int quantity) {
        EntityManager em = JPAConfig.getEnityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Order order = findPendingOrder(em, orderId, username);
            OrderDetail detail = findDetail(order, detailId);
            if (quantity < 1) throw new IllegalArgumentException("Số lượng phải lớn hơn 0.");
            Video video = detail.getVideo();
            int delta = quantity - detail.getQuantity();
            if (delta > video.getStock()) throw new IllegalArgumentException("Số lượng vượt quá tồn kho hiện tại.");
            detail.setQuantity(quantity);
            video.setStock(video.getStock() - delta);
            recalculate(order);
            tx.commit();
        } catch (Exception e) { if (tx.isActive()) tx.rollback(); throw e; }
        finally { em.close(); }
    }

    @Override
    public void deleteDetail(Long orderId, String username, Long detailId) {
        EntityManager em = JPAConfig.getEnityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Order order = findPendingOrder(em, orderId, username);
            OrderDetail detail = findDetail(order, detailId);
            detail.getVideo().setStock(detail.getVideo().getStock() + detail.getQuantity());
            order.getDetails().remove(detail);
            em.remove(detail);
            if (order.getDetails().isEmpty()) {
                order.setTotalAmount(BigDecimal.ZERO);
            } else recalculate(order);
            tx.commit();
        } catch (Exception e) { if (tx.isActive()) tx.rollback(); throw e; }
        finally { em.close(); }
    }

    @Override
    public void cancelOrder(Long orderId, String username) {
        EntityManager em = JPAConfig.getEnityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Order order = findPendingOrder(em, orderId, username);
            for (OrderDetail d : order.getDetails()) d.getVideo().setStock(d.getVideo().getStock() + d.getQuantity());
            order.setStatus("Đơn hàng hủy");
            tx.commit();
        } catch (Exception e) { if (tx.isActive()) tx.rollback(); throw e; }
        finally { em.close(); }
    }

    @Override
    public void requestReturn(Long orderId, String username, String reason) {
        EntityManager em = JPAConfig.getEnityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            if (reason == null || reason.isBlank()) throw new IllegalArgumentException("Vui lòng nhập lý do hoàn trả.");
            reason = reason.trim();
            if (reason.length() > 1000) throw new IllegalArgumentException("Lý do hoàn trả tối đa 1000 ký tự.");
            tx.begin();
            TypedQuery<Order> q = em.createQuery("SELECT o FROM Order o WHERE o.orderId = :id AND o.user.username = :username", Order.class);
            q.setParameter("id", orderId); q.setParameter("username", username);
            List<Order> list = q.getResultList();
            if (list.isEmpty()) throw new IllegalArgumentException("Không tìm thấy đơn hàng hoặc bạn không có quyền thao tác.");
            Order order = list.get(0);
            if (!"Đã giao".equals(order.getStatus())) throw new IllegalStateException("Chỉ được yêu cầu hoàn trả khi đơn hàng đã giao.");
            if (order.getDeliveredAt() == null) throw new IllegalStateException("Đơn hàng chưa có thời điểm giao hàng để kiểm tra thời hạn hoàn trả.");
            if (order.getDeliveredAt().plusDays(7).isBefore(java.time.LocalDateTime.now())) throw new IllegalStateException("Đã quá thời hạn hoàn trả 7 ngày kể từ khi giao hàng.");
            if ("PENDING".equals(order.getReturnStatus())) throw new IllegalStateException("Yêu cầu hoàn trả đang chờ Admin xem xét.");
            if ("APPROVED".equals(order.getReturnStatus())) throw new IllegalStateException("Đơn hàng đã được chấp nhận hoàn trả.");
            order.setReturnReason(reason);
            order.setReturnRequestedAt(java.time.LocalDateTime.now());
            order.setReturnStatus("PENDING");
            tx.commit();
        } catch (Exception e) { if (tx.isActive()) tx.rollback(); throw e; }
        finally { em.close(); }
    }

    @Override
    public void reviewReturn(Long orderId, boolean approve) {
        EntityManager em = JPAConfig.getEnityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Order order = em.find(Order.class, orderId);
            if (order == null) throw new IllegalArgumentException("Không tìm thấy đơn hàng #" + orderId);
            if (!"PENDING".equals(order.getReturnStatus())) throw new IllegalStateException("Đơn hàng không có yêu cầu hoàn trả đang chờ xử lý.");
            if (approve) {
                order.setReturnStatus("APPROVED");
                order.setStatus("Đơn hàng hoàn");
            } else {
                order.setReturnStatus("REJECTED");
            }
            tx.commit();
        } catch (Exception e) { if (tx.isActive()) tx.rollback(); throw e; }
        finally { em.close(); }
    }

    private Order findPendingOrder(EntityManager em, Long orderId, String username) {
        TypedQuery<Order> q = em.createQuery("SELECT DISTINCT o FROM Order o LEFT JOIN FETCH o.details d LEFT JOIN FETCH d.video "
                + "WHERE o.orderId = :id AND o.user.username = :username", Order.class);
        q.setParameter("id", orderId); q.setParameter("username", username);
        List<Order> list = q.getResultList();
        if (list.isEmpty()) throw new IllegalArgumentException("Không tìm thấy đơn hàng hoặc bạn không có quyền thao tác.");
        Order order = list.get(0);
        if (!"Đơn hàng mới".equals(order.getStatus())) throw new IllegalStateException("Chỉ được chỉnh sửa/hủy khi đơn hàng chưa được Admin xác nhận.");
        return order;
    }

    private OrderDetail findDetail(Order order, Long detailId) {
        for (OrderDetail d : order.getDetails()) if (d.getOrderDetailId().equals(detailId)) return d;
        throw new IllegalArgumentException("Không tìm thấy sản phẩm trong đơn hàng.");
    }

    private void recalculate(Order order) {
        BigDecimal total = BigDecimal.ZERO;
        for (OrderDetail d : order.getDetails()) total = total.add(d.getSubTotal());
        order.setTotalAmount(total);
    }

    private boolean blank(String value) { return value == null || value.isBlank(); }
}
