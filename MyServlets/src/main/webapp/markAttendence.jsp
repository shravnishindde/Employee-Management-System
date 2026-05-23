<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date, java.time.LocalTime, java.time.Duration" %>
<%@ page session="true" %>
<%@ include file="dbconnect.jsp" %>
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
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Mark Attendance</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
       
        .attendance-btn {
            padding: 10px 20px;
            margin: 10px;
            border: none;
            background:#80daeb;
            color: black;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
        }
        .attendance-btn:hover {
            background: #0c5a91;
        }
        .message-box {
            margin-top: 20px;
        }
        .success {
            color: lightgreen;
            font-weight: bold;
        }
        .error {
            color: #ff4b5c;
            font-weight: bold;
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
        <div class="welcome-text">Welcome, <%= fname %> <%= lname %></div>
        
    </div>

    <!-- Main Content -->
    <div class="main">
        <div class="glass-card">
        <h2>Attendance System</h2>
        <!-- Attendance Form -->
        <form method="post">
            <button class="attendance-btn" type="submit" name="action" value="markIn">Mark In Time</button>
            <button class="attendance-btn" type="submit" name="action" value="markOut">Mark Out Time</button>
        </form>

        <div class="message-box">
            <% 
                int id = -1;
             
                String action = request.getParameter("action");

                if (mail == null || mail.trim().isEmpty()) {
                    out.print("<p class='error'>Session expired! Please login again.</p>");
                } else if (action != null) {
                    try {
                        String q2 = "SELECT e_id FROM Emp WHERE emp_mail = ?";
                        PreparedStatement pst = conn.prepareStatement(q2);
                        pst.setString(1, mail.trim());
                        ResultSet rs = pst.executeQuery();
                        if (rs.next()) {
                            id = rs.getInt(1);
                        }

                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        String currentDate = sdf.format(new Date());
                        LocalTime currentTime = LocalTime.now();
                        String formattedTime = currentTime.toString();

                        String checkQuery = "SELECT in_time, out_time FROM Attendance WHERE e_id = ? AND Date = ?";
                        PreparedStatement checkPs = conn.prepareStatement(checkQuery);
                        checkPs.setInt(1, id);
                        checkPs.setString(2, currentDate);
                        ResultSet rsAttendance = checkPs.executeQuery();

                        if ("markIn".equals(action)) {
                            if (rsAttendance.next()) {
                                out.print("<p class='error'>In-Time already marked today!</p>");
                            } else {
                                String insertQuery = "INSERT INTO Attendance (e_id, Date, in_time, status) VALUES (?, ?, ?, 'Present')";
                                PreparedStatement insertPs = conn.prepareStatement(insertQuery);
                                insertPs.setInt(1, id);
                                insertPs.setString(2, currentDate);
                                insertPs.setString(3, formattedTime);
                                int rowsInserted = insertPs.executeUpdate();
                                if (rowsInserted > 0) {
                                    out.print("<p class='success'> In-time marked at " + formattedTime + "</p>");
                                } else {
                                    out.print("<p class='error'>Error marking in-time.</p>");
                                }
                            }
                        } else if ("markOut".equals(action)) {
                            if (rsAttendance.next()) {
                                String inTimeStr = rsAttendance.getString("in_time");
                                String outTimeStr = rsAttendance.getString("out_time");
                                if (outTimeStr == null) {
                                    LocalTime inTime = LocalTime.parse(inTimeStr);
                                    Duration workDuration = Duration.between(inTime, currentTime);
                                    long hoursWorked = workDuration.toHours();
                                    String status = (hoursWorked >= 8) ? "Present" : "Half-day";  
                                 // Debugging output to check values before updating the database
                                    System.out.println("Updating Attendance: out_time=" + formattedTime + ", status=" + status);

                                    String updateQuery = "UPDATE Attendance SET out_time = ?, status = ? WHERE e_id = ? AND Date = ?";
                                    PreparedStatement updatePs = conn.prepareStatement(updateQuery);
                                    updatePs.setString(1, formattedTime);
                                    updatePs.setString(2, status);
                                    updatePs.setInt(3, id);
                                    updatePs.setString(4, currentDate);
                                    int rowsUpdated = updatePs.executeUpdate();
                                    if (rowsUpdated > 0) {
                                        out.print("<p class='success'> Out-time marked at " + formattedTime + ". Status: " + status + "</p>");
                                    } else {
                                        out.print("<p class='error'>Error marking out-time.</p>");
                                    }
                                } else {
                                    out.print("<p class='error'>Out-time already marked today!</p>");
                                }
                            } else {
                                out.print("<p class='error'>Please mark In-time first!</p>");
                            }
                        }
                    } catch (SQLException e) {
                        out.print("<p class='error'>SQL Error: " + e.getMessage() + "</p>");
                        e.printStackTrace();
                    }
                }
            %>
        </div>
    </div>
    </div>
</body>
</html>