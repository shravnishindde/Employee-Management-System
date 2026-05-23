import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.io.*;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB threshold
                 maxFileSize = 10 * 1024 * 1024,   // 10MB max size
                 maxRequestSize = 15 * 1024 * 1024) // 15MB request max size
public class LeaveUploadServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final String UPLOAD_DIR = "uploads";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Database connection
        Connection conn = null;
        PreparedStatement pst = null;

        // Fetching values from the form
        String leaveFrom = request.getParameter("leave_from");
        String leaveTo = request.getParameter("leave_to");
        String leaveType = request.getParameter("leave_type");
        String reason = request.getParameter("reason");

        // Get Employee ID from session
        HttpSession session = request.getSession();
        Integer e_id = (Integer) session.getAttribute("eid");

        if (e_id == null) {
            response.sendRedirect("employeeDashboard.jsp?error=SessionExpired");
            return;
        }

        try {
            // Convert date strings into SQL Date
            java.sql.Date sqlLeaveFrom = java.sql.Date.valueOf(leaveFrom);
            java.sql.Date sqlLeaveTo = java.sql.Date.valueOf(leaveTo);

            // Database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB", "root", "project04");

            // Insert leave request
         // Insert leave request
            String insertLeaveSQL = "INSERT INTO Leavee (e_id, l_from, l_to, leave_type, reason) VALUES (?, ?, ?, ?, ?)";
            pst = conn.prepareStatement(insertLeaveSQL, Statement.RETURN_GENERATED_KEYS);
            pst.setInt(1, e_id);
            pst.setDate(2, sqlLeaveFrom);
            pst.setDate(3, sqlLeaveTo);
            pst.setString(4, leaveType);
            pst.setString(5, reason);

            int affectedRows = pst.executeUpdate();
            int leaveId = 0;

            if (affectedRows > 0) {
                ResultSet rs = pst.getGeneratedKeys();
                if (rs.next()) {
                    leaveId = rs.getInt(1);
                }
            }

         // *✅ Ensure LeaveBalance Entry Exists*
            String checkLeaveBalanceSQL = "SELECT COUNT(*) FROM LeaveBalance WHERE e_id = ?";
            PreparedStatement checkPst = conn.prepareStatement(checkLeaveBalanceSQL);
            checkPst.setInt(1, e_id);
            ResultSet rsCheck = checkPst.executeQuery();
            boolean leaveBalanceExists = false;
            if (rsCheck.next() && rsCheck.getInt(1) > 0) {
                leaveBalanceExists = true;
            }
            rsCheck.close();
            checkPst.close();

            // *✅ Insert LeaveBalance Entry if Not Exists*
            if (!leaveBalanceExists) {
                String insertLeaveBalanceSQL = "INSERT INTO LeaveBalance (e_id, fixed_leaves, used_leaves, unpaid_leaves) VALUES (?, 5, 0, 0)";
                PreparedStatement insertPst = conn.prepareStatement(insertLeaveBalanceSQL);
                insertPst.setInt(1, e_id);
                insertPst.executeUpdate();
                insertPst.close();
            }

            // *✅ Update LeaveBalance Table*
            String updateLeaveBalanceSQL = "UPDATE LeaveBalance SET used_leaves = used_leaves + 1 WHERE e_id = ?";
            PreparedStatement updateLeavePst = conn.prepareStatement(updateLeaveBalanceSQL);
            updateLeavePst.setInt(1, e_id);
            updateLeavePst.executeUpdate();
            updateLeavePst.close();

            // *✅ If Unpaid Leave, Update Unpaid Leaves*
            if ("Unpaid".equals(leaveType)) {
                String updateUnpaidLeaveSQL = "UPDATE LeaveBalance SET unpaid_leaves = unpaid_leaves + 1 WHERE e_id = ?";
                PreparedStatement updateUnpaidLeavePst = conn.prepareStatement(updateUnpaidLeaveSQL);
                updateUnpaidLeavePst.setInt(1, e_id);
                updateUnpaidLeavePst.executeUpdate();
                updateUnpaidLeavePst.close();
            }

            // Handle file upload
            Part filePart = request.getPart("leave_certificate");
            String fileName = null;
            String filePath = null;

            if (filePart != null && filePart.getSize() > 0) {
                fileName = filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                filePath = uploadPath + File.separator + fileName;

                // Save file on the server
                FileOutputStream fos = new FileOutputStream(filePath);
                InputStream fileContent = filePart.getInputStream();

                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = fileContent.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytesRead);
                }
                fos.close();
                fileContent.close();

                // Insert file path into Certificates table
                String certQuery = "INSERT INTO Certificates (e_id, l_id, cert_name, cert_path) VALUES (?, ?, ?, ?)";
                PreparedStatement certPst = conn.prepareStatement(certQuery);
                certPst.setInt(1, e_id);
                certPst.setInt(2, leaveId);
                certPst.setString(3, fileName);
                certPst.setString(4, "uploads/" + fileName);
                certPst.executeUpdate();
            }

            response.sendRedirect("employeeDashboard.jsp?status=success");
;
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("employeeDashboard.jsp?error=" + URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8));

        } finally {
            try {
                if (pst != null) pst.close();
                if (conn != null) conn.close();
            } catch (SQLException ignored) {}
        }
    }
}