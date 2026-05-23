import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class Customer extends HttpServlet {
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();
        
        String n = req.getParameter("t"); // Fetching parameter from request

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/custDB", "root", "project04");
            Statement smt = con.createStatement();
            String q = "SELECT * FROM customer;";
            ResultSet rs = smt.executeQuery(q);

            boolean recordFound = false;

            out.println("<html><body bgcolor='pink'>");
            while (rs.next()) {
                if (rs.getString(1).equals(n)) {
                    out.println("<h3>ID: " + rs.getString(1) + "</h3>");
                    out.println("<h3>Name: " + rs.getString(2) + "</h3>");
                    out.println("<h3>Gender: " + rs.getString(3) + "</h3>");
                    out.println("<h3>Address: " + rs.getString(4) + "</h3>");
                    recordFound = true;
                    break;
                }
            }

            if (!recordFound) {
                out.println("<h3>No records found</h3>");
            }

            out.println("</body></html>");

            // Closing resources
            rs.close();
            smt.close();
            con.close();
        } catch (SQLException e) {
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        } catch (ClassNotFoundException e) {
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}
