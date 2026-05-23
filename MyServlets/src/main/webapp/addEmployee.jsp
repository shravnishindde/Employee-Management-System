<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect("EmpLogin.jsp");
        return;
    }

    String message = request.getParameter("message");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
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

        if (password == null || confirmPassword == null || !password.equals(confirmPassword)) {
            message = "Passwords do not match or are missing!";
        } else {
            try {
                // Check if the employee already exists
                PreparedStatement checkEmp = conn.prepareStatement("SELECT * FROM Emp_reg WHERE e_mail = ?");
                checkEmp.setString(1, email);
                ResultSet empExists = checkEmp.executeQuery();

                if (empExists.next()) {
                    message = "Employee already exists!";
                } else {
                    // Generate new u_id
                    int newUserId = 1;
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT MAX(u_id) FROM User");
                    if (rs.next()) {
                        newUserId = rs.getInt(1) + 1;
                    }
                    rs.close();
                    stmt.close();

                    // Insert into User table
                    String userSql = "INSERT INTO User (u_id, u_name, u_type) VALUES (?, ?, 'Employee')";
                    PreparedStatement userPst = conn.prepareStatement(userSql);
                    userPst.setInt(1, newUserId);
                    userPst.setString(2, email);
                    userPst.executeUpdate();
                    userPst.close();

                    // Insert into Emp_reg table
                    String empRegSql = "INSERT INTO Emp_reg (f_name, m_name, l_name, e_mail, p_no, dob, gender, dept, desig, address, pass, c_pass, u_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    PreparedStatement empRegPst = conn.prepareStatement(empRegSql);
                    empRegPst.setString(1, firstName);
                    empRegPst.setString(2, middleName);
                    empRegPst.setString(3, lastName);
                    empRegPst.setString(4, email);
                    empRegPst.setString(5, phone);
                    empRegPst.setString(6, dob);
                    empRegPst.setString(7, gender);
                    empRegPst.setString(8, department);
                    empRegPst.setString(9, designation);
                    empRegPst.setString(10, address);
                    empRegPst.setString(11, password);
                    empRegPst.setString(12, confirmPassword);
                    empRegPst.setInt(13, newUserId);
                    empRegPst.executeUpdate();
                    empRegPst.close();

                    // Generate new e_id for Emp table
                    int newEmpId = 1;
                    Statement empStmt = conn.createStatement();
                    ResultSet empRs = empStmt.executeQuery("SELECT MAX(e_id) FROM Emp");
                    if (empRs.next()) {
                        newEmpId = empRs.getInt(1) + 1;
                    }
                    empRs.close();
                    empStmt.close();

                    // Insert into Emp table
                    String empSql = "INSERT INTO Emp (e_id, e_name, emp_mail, emp_unm, emp_pass, emp_phn, emp_add, a_id, u_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    PreparedStatement empPst = conn.prepareStatement(empSql);
                    empPst.setInt(1, newEmpId);
                    empPst.setString(2, firstName + " " + lastName);
                    empPst.setString(3, email);
                    empPst.setString(4, email);
                    empPst.setString(5, password);
                    empPst.setString(6, phone);
                    empPst.setString(7, address);
                    empPst.setNull(8, java.sql.Types.INTEGER);  // Assuming a_id (admin ID) is NULL for now
                    empPst.setInt(9, newUserId);
                    empPst.executeUpdate();
                    empPst.close();

                    response.sendRedirect("manageEmployees.jsp?message=Employee added successfully!");
                }

                checkEmp.close();
                empExists.close();
            } catch (Exception e) {
                message = "Database error: " + e.getMessage();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Employee</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #4e54c8, #8f94fb);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden;
            color: #fff;
        }

        .form-container {
            width: 100%;
            max-width: 750px;
            max-height: 90%;
            overflow-y: auto;
            background: rgba(255, 255, 255, 0.1);
            box-shadow: 0 8px 32px rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.18);
            box-sizing: border-box;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            font-size: 2rem;
            color: #fff;
        }

        label {
            margin: 10px 0 5px;
            font-size: 1rem;
            color: rgba(255, 255, 255, 0.9);
        }

        input, select, textarea {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            background: rgba(255, 255, 255, 0.2);
            border: none;
            border-radius: 8px;
            box-shadow: inset 0 4px 6px rgba(0, 0, 0, 0.2);
            color: #fff;
            font-size: 1.1rem;
        }

        input::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        textarea {
            resize: none;
        }

        input[type="submit"] {
            background: linear-gradient(135deg, #6a11cb, #2575fc);
            color: #fff;
            border: none;
            padding: 15px;
            font-size: 1.1rem;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        input[type="submit"]:hover {
            background: linear-gradient(135deg, #2575fc, #6a11cb);
        }
    .navbar {
    display: flex;
    justify-content: center; /* Center content horizontally */
    align-items: center;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 50px; /* Adjusted for better proportion */
    padding: 5px 15px;
    background: linear-gradient(135deg, rgba(0, 50, 150, 0.8), rgba(0, 30, 100, 0.7)); /* Darker Blue Gradient */
    backdrop-filter: blur(15px); /* Stronger glass effect */
    -webkit-backdrop-filter: blur(15px);
    border-bottom: 2px solid rgba(255, 255, 255, 0.2);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    z-index: 1000;
}

/* Center title */
.navbar .title {
    font-size: 1.5rem;
    font-weight: bold;
    color: white;
    text-align: center; /* Center text inside */
}
    
    </style>
</head>
<body>
<div class="navbar">
        <div class="title">Employee Management System</div>
    </div>
      
    <div class="form-container">
        <h2>Add Employee</h2>
        <% if (message != null && !message.isEmpty()) { %>
            <p class="error-message"><%= message %></p>
        <% } %>
        <form method="post" action="addEmployee.jsp">
            <label>First Name</label>
            <input type="text" name="fn" required>
            <label>Middle Name</label>
            <input type="text" name="mn">
            <label>Last Name</label>
            <input type="text" name="ln" required>
            <label>Email</label>
            <input type="email" name="ml" required>
            <label>Phone</label>
            <input type="text" name="phone" required>
            <label>DOB</label>
            <input type="date" name="dob" required>
            <label>Gender</label>
            <select name="gender" required>
                <option value="">Select Gender</option>
                <option value="male">Male</option>
                <option value="female">Female</option>
                <option value="other">Other</option>
            </select>
            <label>Department</label>
            <input type="text" name="department">
            <label>Designation</label>
            <input type="text" name="designation">
            <label>Address</label>
            <textarea name="address" required></textarea>
            <label>Password</label>
            <input type="password" name="password" required>
            <label>Confirm Password</label>
            <input type="password" name="confirm_password" required>
            <input type="submit" value="Add Employee">
<button type="button" onclick="window.location.href='manageEmployees.jsp';">Cancel</button>
             
        </form>
    </div>
</body>
</html>