<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
        session.setAttribute("error", "Please enter both email and password.");
        response.sendRedirect("EmpLogin.jsp");
        return;
    }

    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        String sql = "SELECT f_name, pass FROM Emp_reg WHERE e_mail = ?";
        pst = conn.prepareStatement(sql);
        pst.setString(1, email.trim());
        rs = pst.executeQuery();

        if (rs.next()) {
            String dbPassword = rs.getString("pass");
            String firstName = rs.getString("f_name"); 

            if (password.equals(dbPassword)) {
                if ("Shravani".equalsIgnoreCase(firstName)) {
                    session.setAttribute("adminEmail", email); // Store admin email in session
                    response.sendRedirect("adminDashboard.jsp"); // Redirect to admin dashboard
                } else {
                    session.setAttribute("employeeEmail", email); // Store employee email in session
                    response.sendRedirect("employeeDashboard.jsp"); // Redirect to employee dashboard
                }
            } else {
                session.setAttribute("error", "Incorrect password. Try again.");
                response.sendRedirect("EmpLogin.jsp");
            }
        } else {
            session.setAttribute("error", "Invalid email. Try again.");
            response.sendRedirect("EmpLogin.jsp");
        }
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "Database error. Try again later.");
        response.sendRedirect("EmpLogin.jsp");
    } finally {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (conn != null) conn.close();
    }
%>