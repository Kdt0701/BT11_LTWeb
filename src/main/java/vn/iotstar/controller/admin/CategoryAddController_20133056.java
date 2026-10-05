package vn.iotstar.controller.admin;

import java.io.Console;
import java.io.File;
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
import vn.iotstar.utils.Constant;

@WebServlet(urlPatterns = {"/admin/category/add"})
@MultipartConfig
public class CategoryAddController_20133056 extends HttpServlet{

	private static final long serialVersionUID = 1L;
	CategoryService_20133056 cateService = new CategoryServiceImpl_20133056();
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		RequestDispatcher dispatcher =req.getRequestDispatcher("/views/admin/add-category.jsp");
		dispatcher.forward(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Category category = new Category();
		resp.setContentType("text/html");
		resp.setCharacterEncoding("UTF-8");
		req.setCharacterEncoding("UTF-8");

		try {

			String name = req.getParameter("catename");
			
			category.setCategoryName(name);
			
			Part filePart = req.getPart("icon");
			
			if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = filePart.getSubmittedFileName();
             
                String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
                String fileName = System.currentTimeMillis() + "." + ext;

                
                String appPath = req.getServletContext().getRealPath("");

	             // Dùng Paths.get() để ghép đường dẫn một cách thông minh
                // Nó sẽ tự xử lý dù appPath có \ hay không
	          java.nio.file.Path uploadPath = java.nio.file.Paths.get(appPath, "upload", "category");
	
	          //  Tạo thư mục nếu chưa có
	          if (!java.nio.file.Files.exists(uploadPath)) {
	              java.nio.file.Files.createDirectories(uploadPath);
	          }
	
	          // Lấy đường dẫn đầy đủ đến file
	          java.nio.file.Path filePath = uploadPath.resolve(fileName);
	          
	          System.out.println(filePath);
	          
	          // Ghi file
	          filePart.write(filePath.toString());

                // Lưu đường dẫn vào model 
                category.setImages(fileName);
            } else {
                // Người dùng không upload file mới
            	category.setImages(null);
            }

            cateService.insert(category);
            
            resp.sendRedirect(req.getContextPath() + "/admin/category/list");
			
		}
		catch (Exception e) {
			e.printStackTrace();
            // Xử lý lỗi (ví dụ: hiển thị trang lỗi)
            req.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
            // Có thể forward lại trang edit với thông báo lỗi
             RequestDispatcher dispatcher = req.getRequestDispatcher("/views/admin/add-category.jsp");
             dispatcher.forward(req, resp);
		}
	}
	
}
