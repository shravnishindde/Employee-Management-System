<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    // Ensure only admin can access this page
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect("EmpLogin.jsp");
        return;
    }

    String message = "";
    int e_id = -1;
    String alertMessage = "";

    // Check if e_id is provided in the URL
    if (request.getParameter("e_id") != null) {
        try {
            e_id = Integer.parseInt(request.getParameter("e_id"));
            conn.setAutoCommit(false); // Start transaction

            // Step 1: Get the User ID associated with this Employee
            PreparedStatement getUserStmt = conn.prepareStatement("SELECT u_id FROM Emp WHERE e_id = ?");
            getUserStmt.setInt(1, e_id);
            ResultSet rs = getUserStmt.executeQuery();

            int u_id = -1;
            if (rs.next()) {
                u_id = rs.getInt("u_id");
            }
            rs.close();
            getUserStmt.close();

            if (u_id != -1) {
                // Step 2: Delete from Emp (Employee table) FIRST
                PreparedStatement empStmt = conn.prepareStatement("DELETE FROM Emp WHERE e_id = ?");
                empStmt.setInt(1, e_id);
                int empDeleted = empStmt.executeUpdate();
                empStmt.close();

                if (empDeleted > 0) {
                    alertMessage += "alert('Deleted from Emp table successfully!');";
                }

                // Step 3: Delete from Emp_reg (if exists)
                PreparedStatement empRegStmt = conn.prepareStatement("DELETE FROM Emp_reg WHERE u_id = ?");
                empRegStmt.setInt(1, u_id);
                int empRegDeleted = empRegStmt.executeUpdate();
                empRegStmt.close();

                if (empRegDeleted > 0) {
                    alertMessage += "alert('Deleted from Emp_reg table successfully!');";
                }

                // Step 4: Delete from User table (after Emp & Emp_reg are deleted)
                PreparedStatement userStmt = conn.prepareStatement("DELETE FROM User WHERE u_id = ?");
                userStmt.setInt(1, u_id);
                int userDeleted = userStmt.executeUpdate();
                userStmt.close();

                if (userDeleted > 0) {
                    alertMessage += "alert('Deleted from User table successfully!');";
                }
            }

            // Step 5: Commit transaction
            conn.commit();
            conn.setAutoCommit(true);

            // Redirect with success message
            response.sendRedirect("manageEmployees.jsp?deleteSuccess=true");
            return;

        } catch (Exception e) {
            conn.rollback(); // Rollback transaction if error occurs
            message = "Error: " + e.getMessage();
        }
    } else {
        response.sendRedirect("manageEmployees.jsp?error=true");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delete Employee</title>
    <link rel="stylesheet" href="adminstyle.css">
    <script>
        <%= alertMessage %> // This will trigger alerts on successful deletions
    </script>
</head>
<body>
    <div class="sidebar">
        <h2>Admin Panel</h2>
        <a href="adminDashboard.jsp">Dashboard</a>
        <a href="manageEmployees.jsp">Employees</a>
        <a href="manageAttendance.jsp">Attendance</a>
        <a href="managePayroll.jsp">Payroll</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <div class="content">
        <h1>Delete Employee</h1>
        <p><%= message %></p>
        <a href="manageEmployees.jsp">Back to Employee List</a>
    </div>
</body>
</html>