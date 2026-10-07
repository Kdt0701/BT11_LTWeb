package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService_20133056;
import vn.iotstar.service.impl.UserServiceImpl_20133056;

@WebServlet("/forgot-password")
public class ForgotPasswordController_20133056 extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserService_20133056 service = new UserServiceImpl_20133056();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (username == null) username = "";
        if (email == null) email = "";
        if (newPassword == null) newPassword = "";
        if (confirmPassword == null) confirmPassword = "";

        username = username.trim();
        email = email.trim();

        if (username.isEmpty() || email.isEmpty()
                || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập đầy đủ thông tin.");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("alert", "Mật khẩu xác nhận không khớp.");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        User user = service.get(username);
        if (user == null || user.getEmail() == null
                || !email.equalsIgnoreCase(user.getEmail())) {
            req.setAttribute("alert", "Tài khoản hoặc email không đúng.");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        if (!user.isActive()) {
            req.setAttribute("alert", "Tài khoản đang bị khóa.");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        try {
            service.updatePassword(username, newPassword);
            resp.sendRedirect(req.getContextPath() + "/login?reset=success");
        } catch (RuntimeException e) {
            e.printStackTrace();
            req.setAttribute("alert", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
        }
    }
}
