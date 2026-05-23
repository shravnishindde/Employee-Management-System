<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    int e_id = Integer.parseInt(request.getParameter("e_id"));
    double baseSalary = Double.parseDouble(request.getParameter("base_salary"));
    double bonus = Double.parseDouble(request.getParameter("bonus"));
    double deduction = Double.parseDouble(request.getParameter("deduction"));
    String payDate = request.getParameter("pay_date");

    PreparedStatement stmt = conn.prepareStatement("INSERT INTO Payroll (e_id, base_salary, bonus, deduction, pay_date) VALUES (?, ?, ?, ?, ?)");
    stmt.setInt(1, e_id);
    stmt.setDouble(2, baseSalary);
    stmt.setDouble(3, bonus);
    stmt.setDouble(4, deduction);
    stmt.setString(5, payDate);

    int rows = stmt.executeUpdate();
    stmt.close();
    conn.close();

    if (rows > 0) {
        response.sendRedirect("setSalary.jsp?success=1");
    } else {
        response.sendRedirect("setSalary.jsp?error=1");
    }
%>