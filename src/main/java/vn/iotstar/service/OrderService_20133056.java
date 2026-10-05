package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.Order;

public interface OrderService_20133056 {
    void create(Order order);
    List<Order> findByUsername(String username, String status);
    List<Order> findAll(String status);
    Order findById(Long orderId);
    void updateStatus(Long orderId, String status);
}
