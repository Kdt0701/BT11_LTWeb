package vn.iotstar.configs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnectionMySQL {
	
	private static String USERNAME = "root";
	private static String PASSWORD = "12345";
	private static String Driver = "com.mysql.cj.jdbc.Driver";
	private static String URL = "jdbc:mysql://localhost:3306/kt_giuaky";
	
	public static Connection getDatabaseConnection() throws SQLException, Exception{
		try {
			Class.forName(Driver);
			return DriverManager.getConnection(URL, USERNAME, PASSWORD);
		}
		catch (SQLException e){
			e.printStackTrace();
		}
		return null;
	}
	
	public static void main(String[] args) {
		try {
			new DBConnectionMySQL();
			System.out.println(DBConnectionMySQL.getDatabaseConnection());
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
