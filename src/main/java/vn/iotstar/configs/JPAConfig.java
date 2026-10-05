package vn.iotstar.configs;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JPAConfig {
	public static EntityManager getEnityManager() {
		EntityManagerFactory factory = Persistence.createEntityManagerFactory("dataSource");
		return factory.createEntityManager();
	}
}
