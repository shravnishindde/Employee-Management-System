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

    // Fetch attendance records
    String query = "SELECT A.a_id, E.e_name, A.date, A.in_time, A.out_time, A.total_hours, A.status " +
                   "FROM Attendance A JOIN Emp E ON A.e_id = E.e_id ORDER BY A.date DESC";
    PreparedStatement stmt = conn.prepareStatement(query);
    ResultSet rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Attendance</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="adminstyle.css">
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

        /* Navbar */
        .navbar {
            display: flex;
            justify-content: center;
            align-items: center;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 50px;
            background: linear-gradient(135deg, rgba(0, 50, 150, 0.8), rgba(0, 30, 100, 0.7));
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            z-index: 1000;
        }

        .navbar .title {
            font-size: 1.5rem;
            font-weight: bold;
            color: white;
            text-align: center;
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
    </style>
</head>
<body>

    <div class="navbar">
        <div class="title">Employee Management System</div>
    </div>

    <!-- Sidebar -->
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
            <h1>View Attendance</h1>
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

        <h2>Employee Attendance Records</h2>
        <table class="glass-table">
            <tr>
                <th>Emp ID</th>
                <th>Employee Name</th>
                <th>Date</th>
                <th>In Time</th>
                <th>Out Time</th>
                <th>Total Hours</th>
                <th>Status</th>
            </tr>
            <% while (rs.next()) { %>
            <tr>
                <td><%= rs.getInt("a_id") %></td>
                <td><%= rs.getString("e_name") %></td>
                <td><%= rs.getDate("date") %></td>
                <td><%= rs.getTime("in_time") %></td>
                <td><%= rs.getTime("out_time") %></td>
                <td><%= rs.getTime("total_hours") %></td>
                <td><%= rs.getString("status") %></td>
            </tr>
            <% } %>
        </table>
    </div>

<script>
function toggleProfile() {
    var dropdown = document.getElementById("profileDropdown");
    dropdown.classList.toggle("show");
}

// Close dropdown if clicked outside
window.onclick = function(event) {
    if (!event.target.closest(".profile-container")) {
        document.getElementById("profileDropdown").classList.remove("show");
    }
};
</script>

</body>
</html>

<%
    rs.close();
    stmt.close();
    conn.close();
%>