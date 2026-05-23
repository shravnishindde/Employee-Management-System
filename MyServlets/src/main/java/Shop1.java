import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
public class Shop1 extends HttpServlet{
 public void doGet(HttpServletRequest req,HttpServletResponse res)throws ServletException,IOException
 {
	 String[] bk=req.getParameterValues("book");
	 int i,sum=0;
	 for(i=0;i<bk.length;i++)
	 {
		 sum=sum+Integer.parseInt(bk[i]);
	 }
	 HttpSession hs=req.getSession();
	 hs.setAttribute("sum1",sum);
	 res.sendRedirect("book2.html");
 }
}
