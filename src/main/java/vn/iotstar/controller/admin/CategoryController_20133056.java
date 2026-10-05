package vn.iotstar.controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.Category;
import vn.iotstar.service.CategoryService_20133056;
import vn.iotstar.service.impl.CategoryServiceImpl_20133056;

@WebServlet(urlPatterns = {"/admin/category/list"})
public class CategoryController_20133056 extends HttpServlet {

	private static final long serialVersionUID = 1L;
	CategoryService_20133056 cateService = new CategoryServiceImpl_20133056();
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// Lấy danh sách từ Service
        List<Category> list = cateService.findAll();
        
        // Đẩy dữ liệu ra view
        req.setAttribute("categories", list);
        
        RequestDispatcher dispatcher = req.getRequestDispatcher("/views/admin/list-category.jsp");
        dispatcher.forward(req, resp);
		
	}
}
