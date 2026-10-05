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
}