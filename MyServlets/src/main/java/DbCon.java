import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DbCon")
public class DbCon extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish the database connection
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB", "root", "project04");

            // Output connection success
            out.println("<h1>Connection established</h1>");

           

            // Close resources
           
          
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
