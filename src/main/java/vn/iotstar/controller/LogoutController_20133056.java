package vn.iotstar.controller;

import java.io.IOException;
import java.net.http.HttpClient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutController_20133056 extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        Cookie cookie = new Cookie("username", "");
        cookie.setMaxAge(0);
        resp.addCookie(cookie);
        resp.sendRedirect(req.getContextPath() + "/login");
	}
	
}
