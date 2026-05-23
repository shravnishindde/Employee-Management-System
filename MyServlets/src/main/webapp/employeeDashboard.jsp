<%@ page session="true" %>
<%@ include file="dbconnect.jsp" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>
<%@ page import="java.io.*, jakarta.servlet.*, jakarta.servlet.http.*" %>

<%
    String mail = (String) session.getAttribute("employeeEmail");
if (mail == null || mail.trim().isEmpty()) {
    response.sendRedirect("EmpLogin.jsp"); // Redirect immediately
    return;
}
if (conn == null) {
    response.sendRedirect("errorPage.jsp"); // Redirect to an error page
    return;
}
    String fname = null, lname = null, egen = null;
    int id = 0;

    if (mail != null && !mail.trim().isEmpty()) {
        String q1 = "SELECT f_name, l_name, gender FROM Emp_reg WHERE e_mail = ?";
        PreparedStatement pst = conn.prepareStatement(q1);
        pst.setString(1, mail.trim());
        ResultSet rs = pst.executeQuery();
        if (rs.next()) {
            fname = rs.getString("f_name");
            lname = rs.getString("l_name");
            egen = rs.getString("gender");
            session.setAttribute("fname", fname);
            session.setAttribute("lname", lname);
            session.setAttribute("empGender", egen);
        }

        String q2 = "SELECT e_id FROM Emp WHERE emp_mail = ?";
        pst = conn.prepareStatement(q2);
        pst.setString(1, mail.trim());
        rs = pst.executeQuery();
        if (rs.next()) {
            id = rs.getInt(1);
        }
        session.setAttribute("eid", id);
    }

    if (fname == null) {
        response.sendRedirect("EmpLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="styles.css">
    <script>
    window.onload = function() {
        const params = new URLSearchParams(window.location.search);
        if (params.get('status') === 'success') {
            alert('â Leave applied successfully!');
        } else if (params.get('error')) {
            alert('â Error: ' + params.get('error'));
        }
    }
   
    function showManual() {
        var manualContainer = document.getElementById("manual-container");
        if (manualContainer.style.display === "none" || manualContainer.style.display === "") {
            manualContainer.style.display = "block"; // Show manual
        } else {
            manualContainer.style.display = "none"; // Hide manual
        }
    }
</script>



</head>

<body>

    <!-- Sidebar -->
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
         <div class="welcome-text">Welcome, <%= fname %> <%= lname %></div>
    </div>

    <!-- Main Content -->
    <div class="main">
        <div class="glass-card">
             <h2>Welcome, <%= fname %> <%= lname %></h2>
              </div>
              <button class="view-manual-btn" onclick="showManual()">
            <i class="fas fa-book"></i> View Manual
        </button>

        <!-- PDF Viewer (Initially Hidden) -->
        <div id="manual-container" class="manual-container">
            <iframe id="manual-frame" src="EmpManual.jsp"></iframe>
       
        </div>
        
    </div>
    

</body>

</html>