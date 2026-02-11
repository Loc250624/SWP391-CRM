package dbConnection;



import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {


    private final String userID = "sa"; 
//    private final String password = "123";
    private final String password = "123";

     protected Connection connection;
    public DBContext()
    {
       
        try {
            
            String url = "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=CRM_System;encrypt=true;trustServerCertificate=true;";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, userID, password);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }


  
    public static void main(String[] args) {
        try {
            DBContext db = new DBContext();
            if (db.connection != null) {
                System.out.println("Chúc mừng! Kết nối đến Database thành công.");
            }
        } catch (Exception e) {
            System.err.println("Kết nối thất bại! Lỗi: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
