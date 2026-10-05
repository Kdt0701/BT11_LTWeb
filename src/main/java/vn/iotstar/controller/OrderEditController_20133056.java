package vn.iotstar.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.entity.Order;
import vn.iotstar.entity.User;
import vn.iotstar.service.OrderService_20133056;
import vn.iotstar.service.VideoService_20133056;
import vn.iotstar.service.impl.OrderServiceImpl_20133056;
import vn.iotstar.service.impl.VideoServiceImpl_20133056;

@WebServlet({"/orders/edit", "/orders/edit/add", "/orders/edit/update", "/orders/edit/delete", "/orders/cancel"})
public class OrderEditController_20133056 extends HttpServlet {
    private final OrderService_20133056 orderService = new OrderServiceImpl_20133056();
    private final VideoService_20133056 videoService = new VideoServiceImpl_20133056();

    private User account(HttpSession session) { return session == null ? null : (User) session.getAttribute("account"); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = account(req.getSession(false));
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        Long id = parseId(req.getParameter("id"));
        if (id == null) { resp.sendRedirect(req.getContextPath() + "/orders"); return; }
        try {
            Order order = orderService.findById(id);
            if (order == null || order.getUser() == null || !user.getUsername().equals(order.getUser().getUsername())) {
                resp.sendRedirect(req.getContextPath() + "/orders?error=notfound"); return;
            }
            if (!"Đơn hàng mới".equals(order.getStatus())) {
                resp.sendRedirect(req.getContextPath() + "/orders?error=locked"); return;
            }
            req.setAttribute("order", order);
            req.setAttribute("videos", videoService.findAll());
            req.getRequestDispatcher("/views/web/order-edit.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/orders?error=1");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        User user = account(req.getSession(false));
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        Long id = parseId(req.getParameter("id"));
        String path = req.getServletPath();
        try {
            if (id == null) throw new IllegalArgumentException("Mã đơn hàng không hợp lệ.");
            if ("/orders/edit/add".equals(path)) {
                String videoId = req.getParameter("videoId");
                int quantity = parsePositive(req.getParameter("quantity"));
                orderService.addDetail(id, user.getUsername(), videoId, quantity);
            } else if ("/orders/edit/update".equals(path)) {
                Long detailId = parseId(req.getParameter("detailId"));
                int quantity = parsePositive(req.getParameter("quantity"));
                orderService.updateDetail(id, user.getUsername(), detailId, quantity);
            } else if ("/orders/edit/delete".equals(path)) {
                Long detailId = parseId(req.getParameter("detailId"));
                orderService.deleteDetail(id, user.getUsername(), detailId);
            } else if ("/orders/cancel".equals(path)) {
                orderService.cancelOrder(id, user.getUsername());
                resp.sendRedirect(req.getContextPath() + "/orders?cancelled=1");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/orders/edit?id=" + id + "&updated=1");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/orders/edit?id=" + id + "&error=" + java.net.URLEncoder.encode(e.getMessage() == null ? "Không thể cập nhật đơn hàng." : e.getMessage(), java.nio.charset.StandardCharsets.UTF_8));
        }
    }

    private Long parseId(String value) {
        try { return value == null ? null : Long.valueOf(value); } catch (NumberFormatException e) { return null; }
    }
    private int parsePositive(String value) {
        try { int n = Integer.parseInt(value); if (n < 1) throw new NumberFormatException(); return n; }
        catch (NumberFormatException e) { throw new IllegalArgumentException("Số lượng phải là số nguyên lớn hơn 0."); }
    }
}
