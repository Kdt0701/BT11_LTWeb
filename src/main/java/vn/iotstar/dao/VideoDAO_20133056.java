package vn.iotstar.dao;

import java.util.List;

import vn.iotstar.entity.Video;

public interface VideoDAO_20133056 {
	List<Video> findAll();
    Video findById(String id);
    void insert(Video video);
    void update(Video video);
    void delete(String id) throws Exception;
    List<Video> findByTitle(String keyword);
    // Thêm vào Interface VideoDAO
    List<Video> findAll(int page, int pageSize); // Phân trang
    int count(); // Đếm tổng video
    List<Video> findByCategoryId(int cateId); // Lọc theo danh mục
}
