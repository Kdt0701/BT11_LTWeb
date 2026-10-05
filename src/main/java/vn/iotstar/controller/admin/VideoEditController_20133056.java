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
import vn.iotstar.entity.Video;
import vn.iotstar.entity.Category;
import vn.iotstar.service.CategoryService_20133056;
import vn.iotstar.service.VideoService_20133056;
import vn.iotstar.service.impl.CategoryServiceImpl_20133056;
import vn.iotstar.service.impl.VideoServiceImpl_20133056;

@WebServlet(urlPatterns = {"/admin/video/edit"})
@MultipartConfig
public class VideoEditController_20133056 extends HttpServlet {
    private static final long serialVersionUID = 1L;
    VideoService_20133056 videoService = new VideoServiceImpl_20133056();
    CategoryService_20133056 cateService = new CategoryServiceImpl_20133056();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        Video video = videoService.findById(id);
        List<Category> categories = cateService.findAll();

        req.setAttribute("video", video);
        req.setAttribute("categories", categories);
        
        req.getRequestDispatcher("/views/admin/edit-video.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        
        try {
            String id = req.getParameter("videoId");
            Video video = videoService.findById(id); // Lấy video cũ
            
            video.setTitle(req.getParameter("title"));
            video.setDescription(req.getParameter("description"));
            video.setActive(req.getParameter("active") != null);
            
            int cateId = Integer.parseInt(req.getParameter("categoryId"));
            Category cate = new Category();
            cate.setCategoryId(cateId);
            video.setCategory(cate);

            Part filePart = req.getPart("poster");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String appPath = req.getServletContext().getRealPath("");
                java.nio.file.Path uploadPath = java.nio.file.Paths.get(appPath, "upload", "video");
                
                if (!java.nio.file.Files.exists(uploadPath)) java.nio.file.Files.createDirectories(uploadPath);
                
                filePart.write(uploadPath.resolve(fileName).toString());
                video.setPoster(fileName);
            }
            else {
            	video.setPoster(videoService.findById(id).getPoster());
            }
            
            videoService.update(video);
            resp.sendRedirect(req.getContextPath() + "/admin/video/list");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
