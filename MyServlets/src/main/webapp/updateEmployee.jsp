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
    
  // Get Employee ID from request
    String eIdParam = request.getParameter("e_id");
    int e_id = 0; 

    if (eIdParam != null && !eIdParam.isEmpty()) {
        try {
            e_id = Integer.parseInt(eIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("manageEmployees.jsp?error=Invalid Employee ID");
            return;
        }
    } else {
        response.sendRedirect("manageEmployees.jsp?error=Employee ID missing");
        return;
    }
    
    // Fetch employee details
    PreparedStatement stmt = conn.prepareStatement(
        "SELECT e.*, r.*, u.u_name FROM Emp e " +
        "JOIN Emp_reg r ON e.u_id = r.u_id " +
        "JOIN User u ON e.u_id = u.u_id " +
        "WHERE e.e_id = ?"
    );
    stmt.setInt(1, e_id);
    ResultSet rs = stmt.executeQuery();

    if (!rs.next()) {
        response.sendRedirect("manageEmployees.jsp?message=Employee not found");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Employee</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <link rel="stylesheet" href="adminstyle.css">
   <style>
    body {
        font-family: Arial, sans-serif;
        background: linear-gradient(135deg, #4e54c8, #8f94fb);
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        color: white;
    }
    .form-container {
        width: 100%;
        max-width: 700px;
        height: 80vh; /* Set max height for scrolling */
        background: rgba(255, 255, 255, 0.1);
        backdrop-filter: blur(10px);
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        overflow-y: auto; /* Enable vertical scrollbar */
    }
    h2 {
        text-align: center;
        color: white;
    }
    label {
        display: block;
        margin-top: 12px;
        color: white;
        font-weight: bold;
    }
    input, select, textarea {
        width: 100%;
        padding: 10px;
        margin-top: 5px;
        border: none;
        border-radius: 5px;
        background: rgba(255, 255, 255, 0.2);
        color: white;
    }
    input::placeholder {
        color: rgba(255, 255, 255, 0.7);
    }
    input[type="submit"] {
        background: linear-gradient(135deg, #6a11cb, #2575fc);
        color: white;
        border: none;
        padding: 12px;
        font-size: 1rem;
        font-weight: bold;
        border-radius: 8px;
        cursor: pointer;
        transition: background 0.3s ease;
        margin-top: 15px;
    }
    input[type="submit"]:hover {
        background: linear-gradient(135deg, #2575fc, #6a11cb);
    }
               /* Navbar Styling */
.navbar {
    display: flex;
    justify-content: space-between; /* Push title to right */
    align-items: center;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 15px; /* Adjusted for better proportion */
    padding: 5px 15px;
    background: linear-gradient(135deg, rgba(0, 50, 150, 0.8), rgba(0, 30, 100, 0.7)); /* Darker Blue Gradient */
    backdrop-filter: blur(15px); /* Stronger glass effect */
    -webkit-backdrop-filter: blur(15px);
    border-bottom: 2px solid rgba(255, 255, 255, 0.2);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    z-index: 1000;
}

/* Logo or Title on Right */
.navbar .title {
    font-size: 1.0rem;
    font-weight: bold;
    color: white;
    margin-left: 10px; /* Push title to the right */
    padding-right: 20px;
}
       
</style>
   
</head>
<body>
<div class="navbar">
        <div class="title">Employee Management System</div>
    </div>
    
    <div class="form-container">
        <h2>Update Employee</h2>
        <form method="post" action="updateEmployeeProcess.jsp">
            <input type="hidden" name="e_id" value="<%= rs.getInt("e_id") %>">
            <input type="hidden" name="u_id" value="<%= rs.getInt("u_id") %>">

            <label>First Name</label>
            <input type="text" name="fn" value="<%= rs.getString("f_name") %>" required>

            <label>Middle Name</label>
            <input type="text" name="mn" value="<%= rs.getString("m_name") %>">

            <label>Last Name</label>
            <input type="text" name="ln" value="<%= rs.getString("l_name") %>" required>

            <label>Email</label>
            <input type="email" name="ml" value="<%= rs.getString("e_mail") %>" required>

            <label>Phone</label>
            <input type="text" name="phone" value="<%= rs.getString("p_no") %>" required>

            <label>DOB</label>
            <input type="date" name="dob" value="<%= rs.getString("dob") %>" required>

            <label>Gender</label>
            <select name="gender" required>
                <option value="male" <%= rs.getString("gender").equals("male") ? "selected" : "" %>>Male</option>
                <option value="female" <%= rs.getString("gender").equals("female") ? "selected" : "" %>>Female</option>
                <option value="other" <%= rs.getString("gender").equals("other") ? "selected" : "" %>>Other</option>
            </select>

            <label>Department</label>
            <input type="text" name="department" value="<%= rs.getString("dept") %>" required>

            <label>Designation</label>
            <input type="text" name="designation" value="<%= rs.getString("desig") %>" required>

            <label>Address</label>
            <textarea name="address" required><%= rs.getString("address") %></textarea>

            <label>Password (Leave blank to keep existing password)</label>
            <input type="password" name="password">

            <label>Confirm Password</label>
            <input type="password" name="confirm_password" >

            <input type="submit" value="Update Employee">
           
            <button type="button" onclick="window.location.href='manageEmployees.jsp';"> Cancel</button>
   
        </form>
    </div>
</body>
</html>