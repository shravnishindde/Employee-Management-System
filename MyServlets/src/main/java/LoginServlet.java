import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
@SuppressWarnings("serial")
public class LoginServlet extends HttpServlet
{
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();
        if(username.equals("aish") && password.equals("12345"))
        {
        	res.sendRedirect("book.html");
        }
        else
        {
        	res.sendRedirect("login.html");
        }
    }
}
        

