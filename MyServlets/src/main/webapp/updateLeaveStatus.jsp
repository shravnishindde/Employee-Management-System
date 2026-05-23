<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    // Ensure Admin is Logged In
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect("EmpLogin.jsp");
        return;
    }

    // Retrieve parameters from form
    String leaveIdStr = request.getParameter("l_id");
    String newStatus = request.getParameter("status");

    if (leaveIdStr != null && newStatus != null) {
        PreparedStatement ps = null, updateLeave = null, updateLeaveBalance = null, 
                          updateUnpaidLeaves = null, markAttendance = null, deleteAttendance = null, 
                          checkBalance = null, insertBalance = null;

        try {
            conn.setAutoCommit(false); // ✅ Begin Transaction

            int l_id = Integer.parseInt(leaveIdStr);

            // Fetch leave details
            ps = conn.prepareStatement("SELECT e_id, leave_type, l_from, l_to, status FROM Leavee WHERE l_id = ?");
            ps.setInt(1, l_id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int e_id = rs.getInt("e_id");
                String leaveType = rs.getString("leave_type");
                Date l_from = rs.getDate("l_from");
                Date l_to = rs.getDate("l_to");
                String prevStatus = rs.getString("status");

                // ✅ Calculate Leave Days
                long diff = l_to.getTime() - l_from.getTime();
                int leaveDays = (int) (diff / (1000 * 60 * 60 * 24)) + 1;

                // ✅ Ensure Leave Balance Entry Exists
                checkBalance = conn.prepareStatement("SELECT * FROM LeaveBalance WHERE e_id = ?");
                checkBalance.setInt(1, e_id);
                ResultSet rsBalance = checkBalance.executeQuery();

                if (!rsBalance.next()) {
                    insertBalance = conn.prepareStatement(
                        "INSERT INTO LeaveBalance (e_id, fixed_leaves, used_leaves, unpaid_leaves) VALUES (?, 5, 0, 0)"
                    );
                    insertBalance.setInt(1, e_id);
                    insertBalance.executeUpdate();
                }
                
                rsBalance.close();
                checkBalance.close();
                if (insertBalance != null) insertBalance.close();

                // ✅ Update Leave Status
                updateLeave = conn.prepareStatement("UPDATE Leavee SET status = ? WHERE l_id = ?");
                updateLeave.setString(1, newStatus);
                updateLeave.setInt(2, l_id);
                int rowsUpdated = updateLeave.executeUpdate();

                if (rowsUpdated == 0) {
                    throw new Exception("Error: Leave status update failed!");
                }

                // ✅ If Leave is Approved
                if (newStatus.equalsIgnoreCase("Approved")) {
                    if (leaveType.equalsIgnoreCase("Medical") || leaveType.equalsIgnoreCase("Paid")) {
                        // Medical is considered Paid Leave
                        updateLeaveBalance = conn.prepareStatement(
                            "UPDATE LeaveBalance SET used_leaves = used_leaves + ? WHERE e_id = ?"
                        );
                        updateLeaveBalance.setInt(1, leaveDays);
                        updateLeaveBalance.setInt(2, e_id);
                        updateLeaveBalance.executeUpdate();
                    } else if (leaveType.equalsIgnoreCase("Unpaid")) {
                        updateUnpaidLeaves = conn.prepareStatement(
                            "UPDATE LeaveBalance SET unpaid_leaves = unpaid_leaves + ? WHERE e_id = ?"
                        );
                        updateUnpaidLeaves.setInt(1, leaveDays);
                        updateUnpaidLeaves.setInt(2, e_id);
                        updateUnpaidLeaves.executeUpdate();
                    }

                    // ✅ Insert into Attendance as "Leave"
                    markAttendance = conn.prepareStatement(
                        "INSERT INTO Attendance (e_id, date, in_time, out_time, status) VALUES (?, ?, '00:00:00', '00:00:00', 'Leave')"
                    );
                    for (int i = 0; i < leaveDays; i++) {
                        java.util.Date leaveDate = new java.util.Date(l_from.getTime() + (i * 86400000L));
                        markAttendance.setInt(1, e_id);
                        markAttendance.setDate(2, new java.sql.Date(leaveDate.getTime()));
                        markAttendance.addBatch();
                    }
                    markAttendance.executeBatch();
                }

                // ❌ If Leave is Rejected (and was previously approved)
                else if (newStatus.equalsIgnoreCase("Rejected") && prevStatus.equalsIgnoreCase("Approved")) {
                    if (leaveType.equalsIgnoreCase("Medical") || leaveType.equalsIgnoreCase("Paid")) {
                        updateLeaveBalance = conn.prepareStatement(
                            "UPDATE LeaveBalance SET used_leaves = used_leaves - ? WHERE e_id = ? AND used_leaves >= ?"
                        );
                        updateLeaveBalance.setInt(1, leaveDays);
                        updateLeaveBalance.setInt(2, e_id);
                        updateLeaveBalance.setInt(3, leaveDays);
                        updateLeaveBalance.executeUpdate();
                    } else if (leaveType.equalsIgnoreCase("Unpaid")) {
                        updateUnpaidLeaves = conn.prepareStatement(
                            "UPDATE LeaveBalance SET unpaid_leaves = unpaid_leaves - ? WHERE e_id = ? AND unpaid_leaves >= ?"
                        );
                        updateUnpaidLeaves.setInt(1, leaveDays);
                        updateUnpaidLeaves.setInt(2, e_id);
                        updateUnpaidLeaves.setInt(3, leaveDays);
                        updateUnpaidLeaves.executeUpdate();
                    }

                    // ❌ Remove Attendance Entries
                    deleteAttendance = conn.prepareStatement("DELETE FROM Attendance WHERE e_id = ? AND date BETWEEN ? AND ?");
                    deleteAttendance.setInt(1, e_id);
                    deleteAttendance.setDate(2, l_from);
                    deleteAttendance.setDate(3, l_to);
                    deleteAttendance.executeUpdate();
                }

                conn.commit(); // ✅ Commit Transaction
                response.sendRedirect("manageLeave.jsp?success=1");
            } else {
                response.sendRedirect("manageLeave.jsp?error=1");
            }

            rs.close();
        } catch (Exception e) {
            if (conn != null) conn.rollback(); // ❌ Rollback on Error
            e.printStackTrace();
            response.sendRedirect("manageLeave.jsp?error=1&msg=" + e.getMessage());
        } finally {
            if (ps != null) ps.close();
            if (updateLeave != null) updateLeave.close();
            if (updateLeaveBalance != null) updateLeaveBalance.close();
            if (updateUnpaidLeaves != null) updateUnpaidLeaves.close();
            if (markAttendance != null) markAttendance.close();
            if (deleteAttendance != null) deleteAttendance.close();
        }
    } else {
        response.sendRedirect("manageLeave.jsp?error=1");
    }
%>