package vn.iotstar.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Video;
import vn.iotstar.service.CategoryService_20133056;
import vn.iotstar.service.VideoService_20133056;
import vn.iotstar.service.impl.CategoryServiceImpl_20133056;
import vn.iotstar.service.impl.VideoServiceImpl_20133056;

@WebServlet("/video/category")
public class VideoByCategoryController_20133056 extends HttpServlet {
    private static final long serialVersionUID = 1L;
    VideoService_20133056 videoService = new VideoServiceImpl_20133056();
    CategoryService_20133056 cateService = new CategoryServiceImpl_20133056();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");

        if (idStr == null) {
            // TRƯỜNG HỢP 1: Không có ID -> Hiển thị tất cả Category và Video của nó
            // Gọi hàm findAllWithVideos vừa viết ở Bước 1
            List<Category> allCategories = cateService.findAllWithVideos();
            
            req.setAttribute("allCategories", allCategories);
            req.setAttribute("isAll", true); // Cờ báo hiệu đang xem tất cả
            
        } else {
            // TRƯỜNG HỢP 2: Có ID -> Hiển thị 1 Category cụ thể (Logic cũ)
            int cateId = Integer.parseInt(idStr);
            List<Video> videos = videoService.findByCategoryId(cateId);
            Category category = cateService.findById(cateId);
            
            // Để tái sử dụng view, ta add category đơn lẻ này vào 1 list
            category.setVideos(videos); // Gán list video vào đối tượng category
            List<Category> singleCateList = new ArrayList<>();
            singleCateList.add(category);
            
            req.setAttribute("allCategories", singleCateList);
            req.setAttribute("cateName", category.getCategoryName());
            req.setAttribute("isAll", false);
        }
        
        req.getRequestDispatcher("/views/web/video-category.jsp").forward(req, resp);
    }
}