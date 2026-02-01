package dbConnection;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author admin
 */

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {

    private final String serverName = "localhost";
    private final String dbName = "CRM_System_Full"; 
    private final String portNumber = "1433";
    private final String userID = "sa"; 
    private final String password = "123";

    public Connection getConnection() throws Exception {
       
        String url = "jdbc:sqlserver://" + serverName + ":" + portNumber 
                + ";databaseName=" + dbName 
                + ";user=" + userID 
                + ";password=" + password
                + ";encrypt=true;trustServerCertificate=true;";
        
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url);
    }

  
    public static void main(String[] args) {
        try {
            DBContext db = new DBContext();
            if (db.getConnection() != null) {
                System.out.println("Chúc mừng! Kết nối đến Database " + db.dbName + " thành công.");
            }
        } catch (Exception e) {
            System.err.println("Kết nối thất bại! Lỗi: " + e.getMessage());
            e.printStackTrace();
        }
    }
}