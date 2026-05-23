<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    int e_id = Integer.parseInt(request.getParameter("e_id"));
    int u_id = Integer.parseInt(request.getParameter("u_id"));

    String firstName = request.getParameter("fn");
    String middleName = request.getParameter("mn");
    String lastName = request.getParameter("ln");
    String email = request.getParameter("ml");
    String phone = request.getParameter("phone");
    String dob = request.getParameter("dob");
    String gender = request.getParameter("gender");
    String department = request.getParameter("department");
    String designation = request.getParameter("designation");
    String address = request.getParameter("address");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirm_password");

    try {
        conn.setAutoCommit(false); // Start transaction

       
        PreparedStatement emailCheckStmt = conn.prepareStatement(
            "SELECT COUNT(*) FROM Emp_reg WHERE e_mail = ? AND u_id <> ?"
        );
        emailCheckStmt.setString(1, email);
        emailCheckStmt.setInt(2, u_id);
        ResultSet emailRs = emailCheckStmt.executeQuery();
        emailRs.next();
        int emailExists = emailRs.getInt(1);
        emailRs.close();
        emailCheckStmt.close();

        if (emailExists > 0) {
            conn.rollback(); // Rollback transaction if email exists
            response.sendRedirect("updateEmployee.jsp?e_id=" + e_id + "&message=Email already exists!");
            return;
        }

        PreparedStatement userStmt = conn.prepareStatement("UPDATE User SET u_name=? WHERE u_id=?");
        userStmt.setString(1, email); // Set email as u_name
        userStmt.setInt(2, u_id);
        userStmt.executeUpdate();
        userStmt.close();

        String empRegSql = "UPDATE Emp_reg SET f_name=?, m_name=?, l_name=?, e_mail=?, p_no=?, dob=?, gender=?, dept=?, desig=?, address=?";
        if (!password.isEmpty()) {
            empRegSql += ", pass=?, c_pass=?";
        }
        empRegSql += " WHERE u_id=?";
        
        PreparedStatement empRegStmt = conn.prepareStatement(empRegSql);
        empRegStmt.setString(1, firstName);
        empRegStmt.setString(2, middleName);
        empRegStmt.setString(3, lastName);
        empRegStmt.setString(4, email);
        empRegStmt.setString(5, phone);
        empRegStmt.setString(6, dob);
        empRegStmt.setString(7, gender);
        empRegStmt.setString(8, department);
        empRegStmt.setString(9, designation);
        empRegStmt.setString(10, address);

        if (!password.isEmpty()) {
            empRegStmt.setString(11, password);
            empRegStmt.setString(12, confirmPassword);
            empRegStmt.setInt(13, u_id);
        } else {
            empRegStmt.setInt(11, u_id);
        }
        empRegStmt.executeUpdate();
        empRegStmt.close();

        // ✅ Update Emp table
        String empSql = "UPDATE Emp SET e_name=?, emp_mail=?, emp_unm=?, emp_phn=?, emp_add=?";
        if (!password.isEmpty()) {
            empSql += ", emp_pass=?";
        }
        empSql += " WHERE e_id=? AND u_id=?";

        PreparedStatement empStmt = conn.prepareStatement(empSql);
        empStmt.setString(1, firstName + " " + lastName);
        empStmt.setString(2, email);
        empStmt.setString(3, email); // Username should be email
        empStmt.setString(4, phone);
        empStmt.setString(5, address);

        if (!password.isEmpty()) {
            empStmt.setString(6, password);
            empStmt.setInt(7, e_id);
            empStmt.setInt(8, u_id);
        } else {
            empStmt.setInt(6, e_id);
            empStmt.setInt(7, u_id);
        }
        empStmt.executeUpdate();
        empStmt.close();

        // ✅ Commit transaction
        conn.commit();
        response.sendRedirect("manageEmployees.jsp?message=Employee updated successfully!");

    } catch (Exception e) {
        conn.rollback(); // Rollback if an error occurs
        response.sendRedirect("updateEmployee.jsp?e_id=" + e_id + "&message=Error: " + e.getMessage());
    } finally {
        conn.setAutoCommit(true); // Reset auto-commit
        if (conn != null) conn.close(); // Close connection
    }
%>