<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.time.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect("EmpLogin.jsp");
        return;
    }

    LocalDate today = LocalDate.now();
    int e_id = Integer.parseInt(request.getParameter("e_id"));

    try {
        // Get the set pay date for this employee
        PreparedStatement payDateStmt = conn.prepareStatement("SELECT pay_date, last_pay_date FROM Payroll WHERE e_id = ?");
        payDateStmt.setInt(1, e_id);
        ResultSet payDateRs = payDateStmt.executeQuery();

        LocalDate payDate = null;
        LocalDate lastPayDate = null;

        if (payDateRs.next()) {
            payDate = payDateRs.getDate("pay_date").toLocalDate();
            lastPayDate = (payDateRs.getDate("last_pay_date") != null) ? payDateRs.getDate("last_pay_date").toLocalDate() : null;
        }
        payDateRs.close();
        payDateStmt.close();

        // Check if salary was already processed for this pay cycle
        if (lastPayDate != null && !lastPayDate.isBefore(payDate)) {
            session.setAttribute("payDateMessage", "Salary has already been generated for this pay cycle.");
            response.sendRedirect("managePayroll.jsp");
            return;
        }

        // Allow salary generation even if today is after the pay date
        if (payDate != null && today.isBefore(payDate)) {
            session.setAttribute("payDateMessage", "Salary can only be generated on or after " + payDate);
            response.sendRedirect("managePayroll.jsp");
            return;
        }

        // Fetch employee payroll details
        PreparedStatement empStmt = conn.prepareStatement("SELECT base_salary, bonus, deduction FROM Payroll WHERE e_id = ?");
        empStmt.setInt(1, e_id);
        ResultSet empRs = empStmt.executeQuery();

        if (empRs.next()) {
            double baseSalary = empRs.getDouble("base_salary");
            double bonus = empRs.getDouble("bonus");
            double deduction = empRs.getDouble("deduction");
            double perDaySalary = baseSalary / 30;

            // Get Unpaid Leaves
            PreparedStatement leaveStmt = conn.prepareStatement("SELECT unpaid_leaves FROM LeaveBalance WHERE e_id = ?");
            leaveStmt.setInt(1, e_id);
            ResultSet leaveRs = leaveStmt.executeQuery();
            int unpaidLeaves = leaveRs.next() ? leaveRs.getInt("unpaid_leaves") : 0;
            leaveRs.close();
            leaveStmt.close();

            // Get Absences
            PreparedStatement attStmt = conn.prepareStatement("SELECT COUNT(*) FROM Attendance WHERE e_id = ? AND status = 'Absent'");
            attStmt.setInt(1, e_id);
            ResultSet attRs = attStmt.executeQuery();
            int absentDays = attRs.next() ? attRs.getInt(1) : 0;
            attRs.close();
            attStmt.close();

            // Calculate Leave Deductions
            double leaveDeductions = (unpaidLeaves + absentDays) * perDaySalary;
            double finalSalary = baseSalary + bonus - leaveDeductions - deduction;

            // Update Payroll Table
            PreparedStatement updatePayroll = conn.prepareStatement(
                "UPDATE Payroll SET last_pay_date = ?, last_pay_amount = ? WHERE e_id = ?"
            );
            updatePayroll.setDate(1, Date.valueOf(today));
            updatePayroll.setDouble(2, finalSalary);
            updatePayroll.setInt(3, e_id);
            updatePayroll.executeUpdate();
            updatePayroll.close();
        }

        empRs.close();
        empStmt.close();
        conn.close();

        session.setAttribute("payDateMessage", "Salary generated successfully!");
        response.sendRedirect("managePayroll.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("payDateMessage", "Error: " + e.getMessage());
        response.sendRedirect("managePayroll.jsp");
    }
%>