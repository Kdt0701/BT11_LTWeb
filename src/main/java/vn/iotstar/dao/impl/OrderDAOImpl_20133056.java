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
            order.setStatus(status);
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
