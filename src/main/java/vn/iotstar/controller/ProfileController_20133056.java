package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService_20133056;
import vn.iotstar.service.impl.UserServiceImpl_20133056;

//URL này dùng chung cho cả admin và user
@WebServlet(urlPatterns = {"/admin/profile", "/user/profile"}) 
@MultipartConfig
public class ProfileController_20133056 extends HttpServlet {

 private static final long serialVersionUID = 1L;
 UserService_20133056 userService = new UserServiceImpl_20133056();

 @Override
 protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
     // 1. Lấy User hiện tại từ Session
     HttpSession session = req.getSession();
     User user = (User) session.getAttribute("account");

     // Nếu chưa đăng nhập thì đá về trang login
     if (user == null) {
         resp.sendRedirect(req.getContextPath() + "/login");
         return;
     }

     // 2. Đảm bảo dữ liệu mới nhất từ DB (phòng trường hợp session cũ)
     User currentUser = userService.get(user.getUsername());
     
     req.setAttribute("user", currentUser);
     RequestDispatcher dispatcher = req.getRequestDispatcher("/views/web/profile.jsp"); // Dùng chung view
     dispatcher.forward(req, resp);
 }

 @Override
 protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
     req.setCharacterEncoding("UTF-8");
     resp.setCharacterEncoding("UTF-8");

     HttpSession session = req.getSession();
     User sessionUser = (User) session.getAttribute("account");

     if (sessionUser == null) {
         resp.sendRedirect(req.getContextPath() + "/login");
         return;
     }

     try {
         User userToUpdate = userService.get(sessionUser.getUsername());

         String fullname = req.getParameter("fullname");
         String phone = req.getParameter("phone");
         String email = req.getParameter("email"); 

         userToUpdate.setFullname(fullname);
         userToUpdate.setPhone(phone);
         userToUpdate.setEmail(email);

         // Xử lý upload ảnh đại diện 
         Part filePart = req.getPart("images");
         if (filePart != null && filePart.getSize() > 0) {
             String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
             String appPath = req.getServletContext().getRealPath("");
             java.nio.file.Path uploadPath = java.nio.file.Paths.get(appPath, "upload", "user");

             if (!java.nio.file.Files.exists(uploadPath)) {
                 java.nio.file.Files.createDirectories(uploadPath);
             }
             
             filePart.write(uploadPath.resolve(fileName).toString());
             userToUpdate.setImages(fileName);
         }

         userService.update(userToUpdate);

         // Cập nhật lại session để hiển thị đúng ở các trang khác ngay lập tức
         session.setAttribute("account", userToUpdate);
         req.setAttribute("message", "Cập nhật thông tin thành công!");
         req.setAttribute("user", userToUpdate);
         
         // Forward lại trang profile
         RequestDispatcher dispatcher = req.getRequestDispatcher("/views/web/profile.jsp");
         dispatcher.forward(req, resp);

     } catch (Exception e) {
         e.printStackTrace();
         req.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
         req.getRequestDispatcher("/views/web/profile.jsp").forward(req, resp);
     }
 }
}
