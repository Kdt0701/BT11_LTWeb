package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.Video;
import vn.iotstar.service.VideoService_20133056;
import vn.iotstar.service.impl.VideoServiceImpl_20133056;

@WebServlet(urlPatterns = {"/home", "/trang-chu"})
public class HomeController_20133056 extends HttpServlet {

    private static final long serialVersionUID = 1L;
    VideoService_20133056 videoService = new VideoServiceImpl_20133056();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy danh sách tất cả video
        List<Video> videos = videoService.findAll();
        
        // Logic chia dữ liệu cho giao diện đẹp
        if (videos != null && !videos.isEmpty()) {
            // Lấy video đầu tiên làm Banner (Phim nổi bật)
            Video featuredVideo = videos.get(0);
            req.setAttribute("featuredVideo", featuredVideo);
            
            // Danh sách còn lại (loại bỏ video đầu tiên để không trùng)
            if (videos.size() > 1) {
                List<Video> listVideo = videos.subList(1, videos.size());
                req.setAttribute("listVideo", listVideo);
            }
        }

        req.getRequestDispatcher("/views/home.jsp").forward(req, resp);
    }
}