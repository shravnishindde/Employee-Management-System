<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>
<%@ page session="true" %>
<%@ include file="dbconnect.jsp" %>

<%
    Integer empId = (Integer) session.getAttribute("eid"); // Directly retrieve as Integer
    response.setContentType("text/plain");

    if (empId != null) { // Check if empId is not null
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String currentDate = sdf.format(new Date());

        try {
            String query = "INSERT INTO Attendence (e_id, Date, status) VALUES (?, ?, 'Present')";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, empId);
            ps.setString(2, currentDate);
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                out.print("Attendance marked successfully for " + currentDate);
            } else {
                out.print("Error: Attendance not marked!");
            }
        } catch (Exception e) {
            out.print("Error: " + e.getMessage());
        }
    } else {
        out.print("Error: Employee not found!");
    }
%>