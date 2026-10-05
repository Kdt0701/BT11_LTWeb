package vn.iotstar.controller.admin;

import java.io.IOException;


import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Category;
import vn.iotstar.service.CategoryService_20133056;
import vn.iotstar.service.impl.CategoryServiceImpl_20133056;

@WebServlet(urlPatterns = { "/admin/category/edit" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, 
	maxFileSize = 1024 * 1024 * 5, 
	maxRequestSize = 1024 * 1024 * 5 * 5)
public class CategoryEditController_20133056 extends HttpServlet {

	private static final long serialVersionUID = 1L;
	CategoryService_20133056 cateService = new CategoryServiceImpl_20133056();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// Lấy ID từ URL
        String id = req.getParameter("id");
        Category category = cateService.findById(Integer.parseInt(id));
        
        req.setAttribute("category", category);
        RequestDispatcher dispatcher = req.getRequestDispatcher("/views/admin/edit-category.jsp");
        dispatcher.forward(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        try {
            // Lấy dữ liệu từ form
            int id = Integer.parseInt(req.getParameter("categoryid"));
            String name = req.getParameter("catename");
            
            // Lấy category cũ để giữ lại ảnh nếu không up ảnh mới
            Category category = cateService.findById(id);
            category.setCategoryName(name);

            Part filePart = req.getPart("icon");
            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = filePart.getSubmittedFileName();
                String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
                String fileName = System.currentTimeMillis() + "." + ext;
                
                String appPath = req.getServletContext().getRealPath("");
                java.nio.file.Path uploadPath = java.nio.file.Paths.get(appPath, "upload", "category");
                
                if (!java.nio.file.Files.exists(uploadPath)) {
                    java.nio.file.Files.createDirectories(uploadPath);
                }
                
                filePart.write(uploadPath.resolve(fileName).toString());
                category.setImages(fileName);
            }
            
            // Gọi hàm update
            cateService.update(category);
            resp.sendRedirect(req.getContextPath() + "/admin/category/list");

        } catch (Exception e) {
            e.printStackTrace();
        }
	}
	
}
