import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
public class Shop extends HttpServlet {
  public void doGet(HttpServletRequest req,HttpServletResponse res)throws ServletException,IOException
  {
	  String unm=req.getParameter("user");
	  String pwd=req.getParameter("pass");
	  if(unm.equals("aish") && pwd.equals("12345"))
	  {
		  HttpSession hs=req.getSession(true);
		  res.sendRedirect("book1.html");
	  }
	  else
	  {
		  res.sendRedirect("book.html");
	  }
  }
}
