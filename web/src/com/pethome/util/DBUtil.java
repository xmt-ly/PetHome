package com.pethome.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 数据库连接工具类
 * 使用 JDBC 直连 MySQL 8.0
 */
public class DBUtil {

    // MySQL 连接参数（请根据实际环境修改）
    private static final String URL = "jdbc:mysql://localhost:3306/pethome"
            + "?useUnicode=true"
            + "&characterEncoding=UTF-8"
            + "&serverTimezone=Asia/Shanghai"
            + "&useSSL=false"
            + "&allowPublicKeyRetrieval=true";

    private static final String USER = "root";
    private static final String PASSWORD = "980139XMT";

    /**
     * 静态代码块：注册 JDBC 驱动
     */
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("[DBUtil] MySQL JDBC Driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            System.err.println("[DBUtil] Error: MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }

    /**
     * 获取数据库连接
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /**
     * 关闭多个资源（Connection, PreparedStatement, ResultSet）
     * 体现 JDBC 资源管理
     */
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try {
                    r.close();
                } catch (Exception e) {
                    // 关闭资源异常通常可忽略
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 关闭 Connection
     */
    public static void closeConnection(Connection conn) {
        close(conn);
    }

    /**
     * 关闭 PreparedStatement
     */
    public static void closeStatement(PreparedStatement ps) {
        close(ps);
    }

    /**
     * 关闭 ResultSet
     */
    public static void closeResultSet(ResultSet rs) {
        close(rs);
    }

    /**
     * 测试连接
     */
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            System.out.println("[DBUtil] Database connection test: SUCCESS!");
            System.out.println("[DBUtil] Connected to: " + conn.getMetaData().getURL());
        } catch (SQLException e) {
            System.err.println("[DBUtil] Database connection test: FAILED!");
            e.printStackTrace();
        }
    }
}
