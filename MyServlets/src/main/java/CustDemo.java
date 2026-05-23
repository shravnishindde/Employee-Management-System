import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

public class CustDemo extends HttpServlet {
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String t = req.getParameter("t"); // customer number from request

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/practical", "root", "project04");

            out.println("<html><body>");
            out.println("<h1>Connection established</h1>");

            Statement smt = con.createStatement();
            String q = "SELECT * FROM customer;";
            ResultSet rest = smt.executeQuery(q);

            boolean found = false;

            while (rest.next()) {
                if (rest.getString(1).equals(t)) {
                    out.println("<h3>Customer Details:</h3>");
                    out.println("Customer number : " + rest.getString(1) + "<br>");
                    out.println("Customer name : " + rest.getString(2) + "<br>");
                    out.println("Customer city : " + rest.getString(3) + "<br>");
                    found = true;
                    break;
                }
            }

            if (!found) {
                out.println("<p>No customer found with number: " + t + "</p>");
            }

            out.println("</body></html>");

            // Closing resources
            rest.close();
            smt.close();
            con.close();

        } catch (SQLException e) {
            out.println("<h1>SQL Exception: " + e.getMessage() + "</h1>");
            e.printStackTrace(out);
        } catch (ClassNotFoundException e1) {
            out.println("<h1>Class Not Found Exception: " + e1.getMessage() + "</h1>");
            e1.printStackTrace(out);
        }
    }
}
