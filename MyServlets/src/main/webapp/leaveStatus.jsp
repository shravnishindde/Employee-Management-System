<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>
<%@ page session="true" %>
<%
int id = -1;
String mail = (String) session.getAttribute("employeeEmail");
String action = request.getParameter("action");

if (mail == null || mail.trim().isEmpty()) {
	 response.sendRedirect("EmpDash.html?error=SessionExpired");
} else {
    PreparedStatement pst = null;
    ResultSet rs = null;
    try {
        String q2 = "SELECT e_id FROM Emp WHERE emp_mail = ?";
        pst = conn.prepareStatement(q2);
        pst.setString(1, mail.trim());
        rs = pst.executeQuery();
        if (rs.next()) {
            id = rs.getInt(1);
        }
        session.setAttribute("eid", id);
    } catch (Exception e) {
        out.print("<p class='error'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
    }
}


%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Leave Application</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    </head>
<body>
    <div class="sidebar">
        <h2>Employee Dashboard</h2>
        <div class="nav-links">
            <a href="EmpDash.html"><i class="fas fa-house"></i> Home</a>
            <a href="markAttendence.jsp"><i class="fas fa-user-check"></i> Attendance</a>
            <a href="leaveDisplay.jsp"><i class="fas fa-plane-departure"></i> Apply for Leave</a>
            <a href="leaveStatus.jsp"><i class="fas fa-calendar-check"></i> Leave Status</a>
            <a href="payrollHistory.jsp"><i class="fas fa-wallet"></i> Payroll History</a>
            <a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <!-- Header -->
    <div class="header">
        <h1>Employee Management System</h1>
    </div>

    <!-- Main Content -->
    <div class="main">
        <div class="glass-card">
            <h2>Leave Status</h2>