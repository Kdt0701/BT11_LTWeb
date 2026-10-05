package vn.iotstar.service.impl;

import java.util.List;

import vn.iotstar.dao.VideoDAO_20133056;
import vn.iotstar.dao.impl.VideoDAOImpl_20133056;
import vn.iotstar.entity.Video;
import vn.iotstar.service.VideoService_20133056;

public class VideoServiceImpl_20133056 implements VideoService_20133056{
	VideoDAO_20133056 videoDao = new VideoDAOImpl_20133056();

	@Override
	public List<Video> findAll() {
		return videoDao.findAll();
	}

	@Override
	public Video findById(String id) {
		return videoDao.findById(id);
	}

	@Override
	public void insert(Video video) {
		videoDao.insert(video);
		
	}

	@Override
	public void update(Video video) {
		videoDao.update(video);
		
	}

	@Override
	public void delete(String id) throws Exception {
		try {
            videoDao.delete(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
		
	}

	@Override
	public List<Video> findByTitle(String keyword) {
		return videoDao.findByTitle(keyword);
	}

	@Override
	public List<Video> findAll(int page, int pageSize) {
		return videoDao.findAll(page, pageSize);
	}

	@Override
	public int count() {
		return videoDao.count();
	}

	@Override
	public List<Video> findByCategoryId(int cateId) {
		return videoDao.findByCategoryId(cateId);
	}
	
	
}
