import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
@SuppressWarnings("serial")
public class Demo extends HttpServlet
{
	  public void doGet(HttpServletRequest req,HttpServletResponse res)throws ServletException,IOException
	  {
		 res.setContentType("text/html");
		 PrintWriter out=res.getWriter();
		 out.println("<html>");
		 out.println("<body bgcolor=pink>");
		 out.println("Hello!");
		 out.println("</body>");
		 out.println("</html>");
	  }
	}


