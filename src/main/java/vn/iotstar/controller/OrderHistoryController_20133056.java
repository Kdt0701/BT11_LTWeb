package vn.iotstar.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.entity.User;
import vn.iotstar.service.OrderService_20133056;
import vn.iotstar.service.impl.OrderServiceImpl_20133056;

@WebServlet("/orders")
public class OrderHistoryController_20133056 extends HttpServlet {
    private final OrderService_20133056 service = new OrderServiceImpl_20133056();

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