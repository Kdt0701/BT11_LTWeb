package vn.iotstar.service.impl;

import java.util.List;

import vn.iotstar.dao.CategoryDAO_20133056;
import vn.iotstar.dao.impl.CategoryDAOImpl_20133056;
import vn.iotstar.entity.Category;
import vn.iotstar.service.CategoryService_20133056;

public class CategoryServiceImpl_20133056 implements CategoryService_20133056{
	
	CategoryDAO_20133056 cateDAO = new CategoryDAOImpl_20133056();
	
	@Override
	public void insert(Category category) {
		cateDAO.insert(category);
	}

	@Override
	public void update(Category newCategory) {
		cateDAO.update(newCategory);
		
	}

	@Override
	public void delete(int id) throws Exception {
		cateDAO.delete(id);
		
	}

	@Override
	public Category findById(int id) {
		return cateDAO.findById(id);
	}

	@Override
	public List<Category> findByName(String name) {
		return cateDAO.findByName(name);
	}

	@Override
	public List<Category> findAll() {
		return cateDAO.findAll();
	}

	@Override
	public List<Category> findAllWithVideos() {
		return cateDAO.findAllWithVideos();
	}

	
}
