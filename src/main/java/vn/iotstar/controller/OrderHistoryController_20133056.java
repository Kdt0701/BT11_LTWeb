package vn.iotstar.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.entity.User;
import vn.iotstar.service.OrderService_20133056;
import vn.iotstar.service.impl.OrderServiceImpl_20133056;

@WebServlet({"/orders", "/orders/return"})
public class OrderHistoryController_20133056 extends HttpServlet {
    private final OrderService_20133056 service = new OrderServiceImpl_20133056();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("account") == null) { resp.sendRedirect(req.getContextPath()+"/login"); return; }
        req.setCharacterEncoding("UTF-8");
        User user = (User)s.getAttribute("account");
        try {
            Long id = Long.valueOf(req.getParameter("id"));
            service.requestReturn(id, user.getUsername(), req.getParameter("reason"));
            resp.sendRedirect(req.getContextPath()+"/orders?returnRequested=1");
        } catch (Exception e) {
            String msg = java.net.URLEncoder.encode(e.getMessage() == null ? "Không thể gửi yêu cầu hoàn trả." : e.getMessage(), java.nio.charset.StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath()+"/orders?returnError="+msg);
        }
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath()+"/login"); return;
        }
        User user = (User)s.getAttribute("account");
        String status = req.getParameter("status");
        req.setAttribute("selectedStatus", status == null ? "" : status);
        req.setAttribute("orders", service.findByUsername(user.getUsername(), status));
        req.getRequestDispatcher("/views/web/order-history.jsp").forward(req, resp);
    }
}