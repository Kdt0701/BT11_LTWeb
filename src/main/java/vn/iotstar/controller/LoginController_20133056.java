package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService_20133056;
import vn.iotstar.service.impl.UserServiceImpl_20133056;

@WebServlet("/login")
public class LoginController_20133056 extends HttpServlet{

	private static final long serialVersionUID = 1L;
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("account") != null) {
            resp.sendRedirect(req.getContextPath() + "/waiting");
            return;
        }
		
		Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("username")) {
                    session = req.getSession(true);
                    session.setAttribute("username", cookie.getValue());
                    resp.sendRedirect(req.getContextPath() + "/waiting");
                    return;
                }
            }
        }
		
		RequestDispatcher rd = req.getRequestDispatcher("/views/login.jsp");
		rd.forward(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("text/html");
		resp.setContentType("UTF-8");
		req.setCharacterEncoding("UTF-8");
		
		
		String username = req.getParameter("username");
		String password = req.getParameter("password");
		
		String alertMsg = "";
		
		if(username.isEmpty() || password.isEmpty()){
			alertMsg = "Tài khoản hoặc mật khẩu không được rỗng";
			 req.setAttribute("alert", alertMsg);
			 req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
			 return;
		}
		UserService_20133056 service = new UserServiceImpl_20133056();
		User user = service.login(username, password);
		if(user!=null){
			 HttpSession session = req.getSession(true);
			 session.setAttribute("account", user);
			 
			 resp.sendRedirect(req.getContextPath()+"/waiting");
		}else{
			 alertMsg ="Tài khoản hoặc mật khẩu không đúng";
			 req.setAttribute("alert", alertMsg);
			 req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
		}
	}	
}
