<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>
<%@ page session="true" %>
<%
int id = -1;
String name=null;
String mail = (String) session.getAttribute("employeeEmail");
String action = request.getParameter("action");

if (mail == null || mail.trim().isEmpty()) {
	 response.sendRedirect("employeeDashboard.jsp?error=SessionExpired");
} else {
    PreparedStatement pst = null;
    ResultSet rs = null;
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
      <style>
    .glass-card {
    background: rgba(255, 255, 255, 0.1);
    border-radius: 20px;
    padding: 30px;
    max-width: 500px;
    margin: 15px auto;
    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border: 1px solid rgba(255, 255, 255, 0.18);
    color: #fff;
}

 .glass-card h2 {
    text-align: center;
    margin-bottom: 20px;
    color: #ffffff;
    font-size: 28px;
    letter-spacing: 1px;
}

.glass-card form {
    display: flex;
    flex-direction: column;
}

.glass-card label {
    margin-bottom: 15px;
    font-weight: 500;
}

.glass-card input[type="date"],
.glass-card select,
.glass-card textarea,
.glass-card input[type="file"] {
    width: 100%;
    padding: 10px;
    border: none;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.2);
    color: #fff;
    font-size: 14px;
    margin-top: 5px;
    transition: 0.3s ease;
}

.glass-card input[type="date"]:focus,
.glass-card select:focus,
.glass-card textarea:focus,
.glass-card input[type="file"]:focus {
    background: rgba(255, 255, 255, 0.3);
    outline: none;
}

.glass-card textarea {
    resize: vertical;
    min-height: 80px;
}

.glass-card button {
    padding: 12px;
    background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
    border: none;
    border-radius: 50px;
    color: #fff;
    font-weight: bold;
    cursor: pointer;
    transition: all 0.3s ease;
    margin-top: 10px;
}

.glass-card button:hover {
    transform: translateY(-3px);
    box-shadow: 0 5px 15px rgba(24, 90, 157, 0.4);
}

.glass-card input[type="file"]::-webkit-file-upload-button {
    background: rgba(255, 255, 255, 0.3);
    border: none;
    padding: 8px 12px;
    border-radius: 8px;
    color: #fff;
    cursor: pointer;
}

.glass-card input[type="file"]::-webkit-file-upload-button:hover {
    background: rgba(255, 255, 255, 0.5);
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

    <!-- Main Content -->
    <div class="main">
        <div class="glass-card">
            <h2>Apply for Leave</h2>
            <form action="LeaveUploadServlet" method="post" enctype="multipart/form-data">
                <label>From: <input type="date" name="leave_from" required></label>
                <label>To: <input type="date" name="leave_to" required></label>
                <label class="full-width">Type:
                    <select name="leave_type" required>
                        <option value="Medical">Medical</option>
                        <option value="Unpaid">Unpaid</option>
                        <option value="Paid">Paid</option>
                    </select>
                </label>
                <label class="full-width">Reason:<textarea name="reason" required></textarea></label>
                <label class="full-width">Upload Certificate: <input type="file" name="leave_certificate"></label>
                <button type="submit">Apply</button>
            </form>
        </div>
    </div>
</body>
</html>