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
            String jpql = "SELECT DISTINCT o FROM Order o JOIN FETCH o.details d JOIN FETCH d.video " +
                    "WHERE o.user.username = :username " +
                    (status == null || status.isBlank() ? "" : "AND o.status = :status ") +
                    "ORDER BY o.orderDate DESC";
            TypedQuery<Order> q = em.createQuery(jpql, Order.class);
            q.setParameter("username", username);
            if (status != null && !status.isBlank()) q.setParameter("status", status);
            return q.getResultList();
        } finally { em.close(); }
    }
}