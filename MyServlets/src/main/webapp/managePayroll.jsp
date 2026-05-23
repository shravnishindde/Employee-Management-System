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

    // Fetch admin's first name
    PreparedStatement adminStmt = conn.prepareStatement("SELECT f_name FROM Emp_reg WHERE e_mail = ?");
    adminStmt.setString(1, adminEmail);
    ResultSet adminRs = adminStmt.executeQuery();

    String firstName = "";
    if (adminRs.next()) {
        firstName = adminRs.getString("f_name");
    }
    adminRs.close();
    adminStmt.close();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Payroll</title>
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <link rel="stylesheet" href="adminstyle.css">
    <style>
      <style>
       /* Glassmorphism Table */
        .glass-table {
            width: 100%;
            margin-top: 60px;
            border-collapse: collapse;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(12px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
            border-radius: 10px;
            overflow: hidden;
        }

        .glass-table th, .glass-table td {
            padding: 12px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            text-align: center;
            color: white;
        }

        .glass-table th {
            background: rgba(0, 0, 0, 0.3);
        }

        .glass-table td {
            background: rgba(255, 255, 255, 0.1);
        }
   /* Buttons */
        .btn {
            display: inline-block;
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            font-weight: bold;
            border-radius: 5px;
            text-decoration: none;
            transition: 0.3s;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            margin: 5px;
        }

        .btn:hover {
            background: rgba(255, 255, 255, 0.4);
        }

        .delete-btn {
            background: rgba(255, 77, 77, 0.3);
            border: 1px solid rgba(255, 77, 77, 0.5);
        }

        .delete-btn:hover {
            background: rgba(255, 77, 77, 0.5);
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
<div class="sidebar">
        <h2>Admin Panel</h2>
        <a href="adminDashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="manageEmployees.jsp"><i class="fas fa-users"></i> Employees</a>
        <a href="viewAttendance.jsp"><i class="fas fa-user-clock"></i> View Attendance</a>
        <a href="manageLeave.jsp"><i class="fas fa-calendar-check"></i> Leave</a>
        <a href="managePayroll.jsp"><i class="fas fa-money-bill-wave"></i> Payroll</a>
        <a href="setSalary.jsp"><i class="fas fa-dollar-sign"></i> Set Salary</a>
        <a href="logout.jsp" class="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
    <div class="main-container">
        <div class="header">
            <h1>Manage Payroll</h1>
            <div class="profile-container">
                <div class="profile-icon" onclick="toggleProfile()">
                    <i class="fas fa-user-circle"></i> <%= firstName %>
                </div>
                <div class="profile-dropdown" id="profileDropdown">
                    <p><strong>Name:</strong> <%= firstName %> </p>
                <p><strong>Email:</strong> <%= adminEmail %></p>
                   
                </div>
            </div>
        </div>
        </div>
    
<div class="main-container">
    
    <table class="glass-table">
        <tr>
            <th>Employee</th>
            <th>Base Salary</th>
            <th>Bonus</th>
            <th>Deduction</th>
            <th>Salary Date</th>
            <th>Last Paid Amount</th>
        </tr>

        <%
            // ✅ Open connection & fetch Payroll data
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT Emp.e_name, Payroll.* FROM Payroll " +
                "JOIN Emp ON Payroll.e_id = Emp.e_id"
            );
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("e_name") %></td>
            <td><%= rs.getDouble("base_salary") %></td>
            <td><%= rs.getDouble("bonus") %></td>
            <td><%= rs.getDouble("deduction") %></td>
            <td><%= rs.getDate("pay_date") %></td>
            <td><%= rs.getDouble("last_pay_amount") %></td>
        </tr>
        <% } %>
    </table>
<br><br>
<%
    String payDateMessage = (String) session.getAttribute("payDateMessage");
    session.removeAttribute("payDateMessage"); // Remove after displaying
%>
    <form action="generateSalary.jsp" method="post">
        <label for="e_id">Select Employee:</label>
        <select name="e_id" required>
            <option value="">-- Select Employee --</option>
            <%  
                PreparedStatement empStmt = conn.prepareStatement("SELECT e_id, e_name FROM Emp");
                ResultSet empRs = empStmt.executeQuery();
                
                while (empRs.next()) {
            %>
            <option value="<%= empRs.getInt("e_id") %>"><%= empRs.getString("e_name") %></option>
            <% }  

                // ✅ Close ResultSet & Statement after use
                empRs.close(); 
                empStmt.close();
            %>
        </select>
        <br><br>
        <button type="submit" class="btn">Generate Salary</button>
    </form>
    <!-- Display message if salary generation is restricted -->
<% if (payDateMessage != null) { %>
    <p style="color: red; font-weight: bold;"><%= payDateMessage %></p>
<% } %>

    <%
        // ✅ Close ResultSet & Statement at the end
        rs.close(); 
        stmt.close();
        
        // ✅ Finally close connection (AFTER ALL QUERIES)
        conn.close();
    %>

</div>

</body>
</html>