<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<%@ include file="dbconnect.jsp" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>

<%
int id = -1;
String name=null;
String mail = (String) session.getAttribute("employeeEmail");

if (mail == null || mail.trim().isEmpty()) {
    response.sendRedirect("employeeDashboard.jsp");
} else {
    PreparedStatement pst = null;
    ResultSet rs = null;
    String tableContent = "";
    String balanceContent = "";
    try {
        String q2 = "SELECT * FROM Emp WHERE emp_mail = ?";
        pst = conn.prepareStatement(q2);
        pst.setString(1, mail.trim());
        rs = pst.executeQuery();
        if (rs.next()) {
            id = rs.getInt(1);
            name=rs.getString(2);
        }
        session.setAttribute("eid", id);

        // Fetch leave history
        String leaveQuery = "SELECT l.l_id, l.l_from, l.l_to, l.leave_type, l.reason, l.status, c.cert_path, " +
                            "DATEDIFF(l.l_to, l.l_from) + 1 AS leave_days " +
                            "FROM Leavee l " +
                            "LEFT JOIN Certificates c ON l.l_id = c.l_id " +
                            "WHERE l.e_id = ? ORDER BY l.l_from DESC";

        PreparedStatement leavePst = conn.prepareStatement(leaveQuery);
        leavePst.setInt(1, id);
        ResultSet leaveRs = leavePst.executeQuery();

        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");

        int totalUsedLeaves = 0;
        int totalUnpaidLeaves = 0;

        tableContent += "<table class='custom-table'>";
        tableContent += "<tr><th>Leave From</th><th>Leave To</th><th>Type</th><th>Reason</th><th>Status</th><th>Leave Days</th><th>Certificate</th></tr>";

        boolean hasRecords = false;
        while (leaveRs.next()) {
            hasRecords = true;

            String from = sdf.format(leaveRs.getDate("l_from"));
            String to = sdf.format(leaveRs.getDate("l_to"));
            String type = leaveRs.getString("leave_type");
            String res = leaveRs.getString("reason");
            String status = leaveRs.getString("status");
            String certPath = leaveRs.getString("cert_path");
            int leaveDays = leaveRs.getInt("leave_days");

            res = (res != null) ? res : "Not Provided";
            status = (status != null) ? status : "Pending";
            certPath = (certPath != null) ? certPath : "";

            if (status.equalsIgnoreCase("Approved")) {
                if (type.equalsIgnoreCase("Unpaid")) {
                    totalUnpaidLeaves += leaveDays;
                } else {
                    totalUsedLeaves += leaveDays;
                }
            }

            tableContent += "<tr>";
            tableContent += "<td>" + from + "</td>";
            tableContent += "<td>" + to + "</td>";
            tableContent += "<td>" + type + "</td>";
            tableContent += "<td>" + res + "</td>";
            tableContent += "<td>" + status + "</td>";
            tableContent += "<td>" + leaveDays + "</td>";

            if (!certPath.isEmpty()) {
                tableContent += "<td><a href='" + certPath + "' target='_blank'>View</a></td>";
            } else {
                tableContent += "<td>No Certificate</td>";
            }
            tableContent += "</tr>";
        }

        if (!hasRecords) {
            tableContent += "<tr><td colspan='7' style='text-align:center; color:red;'>No leave records found.</td></tr>";
        }
        tableContent += "</table>";
        leaveRs.close();
        leavePst.close();

        // Update leave balance
        PreparedStatement updateLeaveBalance = conn.prepareStatement(
            "UPDATE LeaveBalance SET used_leaves = ?, unpaid_leaves = ? WHERE e_id = ?"
        );
        updateLeaveBalance.setInt(1, totalUsedLeaves);
        updateLeaveBalance.setInt(2, totalUnpaidLeaves);
        updateLeaveBalance.setInt(3, id);
        updateLeaveBalance.executeUpdate();
        updateLeaveBalance.close();

        PreparedStatement balancePst = conn.prepareStatement("SELECT fixed_leaves, used_leaves, unpaid_leaves, balance_leaves FROM LeaveBalance WHERE e_id = ?");
        balancePst.setInt(1, id);
        ResultSet balanceRs = balancePst.executeQuery();

        if (balanceRs.next()) {
            balanceContent += "<table class='custom-table'>";
            balanceContent += "<tr><th>Fixed</th><th>Enjoyed</th><th>Unpaid</th><th>Balance</th></tr>";
            balanceContent += "<tr>";
            balanceContent += "<td>" + balanceRs.getInt("fixed_leaves") + "</td>";
            balanceContent += "<td>" + balanceRs.getInt("used_leaves") + "</td>";
            balanceContent += "<td>" + balanceRs.getInt("unpaid_leaves") + "</td>";
            balanceContent += "<td>" + (balanceRs.getInt("balance_leaves") >= 0 ? balanceRs.getInt("balance_leaves") : 0) + "</td>";
            balanceContent += "</tr></table>";
        }

        balanceRs.close();
        balancePst.close();
    } catch (Exception e) {
        tableContent = "<p style='color:red;'>Error fetching data: " + e.getMessage() + "</p>";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Leave Application</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .custom-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            color: white;
        }
        .custom-table th, .custom-table td {
            padding: 12px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .custom-table th {
            background: rgba(255, 255, 255, 0.2);
        }
        .custom-table a {
            color: #00f0ff;
            text-decoration: underline;
        }
    </style>
</head>
<body>
     <div class="sidebar">
        <h2>Dashboard</h2>
        <div class="nav-links">
            <a href="employeeDashboard.jsp"><i class="fas fa-house"></i> Home</a>
            <a href="markAttendence.jsp"><i class="fas fa-user-check"></i> Attendance</a>
            <a href="leaveDisplay.jsp"><i class="fas fa-plane-departure"></i> Apply for Leave</a>
            <a href="EmpLeaveSt.jsp"><i class="fas fa-calendar-check"></i> Leave Status</a>
            <a href="viewSalary.jsp"><i class="fas fa-wallet"></i> Payroll History</a>
            <a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <!-- Header -->
    <div class="header">
        <h1>Employee Management System</h1>
         
        <div class="welcome-text">Welcome, <%= name%></div>
   
    </div>
    
    <div class="main">
        <div class="glass-card">
            <h2>Leave History</h2>
            <%= tableContent %>
            <h2>Leave Balance</h2>
            <%= balanceContent %>
        </div>
    </div>
</body>
</html>
<%
}
%>