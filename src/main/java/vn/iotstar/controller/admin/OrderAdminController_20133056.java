package vn.iotstar.controller.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.entity.User;
import vn.iotstar.service.OrderService_20133056;
import vn.iotstar.service.impl.OrderServiceImpl_20133056;

@WebServlet({"/admin/orders", "/admin/orders/detail", "/admin/orders/status"})
public class OrderAdminController_20133056 extends HttpServlet {
    private static final String[] STATUSES = {
        "Đơn hàng mới", "Đã xác nhận", "Chuẩn bị hàng", "Vận chuyển",
        "Giao hàng", "Đã giao", "Đơn hàng hủy", "Đơn hàng hoàn"
    };
    private final OrderService_20133056 service = new OrderServiceImpl_20133056();

    private boolean isAdmin(HttpSession session) {
        Object account = session == null ? null : session.getAttribute("account");
        return account instanceof User && ((User) account).isAdmin();
    }

    private boolean validStatus(String status) {
        if (status == null) return false;
        for (String s : STATUSES) if (s.equals(status)) return true;
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (!isAdmin(session)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ Admin được quản lý đơn hàng."); return; }

        String path = req.getServletPath();
        if ("/admin/orders/detail".equals(path)) {
            try {
                Long id = Long.valueOf(req.getParameter("id"));
                req.setAttribute("order", service.findById(id));
            } catch (Exception e) {
                req.setAttribute("order", null);
            }
            req.setAttribute("statuses", STATUSES);
            req.getRequestDispatcher("/views/admin/order-detail.jsp").forward(req, resp);
            return;
        }

        String status = req.getParameter("status");
        if (!validStatus(status)) status = null;
        req.setAttribute("selectedStatus", status == null ? "" : status);
        req.setAttribute("statuses", STATUSES);
        req.setAttribute("orders", service.findAll(status));
        req.getRequestDispatcher("/views/admin/order-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (!isAdmin(session)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ Admin được duyệt đơn hàng."); return; }
        req.setCharacterEncoding("UTF-8");
        try {
            Long id = Long.valueOf(req.getParameter("id"));
            String status = req.getParameter("status");
            if (validStatus(status)) service.updateStatus(id, status);
            resp.sendRedirect(req.getContextPath() + "/admin/orders/detail?id=" + id + "&updated=1");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders?error=1");
        }
    }
}
