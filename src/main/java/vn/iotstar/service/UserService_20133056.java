package vn.iotstar.service;

import vn.iotstar.entity.User;

public interface UserService_20133056 {
	User login(String username, String password);
	User get(String username);
	
	
	void insert(User user);
	boolean register(String email, String password, String username, String fullname,
			String phone);
	boolean checkExistEmail(String email);
	boolean checkExistUsername(String username);
	
	User findByEmail(String email);
	
	void updatePassword(String username, String newpass);
	
	void update(User user);
}
