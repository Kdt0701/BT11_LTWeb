package vn.iotstar.controller;

import java.io.IOException;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.entity.CartItem;
import vn.iotstar.entity.Video;
import vn.iotstar.service.VideoService_20133056;
import vn.iotstar.service.impl.VideoServiceImpl_20133056;

@WebServlet({"/cart", "/cart/add", "/cart/update", "/cart/delete"})
public class CartController_20133056 extends HttpServlet {
    private final VideoService_20133056 videoService = new VideoServiceImpl_20133056();

    @SuppressWarnings("unchecked")
    private Map<String, CartItem> getCart(HttpSession session) {
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private void redirectCart(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("cart", getCart(req.getSession()));
        req.getRequestDispatcher("/views/web/cart.jsp").forward(req, resp);
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();
        Map<String, CartItem> cart = getCart(req.getSession());

        try {
            String id = req.getParameter("id");
            if ("/cart/add".equals(path)) {
                Video v = videoService.findById(id);
                if (v == null || !v.isActive() || v.getStock() <= 0) {
                    redirectCart(req, resp); return;
                }
                int requested = Integer.parseInt(Optional.ofNullable(req.getParameter("quantity")).orElse("1"));
                CartItem item = cart.get(id);
                int current = item == null ? 0 : item.getQuantity();
                int quantity = Math.min(v.getStock(), Math.max(1, current + requested));
                if (item == null) cart.put(id, new CartItem(v, quantity));
                else item.setQuantity(quantity);
            } else if ("/cart/update".equals(path)) {
                CartItem item = cart.get(id);
                if (item != null) {
                    Video v = videoService.findById(id);
                    int quantity = Integer.parseInt(req.getParameter("quantity"));
                    if (v == null || quantity < 1) cart.remove(id);
                    else item.setQuantity(Math.min(quantity, v.getStock()));
                }
            } else if ("/cart/delete".equals(path)) {
                cart.remove(id);
            }
        } catch (Exception ignored) {}
        redirectCart(req, resp);
    }
}