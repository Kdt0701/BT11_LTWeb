package vn.iotstar.dao.impl;

import java.util.List;
import jakarta.persistence.*;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.OrderDAO_20133056;
import vn.iotstar.entity.Order;

public class OrderDAOImpl_20133056 implements OrderDAO_20133056 {
    @Override
    public void insert(Order order) {
        EntityManager em = JPAConfig.getEnityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(order);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally { em.close(); }
    }

    @Override
    public List<Order> findByUsername(String username, String status) {
        EntityManager em = JPAConfig.getEnityManager();
        try {
            String jpql = "SELECT DISTINCT o FROM Order o "
                    + "JOIN FETCH o.details d JOIN FETCH d.video "
                    + "WHERE o.user.username = :username "
                    + (blank(status) ? "" : "AND o.status = :status ")
                    + "ORDER BY o.orderDate DESC";
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
            String jpql = "SELECT DISTINCT o FROM Order o "
                    + "JOIN FETCH o.user JOIN FETCH o.details d JOIN FETCH d.video "
                    + (blank(status) ? "" : "WHERE o.status = :status ")
                    + "ORDER BY o.orderDate DESC";
            TypedQuery<Order> q = em.createQuery(jpql, Order.class);
            if (!blank(status)) q.setParameter("status", status);
            return q.getResultList();
        } finally { em.close(); }
    }

    @Override
    public Order findById(Long orderId) {
        EntityManager em = JPAConfig.getEnityManager();
        try {
            TypedQuery<Order> q = em.createQuery(
                    "SELECT DISTINCT o FROM Order o JOIN FETCH o.user "
                    + "JOIN FETCH o.details d JOIN FETCH d.video "
                    + "WHERE o.orderId = :id", Order.class);
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
            em.merge(order);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally { em.close(); }
    }

    private boolean blank(String value) {
        return value == null || value.isBlank();
    }
}
