<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    // Retrieve form parameters
    String fName = request.getParameter("fn");
    String mName = request.getParameter("mn");
    String lName = request.getParameter("ln");
    String email = request.getParameter("ml");
    String phone = request.getParameter("phone");
    String dob = request.getParameter("dob");
    String gender = request.getParameter("gender");
    String dept = request.getParameter("department");
    String desig = request.getParameter("designation");
    String address = request.getParameter("address");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("cpassword");

    // Check if passwords match
    if (!password.equals(confirmPassword)) {
        session.setAttribute("errorMessage", "Error: Passwords do not match!");
        response.sendRedirect("Registration.jsp");
        return;
    }

    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        conn.setAutoCommit(false); // Start transaction

        String checkEmailSql = "SELECT COUNT(*) FROM User WHERE u_name = ?";
        pst = conn.prepareStatement(checkEmailSql);
        pst.setString(1, email);
        rs = pst.executeQuery();
        
        if (rs.next() && rs.getInt(1) > 0) {
            session.setAttribute("errorMessage", "Error: Email already exists!");
            response.sendRedirect("Registration.jsp");
            return;
        }
        rs.close();
        pst.close();

        // ✅ Step 2: Get the highest u_id from User table to generate a new ID manually
        String getMaxUserIdSql = "SELECT MAX(u_id) FROM User";
        pst = conn.prepareStatement(getMaxUserIdSql);
        rs = pst.executeQuery();

        int uId = 1; // Default if no users exist
        if (rs.next() && rs.getInt(1) != 0) {
            uId = rs.getInt(1) + 1; // Generate next u_id
        }
        rs.close();
        pst.close();

        // ✅ Step 3: Get the highest e_id from Emp table to generate a new ID manually
        String getMaxEmpIdSql = "SELECT MAX(e_id) FROM Emp";
        pst = conn.prepareStatement(getMaxEmpIdSql);
        rs = pst.executeQuery();

        int eId = 1; // Default if no employees exist
        if (rs.next() && rs.getInt(1) != 0) {
            eId = rs.getInt(1) + 1; // Generate next e_id
        }
        rs.close();
        pst.close();

        // ✅ Step 4: Insert into User table
        String userSql = "INSERT INTO User (u_id, u_name, u_type) VALUES (?, ?, ?)";
        pst = conn.prepareStatement(userSql);
        pst.setInt(1, uId);
        pst.setString(2, email);
        pst.setString(3, "Employee");

        int userRow = pst.executeUpdate();
        pst.close();

        if (userRow == 0) {
            throw new Exception("User ID generation failed!");
        }

        // ✅ Step 5: Insert into Emp_reg table
        String empRegSql = "INSERT INTO Emp_reg (f_name, m_name, l_name, e_mail, p_no, dob, gender, dept, desig, address, pass, c_pass, u_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        pst = conn.prepareStatement(empRegSql);
        pst.setString(1, fName);
        pst.setString(2, mName);
        pst.setString(3, lName);
        pst.setString(4, email);
        pst.setString(5, phone);
        pst.setString(6, dob);
        pst.setString(7, gender);
        pst.setString(8, dept);
        pst.setString(9, desig);
        pst.setString(10, address);
        pst.setString(11, password);
        pst.setString(12, confirmPassword);
        pst.setInt(13, uId);

        int empRegRow = pst.executeUpdate();
        pst.close();

        // ✅ Step 6: Insert into Emp table
        String empSql = "INSERT INTO Emp (e_id, e_name, emp_mail, emp_unm, emp_pass, emp_phn, emp_add, u_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        pst = conn.prepareStatement(empSql);
        pst.setInt(1, eId);
        pst.setString(2, fName + " " + lName);
        pst.setString(3, email);
        pst.setString(4, email);
        pst.setString(5, password);
        pst.setString(6, phone);
        pst.setString(7, address);
        pst.setInt(8, uId);

        int empRow = pst.executeUpdate();
        pst.close();

        // ✅ Step 7: Commit transaction if everything is successful
        conn.commit();
        response.sendRedirect("registration_success.jsp");

    } catch (Exception e) {
        if (conn != null) {
            conn.rollback(); // Rollback transaction in case of error
        }
        session.setAttribute("errorMessage", "Database Error: " + e.getMessage());
        response.sendRedirect("Registration.jsp");
    } finally {
        try {
            if (conn != null) {
                conn.setAutoCommit(true); // Restore default mode
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>