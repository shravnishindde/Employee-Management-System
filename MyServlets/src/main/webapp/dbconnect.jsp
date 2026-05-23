<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Declare Connection Variable
    Connection conn = null;
    
    try {
        // Load MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Establish Connection (Use environment variables instead of hardcoding)
        String dbURL = "jdbc:mysql://localhost:3306/EmployeeDB";
        String dbUser = "root";  // Store securely
        String dbPass = "project04"; // Store securely
        
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // Store connection in session
        session.setAttribute("dbConnection", conn);

    } catch (Exception e) {
        out.println("<h3 style='color:red;'>Database Connection Failed: " + e.getMessage() + "</h3>");
    }
%>
