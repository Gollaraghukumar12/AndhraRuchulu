
package com.andhraruchulu.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/andhra_ruchulu";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "Raghu@123";

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC driver could not be loaded.", e);
        }

        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}

