package vn.iotstar.controller.admin;

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

@WebServlet(urlPatterns = {"/admin/video/list"})
public class VideoController_20133056 extends HttpServlet {
    private static final long serialVersionUID = 1L;
    VideoService_20133056 videoService = new VideoServiceImpl_20133056();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	// Xử lý phân trang
        String indexPage = req.getParameter("index");
        int index = 1;
        if (indexPage != null) {
            index = Integer.parseInt(indexPage);
        }
        
        // Đề bài yêu cầu: 6 video / 1 trang
        int pageSize = 6; 
        int count = videoService.count();
        int endPage = count / pageSize;
        if (count % pageSize != 0) {
            endPage++;
        }

        List<Video> list = videoService.findAll(index, pageSize);
        
        req.setAttribute("videos", list);
        req.setAttribute("endPage", endPage);
        req.setAttribute("tag", index); // Đánh dấu trang hiện tại
        
        req.getRequestDispatcher("/views/admin/list-video.jsp").forward(req, resp);
    }
}
