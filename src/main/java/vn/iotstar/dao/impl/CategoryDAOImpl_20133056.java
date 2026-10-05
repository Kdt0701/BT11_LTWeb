package vn.iotstar.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.configs.DBConnectionSQLServer;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.CategoryDAO_20133056;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Video;

public class CategoryDAOImpl_20133056 implements CategoryDAO_20133056 {

	@Override
	public void insert(Category category) {
		EntityManager enma = JPAConfig.getEnityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			enma.persist(category);
			trans.commit();
		} catch (Exception e) {
			e.printStackTrace();
			trans.rollback();
		} finally {
			enma.close();
		}
	}

	@Override
	public void update(Category category) {
		EntityManager enma = JPAConfig.getEnityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			enma.merge(category);
			trans.commit();
		} catch (Exception e) {
			e.printStackTrace();
			trans.rollback();
		} finally {
			enma.close();
		}

	}

	@Override
	public void delete(int id) {
		EntityManager enma = JPAConfig.getEnityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			Category category = enma.find(Category.class, id);
			if (category != null) {
				enma.remove(category);
			}
			trans.commit();
		} catch (Exception e) {
			e.printStackTrace();
			trans.rollback();
		} finally {
			enma.close();
		}

	}

	@Override
	public Category findById(int id) {
		EntityManager enma = JPAConfig.getEnityManager();
		return enma.find(Category.class, id);
	}

	@Override
	public List<Category> findByName(String name) {
		EntityManager enma = JPAConfig.getEnityManager();
		String jpql = "SELECT c FROM Category c WHERE c.categoryName LIKE :keyword";
        TypedQuery<Category> query = enma.createQuery(jpql, Category.class);
        query.setParameter("keyword", "%" + name + "%");
        return query.getResultList();
	}

	@Override
	public List<Category> findAll() {
		EntityManager enma = JPAConfig.getEnityManager();
		String jpql = "SELECT c FROM Category c";
		TypedQuery<Category> query = enma.createQuery(jpql, Category.class);
		return query.getResultList();
	}

	@Override
	public List<Category> findAllWithVideos() {
		EntityManager enma = JPAConfig.getEnityManager();
	    try {
	        // Dùng LEFT JOIN FETCH để lấy Category kèm Video
	        String jpql = "SELECT DISTINCT c FROM Category c LEFT JOIN FETCH c.videos";
	        TypedQuery<Category> query = enma.createQuery(jpql, Category.class);
	        List<Category> list = query.getResultList();
	        
	        // --- ĐOẠN CODE FIX LỖI LAZY ---
	        // Duyệt qua danh sách để kích hoạt tải dữ liệu con
	        for (Category cat : list) {
	            // Gọi .size() để ép JPA tải danh sách Video (nếu chưa tải hết)
	            if (cat.getVideos() != null) {
	                for (Video v : cat.getVideos()) {
	                    // Ép tải danh sách Share và Favorite
	                    v.getShares().size(); 
	                    v.getFavorites().size();
	                }
	            }
	        }
	        // ------------------------------
	        
	        return list;
	    } finally {
	        enma.close(); // Đóng kết nối sau khi đã tải hết dữ liệu cần thiết
	    }
	}


	
}
