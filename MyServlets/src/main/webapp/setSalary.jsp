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
    <title>Set Employee Salary</title>
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="adminstyle.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #002244, #004488);
            color: white;
            
        }

        .main-container1 {
            width: 50%;
            margin: auto;
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.3);
            margin-top: 50px;
        }

        h2 {
            margin-bottom: 20px;
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        label {
            font-size: 18px;
            margin-top: 10px;
        }

        select, input {
            width: 80%;
            padding: 8px;
            margin: 5px 0;
            border-radius: 5px;
            border: none;
            font-size: 16px;
        }

        button {
            margin-top: 15px;
            background-color: #28a745;
            color: white;
            font-size: 18px;
            padding: 10px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            width: 50%;
        }

        button:hover {
            background-color: #218838;
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
            <h1>Manage Employees</h1>
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
<div class="main-container1">
    <h2>Set Salary</h2>
    <form action="processSetSalary.jsp" method="post">
        <label for="e_id">Select Employee:</label>
        <select name="e_id" required>
            <%
                PreparedStatement empStmt = conn.prepareStatement("SELECT e_id, e_name FROM Emp");
                ResultSet empRs = empStmt.executeQuery();
                while (empRs.next()) {
            %>
            <option value="<%= empRs.getInt("e_id") %>">
                <%= empRs.getString("e_name") %>
            </option>
            <% } empRs.close(); empStmt.close(); %>
        </select>

        <label for="base_salary">Base Salary:</label>
        <input type="number" step="0.01" name="base_salary" required>

        <label for="bonus">Bonus:</label>
        <input type="number" step="0.01" name="bonus">

        <label for="deduction">Deduction:</label>
        <input type="number" step="0.01" name="deduction">

        <label for="pay_date">Salary Date:</label>
        <input type="date" name="pay_date" required>

        <button type="submit">Set Salary</button>
    </form>
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