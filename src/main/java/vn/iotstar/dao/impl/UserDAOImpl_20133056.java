package vn.iotstar.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.UserDAO_20133056;
import vn.iotstar.entity.User;

public class UserDAOImpl_20133056 implements UserDAO_20133056{
	public Connection conn = null;
	public PreparedStatement ps = null;
	public ResultSet rs = null;

	

	@Override
	public void insert(User user) {
		EntityManager em = JPAConfig.getEnityManager();
		EntityTransaction trans = em.getTransaction();
		try {
			trans.begin();
			em.persist(user);
			trans.commit();
		}catch (Exception ex){
			ex.printStackTrace();
			trans.rollback();
		}finally {
			em.close();
		}
		
	}

	@Override
	public boolean checkExistEmail(String email) {
		EntityManager em = JPAConfig.getEnityManager();
		try {
			List<User> users = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
									.setParameter("email", email)
									.getResultList();
			return !users.isEmpty();
		}finally {
			em.close();
		}
	}

	@Override
	public boolean checkExistUsername(String username) {
		EntityManager em = JPAConfig.getEnityManager();
		try {
			List<User> users = em.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class)
									.setParameter("username", username)
									.getResultList();
			return !users.isEmpty();
		}finally {
			em.close();
		}
	}


	@Override
	public User findByEmail(String email) {
		EntityManager em = JPAConfig.getEnityManager();
		return em.find(User.class, email);
	}

	@Override
	public void updatePassword(int id, String newpass) {
		EntityManager em = JPAConfig.getEnityManager();
	    EntityTransaction tx = em.getTransaction();
	    try {
	        tx.begin();

	        em.createQuery(
	            "UPDATE User u SET u.password = :pwd WHERE u.id = :id"
	        )
	        .setParameter("pwd", newpass)
	        .setParameter("id", id)
	        .executeUpdate();

	        tx.commit();
	    } catch (Exception e) {
	        if (tx.isActive()) tx.rollback();
	        throw e;
	    } finally {
	        em.close();
	    }
		
	}

	@Override
	public User get(String username) {
		EntityManager em = JPAConfig.getEnityManager();
		TypedQuery<User> q = em.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class);
		q.setParameter("username", username);
		return q.getResultStream().findFirst().orElse(null);
		
	}

	@Override
	public void update(User user) {
		EntityManager enma = JPAConfig.getEnityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			enma.merge(user);
			trans.commit();
		} catch (Exception e) {
			e.printStackTrace();
			trans.rollback();
		} finally {
			enma.close();
		}
		
	}
}
