import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class EmpRegSer extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        // Retrieving form data
        String fn = req.getParameter("fn");
        String mn = req.getParameter("mn");
        String ln = req.getParameter("ln");
        String mail = req.getParameter("ml");
        String no = req.getParameter("phone");
        String date = req.getParameter("dob");
        String gen = req.getParameter("gender");
        String dpt = req.getParameter("department");
        String des = req.getParameter("designation");
        String add = req.getParameter("address");
        String pass = req.getParameter("password");
        String npass = req.getParameter("confirm-password");

        

        try {
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB", "root", "project04");

            // Prepare SQL query
            String query = "INSERT INTO Emp_reg (f_name, m_name, l_name, e_mail, p_no, dob, gender, dept, desig, address, pass, c_pass) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = con.prepareStatement(query);

            // Set parameter values
            pstmt.setString(1, fn);
            pstmt.setString(2, mn);
            pstmt.setString(3, ln);
            pstmt.setString(4, mail);
            pstmt.setString(5, no);
            pstmt.setString(6, date);
            pstmt.setString(7, gen);
            pstmt.setString(8, dpt);
            pstmt.setString(9, des);
            pstmt.setString(10, add);
            pstmt.setString(11, pass);
            pstmt.setString(12, npass);

            // Execute update
            int rowsInserted = pstmt.executeUpdate();

            if (rowsInserted > 0) {
                res.sendRedirect("EmpLogin.html");
            } else {
                out.println("Failed to register. Please try again.");
            }

            // Close resources
            pstmt.close();
            con.close();

        } catch (ClassNotFoundException e) {
            out.println("Database driver not found: " + e.getMessage());
        } catch (SQLException e) {
            out.println("SQL error: " + e.getMessage());
        }
    }
}
