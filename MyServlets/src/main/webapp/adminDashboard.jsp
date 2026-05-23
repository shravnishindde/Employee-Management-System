<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    // Check session for admin email
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect("EmpLogin.jsp");
        return;
    }

    // Fetch admin details from Emp_reg table
    PreparedStatement adminStmt = conn.prepareStatement("SELECT f_name, l_name, dept, desig FROM Emp_reg WHERE e_mail = ?");
    adminStmt.setString(1, adminEmail);
    ResultSet adminRs = adminStmt.executeQuery();

    String firstName = "", lastName = "", department = "", designation = "";
    if (adminRs.next()) {
        firstName = adminRs.getString("f_name");
        lastName = adminRs.getString("l_name");
        department = adminRs.getString("dept");
        designation = adminRs.getString("desig");
    }

    // Fetch employee count
    PreparedStatement empCountStmt = conn.prepareStatement("SELECT COUNT(*) AS total FROM Emp_reg");
    ResultSet empCountRs = empCountStmt.executeQuery();
    int totalEmployees = empCountRs.next() ? empCountRs.getInt("total") : 0;

    // Fetch employee details
    PreparedStatement empListStmt = conn.prepareStatement("SELECT f_name, l_name, e_mail, dept, desig FROM Emp_reg");
    ResultSet empListRs = empListStmt.executeQuery();

    empCountRs.close();
    empCountStmt.close();
    adminRs.close();
    adminStmt.close();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="adminstyle.css">
    <style>
    /* Glassmorphism Navbar */
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

    <!-- Main Content -->
    <div class="main-container">
        <div class="header">
            <h1>Admin Dashboard</h1>
            <div class="profile-container">
                <div class="profile-icon" onclick="toggleProfile()">
                    <i class="fas fa-user-circle"></i> <%= firstName %>
                </div>
                <div class="profile-dropdown" id="profileDropdown">
                    <p><strong>Name:</strong> <%= firstName + " " + lastName %></p>
                    <p><strong>Email:</strong> <%= adminEmail %></p>
                    <p><strong>Department:</strong> <%= department %></p>
                    <p><strong>Designation:</strong> <%= designation %></p>
                   
                </div>
            </div>
        </div>

        <!-- Dashboard Stats -->
        <div class="dashboard">
            <div class="stats">
                <div class="card"><i class="fas fa-users"></i> Employees <br> <%= totalEmployees %></div>
               
                <div class="card"><i class="fas fa-user-clock"></i> On Leave <br> 
<%
    PreparedStatement leaveCountStmt = conn.prepareStatement(
        "SELECT COUNT(DISTINCT e_id) AS count FROM Leavee WHERE status='Approved' AND ? BETWEEN l_from AND l_to"
    );
    leaveCountStmt.setDate(1, new java.sql.Date(System.currentTimeMillis()));
    ResultSet leaveCountRs = leaveCountStmt.executeQuery();
    if (leaveCountRs.next()) {
        out.print(leaveCountRs.getInt("count"));
    } else {
        out.print("0");
    }
    leaveCountRs.close();
    leaveCountStmt.close();
%>
</div>
                
               
            </div>
        </div>

        <!-- Employee List -->
        <div class="employee-table">
            <h2>Employee List</h2>
            <table>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Department</th>
                    <th>Designation</th>
                </tr>
                <% while (empListRs.next()) { %>
                <tr>
                    <td><%= empListRs.getString("f_name") + " " + empListRs.getString("l_name") %></td>
                    <td><%= empListRs.getString("e_mail") %></td>
                    <td><%= empListRs.getString("dept") %></td>
                    <td><%= empListRs.getString("desig") %></td>
                </tr>
                <% } %>
            </table>
        </div>
        
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
    empListRs.close();
    empListStmt.close();
    conn.close();
%>