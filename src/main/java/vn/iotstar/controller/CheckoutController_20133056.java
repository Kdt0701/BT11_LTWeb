package vn.iotstar.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.entity.*;
import vn.iotstar.service.*;
import vn.iotstar.service.impl.*;

@WebServlet("/checkout")
public class CheckoutController_20133056 extends HttpServlet {
    private final VideoService_20133056 videoService = new VideoServiceImpl_20133056();
    private final OrderService_20133056 orderService = new OrderServiceImpl_20133056();

    @SuppressWarnings("unchecked")
    private Map<String, CartItem> cart(HttpSession s) {
        return (Map<String, CartItem>) s.getAttribute("cart");
    }

    private boolean loggedIn(HttpSession s) { return s != null && s.getAttribute("account") != null; }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (!loggedIn(s)) { resp.sendRedirect(req.getContextPath()+"/login"); return; }
        Map<String, CartItem> cart = cart(s);
        if (cart == null || cart.isEmpty()) { resp.sendRedirect(req.getContextPath()+"/cart"); return; }
        req.setAttribute("cart", cart);
        req.getRequestDispatcher("/views/web/checkout.jsp").forward(req, resp);
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession s = req.getSession(false);
        if (!loggedIn(s)) { resp.sendRedirect(req.getContextPath()+"/login"); return; }

        Map<String, CartItem> cart = cart(s);
        if (cart == null || cart.isEmpty()) { resp.sendRedirect(req.getContextPath()+"/cart"); return; }

        User user = (User) s.getAttribute("account");
        String receiverName = req.getParameter("receiverName");
        String receiverPhone = req.getParameter("receiverPhone");
        String address = req.getParameter("shippingAddress");
        if (isBlank(receiverName) || isBlank(receiverPhone) || isBlank(address)) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin nhận hàng.");
            req.setAttribute("cart", cart);
            req.getRequestDispatcher("/views/web/checkout.jsp").forward(req, resp);
            return;
        }

        Order order = Order.builder().user(user).status("Đơn hàng mới").paymentMethod("COD")
                .receiverName(receiverName.trim()).receiverPhone(receiverPhone.trim())
                .shippingAddress(address.trim()).orderDate(LocalDateTime.now()).build();

        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart.values()) {
            Video v = videoService.findById(item.getVideo().getVideoId());
            if (v == null || !v.isActive() || item.getQuantity() < 1 || item.getQuantity() > v.getStock()) {
                req.setAttribute("error", "Sản phẩm không đủ tồn kho. Vui lòng cập nhật giỏ hàng.");
                req.setAttribute("cart", cart);
                req.getRequestDispatcher("/views/web/checkout.jsp").forward(req, resp);
                return;
            }
            BigDecimal line = v.getPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
            OrderDetail d = OrderDetail.builder().order(order).video(v).quantity(item.getQuantity()).unitPrice(v.getPrice()).build();
            order.getDetails().add(d);
            total = total.add(line);
            v.setStock(v.getStock() - item.getQuantity());
            videoService.update(v);
        }
        order.setTotalAmount(total);
        try {
            orderService.create(order);
            s.removeAttribute("cart");
            resp.sendRedirect(req.getContextPath()+"/orders?success=1");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath()+"/cart");
        }
    }
    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
}