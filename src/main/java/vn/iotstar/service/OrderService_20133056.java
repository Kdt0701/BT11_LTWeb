package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.Order;

public interface OrderService_20133056 {
    void create(Order order);
    List<Order> findByUsername(String username, String status);
    List<Order> findAll(String status);
    Order findById(Long orderId);
    void updateStatus(Long orderId, String status);
    void addDetail(Long orderId, String username, String videoId, int quantity);
    void updateDetail(Long orderId, String username, Long detailId, int quantity);
    void deleteDetail(Long orderId, String username, Long detailId);
    void cancelOrder(Long orderId, String username);
    void requestReturn(Long orderId, String username, String reason);
    void reviewReturn(Long orderId, boolean approve);
}
