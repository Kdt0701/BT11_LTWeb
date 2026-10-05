package vn.iotstar.service.impl;

import java.util.List;
import vn.iotstar.dao.OrderDAO_20133056;
import vn.iotstar.dao.impl.OrderDAOImpl_20133056;
import vn.iotstar.entity.Order;
import vn.iotstar.service.OrderService_20133056;

public class OrderServiceImpl_20133056 implements OrderService_20133056 {
    private final OrderDAO_20133056 dao = new OrderDAOImpl_20133056();
    public void create(Order order) { dao.insert(order); }
    public List<Order> findByUsername(String username, String status) { return dao.findByUsername(username, status); }
    public List<Order> findAll(String status) { return dao.findAll(status); }
    public Order findById(Long orderId) { return dao.findById(orderId); }
    public void updateStatus(Long orderId, String status) { dao.updateStatus(orderId, status); }
    public void addDetail(Long orderId, String username, String videoId, int quantity) { dao.addDetail(orderId, username, videoId, quantity); }
    public void updateDetail(Long orderId, String username, Long detailId, int quantity) { dao.updateDetail(orderId, username, detailId, quantity); }
    public void deleteDetail(Long orderId, String username, Long detailId) { dao.deleteDetail(orderId, username, detailId); }
    public void cancelOrder(Long orderId, String username) { dao.cancelOrder(orderId, username); }
}
