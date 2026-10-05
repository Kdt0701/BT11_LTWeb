package vn.iotstar.service;

import java.util.List;

import vn.iotstar.entity.Category;

public interface CategoryService_20133056 {
	List<Category> findAll();
    Category findById(int id);
    void insert(Category category);
    void update(Category category);
    void delete(int id) throws Exception;
    List<Category> findByName(String keyword);
    List<Category> findAllWithVideos();
}
