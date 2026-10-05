package vn.iotstar.configs;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnectionSQLServer {
	private final String SERVERNAME = ".";
	private final String DBNAME = "kt_giuaky";
	private final String PORT = "1433";
	private final String INSTANCE = "";
	private final String USERID = "sa";
	private final String PASSWORD = "sa";

	public Connection getConnectionW() throws Exception {
		String url = "jdbc:sqlserver://" + SERVERNAME +  ":" + PORT
				+ "; encrypt = true; trustServerCertificate=true; " + "databaseName=" + DBNAME;
		if (INSTANCE == null || INSTANCE.trim().isEmpty())
			url = "jdbc:sqlserver://" + SERVERNAME + ":" + PORT + ""
					+ ";encrypt = true; trustServerCertificate=true; databaseName=" + DBNAME;
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		return DriverManager.getConnection(url, USERID, PASSWORD);
	}

	public static void main(String[] args) {
		try {
			System.out.println(new DBConnectionSQLServer().getConnectionW());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
