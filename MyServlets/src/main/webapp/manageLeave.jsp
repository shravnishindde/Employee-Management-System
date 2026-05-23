<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    // Check if the admin is logged in
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect("EmpLogin.jsp");
        return;
    }

    // Fetch admin's first name
    PreparedStatement adminStmt = conn.prepareStatement("SELECT f_name FROM Admin WHERE e_mail = ?");
    adminStmt.setString(1, adminEmail);
    ResultSet adminRs = adminStmt.executeQuery();

    String firstName = "";
    if (adminRs.next()) {
        firstName = adminRs.getString("f_name");
    }
    adminRs.close();
    adminStmt.close();

    // Fetch leave requests with employee leave details
    PreparedStatement leaveStmt = conn.prepareStatement(
        "SELECT l.l_id, l.l_from, l.l_to, l.reason, l.leave_type, l.status, e.e_name, c.cert_path, " +
        "lb.fixed_leaves, lb.used_leaves, lb.unpaid_leaves, lb.balance_leaves " +
        "FROM Leavee l " +
        "INNER JOIN Emp e ON l.e_id = e.e_id " +
        "LEFT JOIN Certificates c ON l.l_id = c.l_id " +
        "LEFT JOIN LeaveBalance lb ON l.e_id = lb.e_id " +
        "ORDER BY l.l_id DESC"
    );
    ResultSet leaveRs = leaveStmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Leave Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="adminstyle.css">
    
    <style>
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

        .btn {
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
            <h1>Manage Leaves</h1>
            <div class="profile-container">
                <div class="profile-icon">
                    <i class="fas fa-user-circle"></i> <%= firstName %>
                </div>
            </div>
        </div>

        <table class="glass-table">
            <tr>
                <th>Employee Name</th>
                <th>From</th>
                <th>To</th>
                <th>Leave Type</th>
                <th>Reason</th>
                <th>Status</th>
                <th>Certificate</th>
                <th>Fixed Leaves</th>
                <th>Enjoyed Leaves</th>
                <th>Unpaid Leaves</th>
                <th>Balance Leaves</th>
                <th>Action</th>
            </tr>
            <% while (leaveRs.next()) { %>
            <tr>
                <td><%= leaveRs.getString("e_name") %></td>
                <td><%= leaveRs.getDate("l_from") %></td>
                <td><%= leaveRs.getDate("l_to") %></td>
                <td><%= leaveRs.getString("leave_type") %></td>
                <td><%= leaveRs.getString("reason") %></td>
                <td><%= leaveRs.getString("status") %></td>
                <td>
                    <% if (leaveRs.getString("cert_path") != null) { %>
                        <a href="<%= leaveRs.getString("cert_path") %>" target="_blank" class="btn">View</a>
                    <% } else { %>
                        No Certificate
                    <% } %>
                </td>
                <td><%= leaveRs.getInt("fixed_leaves") %></td>
                <td><%= leaveRs.getInt("used_leaves") %></td>
                <td><%= leaveRs.getInt("unpaid_leaves") %></td>
                <td><%= leaveRs.getInt("balance_leaves") %></td>
                <td>
                    <form action="updateLeaveStatus.jsp" method="post">
                        <input type="hidden" name="l_id" value="<%= leaveRs.getInt("l_id") %>">
                        <select name="status">
                            <option value="Pending" <%= leaveRs.getString("status").equals("Pending") ? "selected" : "" %>>Pending</option>
                            <option value="Approved">Approved</option>
                            <option value="Rejected">Rejected</option>
                        </select>
                        <button type="submit" class="btn">Update</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>

    </div>

</body>
</html>

<%
    leaveRs.close();
    leaveStmt.close();
    conn.close();
%>