package vn.iotstar.controller.admin;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.Video;
import vn.iotstar.service.VideoService_20133056;
import vn.iotstar.service.impl.VideoServiceImpl_20133056;

@WebServlet(urlPatterns = {"/admin/video/delete"})
public class VideoDeleteController_20133056 extends HttpServlet{

	private static final long serialVersionUID = 1L;
    VideoService_20133056 videoService = new VideoServiceImpl_20133056();
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String id = req.getParameter("id");
        try {
            Video video = videoService.findById(id);
            
            if (video.getPoster() != null && !video.getPoster().isEmpty()) {
                String appPath = req.getServletContext().getRealPath("");
                java.nio.file.Path uploadPath = java.nio.file.Paths.get(appPath, "upload", "video", video.getPoster());

                if (java.nio.file.Files.exists(uploadPath)) {
                    java.nio.file.Files.delete(uploadPath);
                }
            }
            videoService.delete(id);
            
            resp.sendRedirect(req.getContextPath() + "/admin/video/list");

        } catch (Exception e) {
            e.printStackTrace();
            // (Có thể thêm trang báo lỗi)
        }
	}
}
