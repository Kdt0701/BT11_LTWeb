package vn.iotstar.controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Video;
import vn.iotstar.service.CategoryService_20133056;
import vn.iotstar.service.VideoService_20133056;
import vn.iotstar.service.impl.CategoryServiceImpl_20133056;
import vn.iotstar.service.impl.VideoServiceImpl_20133056;

@WebServlet(urlPatterns = {"/admin/video/add"})
@MultipartConfig
public class VideoAddController_20133056 extends HttpServlet {
    private static final long serialVersionUID = 1L;
    VideoService_20133056 videoService = new VideoServiceImpl_20133056();
    CategoryService_20133056 cateService = new CategoryServiceImpl_20133056();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Load danh sách Category để hiển thị trong <select>
        List<Category> categories = cateService.findAll();
        req.setAttribute("categories", categories);
        
        req.getRequestDispatcher("/views/admin/add-video.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        
        try {
            Video video = new Video();
            video.setVideoId(req.getParameter("videoId")); // ID dạng String
            video.setTitle(req.getParameter("title"));
            video.setDescription(req.getParameter("description"));
            video.setViews(0);
            video.setActive(req.getParameter("active") != null);
            
            // Lấy categoryId từ dropdown và gán object Category
            int cateId = Integer.parseInt(req.getParameter("categoryId"));
            Category cate = new Category();
            cate.setCategoryId(cateId);
            video.setCategory(cate);

            // Xử lý upload Poster (tương tự Category icon)
            Part filePart = req.getPart("poster");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String appPath = req.getServletContext().getRealPath("");
                java.nio.file.Path uploadPath = java.nio.file.Paths.get(appPath, "upload", "video");
                
                if (!java.nio.file.Files.exists(uploadPath)) {
                    java.nio.file.Files.createDirectories(uploadPath);
                }
                filePart.write(uploadPath.resolve(fileName).toString());
                video.setPoster(fileName);
            } else {
                video.setPoster("default-poster.jpg");
            }

            videoService.insert(video);
            resp.sendRedirect(req.getContextPath() + "/admin/video/list");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
