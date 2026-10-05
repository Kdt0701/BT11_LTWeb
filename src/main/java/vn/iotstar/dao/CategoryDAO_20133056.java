package vn.iotstar.dao;

import vn.iotstar.entity.Category;
import java.util.List;

public interface CategoryDAO_20133056 {
	List<Category> findAll();
    Category findById(int id);
    void insert(Category category);
    void update(Category category);
    void delete(int id) throws Exception;
    List<Category> findByName(String keyword);
    List<Category> findAllWithVideos();
}
