package vn.iotstar.controller.admin;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.service.CategoryService_20133056;
import vn.iotstar.service.impl.CategoryServiceImpl_20133056;

@WebServlet(urlPatterns = {"/admin/category/delete"})
public class CategoryDeleteController_20133056 extends HttpServlet{

	private static final long serialVersionUID = 1L;
	CategoryService_20133056 cateService = new CategoryServiceImpl_20133056();
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String id = req.getParameter("id");
        try {
            cateService.delete(Integer.parseInt(id));
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/admin/category/list");
	}
}

