<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.math.BigDecimal, java.util.*" %>
<%@ include file="dbconnect.jsp" %>
<%
int id = -1;
String name=null;
String mail = (String) session.getAttribute("employeeEmail");
String action = request.getParameter("action");

if (mail == null || mail.trim().isEmpty()) {
	 response.sendRedirect("EmpDash.html?error=SessionExpired");
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

<html>
<head>
    <title>Payroll Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
    .chart-container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 20px;
            background-color:white;
        }

        .chart-box {
            width: 45%;
            min-width: 300px;
            max-width: 500px;
        }
     /* Table */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    background: #f0f6ff;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

th, td {
    border: 1px solid #d0e2ff;
    padding: 12px;
    text-align: center;
    font-size: 16px;
    color: #1a1a2e;
}

th {
    background: linear-gradient(to right, #5b9df9, #8e74f9);
    color: #ffffff;
    font-weight: 600;
}

td {
    background: #eaf0fa;
}

tr:nth-child(even) td {
    background: #dce9f9;
}

tr:hover td {
    background: rgba(91, 157, 249, 0.2);
    transition: 0.3s ease-in-out;
}

/* Buttons */
.button-group button {
    padding: 12px 25px;
    margin-right: 15px;
    background: linear-gradient(135deg, #5b9df9, #8e74f9);
    border: none;
    color: white;
    border-radius: 25px;
    cursor: pointer;
    font-size: 16px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    transition: all 0.4s ease;
}

.button-group button:hover {
    background: linear-gradient(135deg, #8e74f9, #5b9df9);
    transform: translateY(-2px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}

        }
    </style>
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
         <div class="welcome-text">Welcome, <%= name%></div>
    </div>

    <!-- Main Content -->
    <div class="main">
        <div class="glass-card">
            <h2>Dashboard</h2><br>
            <div class="button-group">
                <button onclick="showSection('salarySection')">View Salary</button>
                <button onclick="showSection('historySection')">View History</button>
            </div>

            <!-- Salary Table -->
            <div id="salarySection" style="display: none;">
                <%
                    Integer e_id = (Integer) session.getAttribute("eid");
                    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM Payroll WHERE e_id = ?");
                    stmt.setInt(1, e_id);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        BigDecimal baseSalary = rs.getBigDecimal("base_salary");
                        BigDecimal bonus = rs.getBigDecimal("bonus");
                        BigDecimal deduction = rs.getBigDecimal("deduction");
                        String payDate = rs.getString("pay_date");
                        String lastPayDate = rs.getString("last_pay_date");
                        BigDecimal lastPayAmount = rs.getBigDecimal("last_pay_amount");
                %>
                <table>
                    <tr>
                        <th>Base Salary</th>
                        <th>Bonus</th>
                        <th>Deductions</th>
                        <th>Pay Date</th>
                        <th>Last Pay Date</th>
                        <th>Last Pay Amount</th>
                    </tr>
                    <tr>
                        <td><%= (baseSalary != null) ? baseSalary : "N/A" %></td>
                        <td><%= (bonus != null) ? bonus : "N/A" %></td>
                        <td><%= (deduction != null) ? deduction : "N/A" %></td>
                        <td><%= (payDate != null) ? payDate : "N/A" %></td>
                        <td><%= (lastPayDate != null) ? lastPayDate : "N/A" %></td>
                        <td><%= (lastPayAmount != null) ? lastPayAmount : "N/A" %></td>
                    </tr>
                </table>
                <% } %>
            </div>

            <!-- Salary History Chart -->
            <div id="historySection" style="display: none;">
               <%
    Map<String, Integer> attendanceData = new LinkedHashMap<>();
    int presentDays = 0, halfDays = 0;

    if (e_id != null) {
        try {
            String query = "SELECT date, HOUR(total_hours) AS hours, status FROM Attendance WHERE e_id = ? ORDER BY date";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, e_id);
            ResultSet rs2 = ps.executeQuery();
            
            while (rs2.next()) {
                String date = rs2.getString("date");
                int hours = rs2.getInt("hours");
                String status = rs2.getString("status");

                if (status.equals("Present")) {
                    attendanceData.put(date, hours);
                    presentDays++;
                } else if (status.equals("Half-day")) {
                    attendanceData.put(date, hours);
                    halfDays++;
                } else {
                    attendanceData.put(date, 0); // No hours if absent or on leave
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
               
                
                <div class="chart-container">
                    <div class="chart-box">
                        <canvas id="barChart"></canvas>
                    </div>
                    <div class="chart-box">
                        <canvas id="pieChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

<script>
// Toggle function
function showSection(sectionId) {
    document.getElementById('salarySection').style.display = 'none';
    document.getElementById('historySection').style.display = 'none';
    document.getElementById(sectionId).style.display = 'block';
}

// Charts Data
var attendanceLabels = [<%
    boolean first1 = true;
    for (String date : attendanceData.keySet()) {
        if (!first1) out.print(", ");
        out.print("\"" + date + "\"");
        first1 = false;
    }
%>];

var attendanceValues = [<%
    boolean first2 = true;
    for (Integer hours : attendanceData.values()) {
        if (!first2) out.print(", ");
        out.print(hours);
        first2 = false;
    }
%>];


var presentDays = <%= presentDays %>;
var halfDays = <%= halfDays %>;

// Bar Chart
function renderCharts() {
    var ctxBar = document.getElementById('barChart').getContext('2d');
    var ctxPie = document.getElementById('pieChart').getContext('2d');

    new Chart(ctxBar, {
        type: 'bar',
        data: {
            labels: attendanceLabels,
            datasets: [{
                label: 'Working Hours',
                data: attendanceValues,
                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            }]
        },
        options: { responsive: true, maintainAspectRatio: false }
    });

    new Chart(ctxPie, {
        type: 'pie',
        data: {
            labels: ['Present', 'Half Day'],
            datasets: [{
                data: [presentDays, halfDays],
                backgroundColor: ['#4CAF50', '#FFC107']
            }]
        },
        options: { responsive: true, maintainAspectRatio: false }
    });
}

// Ensure charts are rendered when section is shown
function showSection(sectionId) {
    document.getElementById('salarySection').style.display = 'none';
    document.getElementById('historySection').style.display = 'none';
    document.getElementById(sectionId).style.display = 'block';

    if (sectionId === 'historySection') {
        setTimeout(renderCharts, 500); // Delay rendering to ensure visibility
    }
}

</script>

</body>
</html>