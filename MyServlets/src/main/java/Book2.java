import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
public class Book2 extends HttpServlet {
 public void doGet(HttpServletRequest req,HttpServletResponse res)throws ServletException,IOException
 {
	 res.setContentType("text/html");
	 PrintWriter out=res.getWriter();
	 String bk[]=req.getParameterValues("b1");
	 int i,sum=0;
	 for(i=0;i<bk.length;i++)
	 {
		  sum=sum+Integer.parseInt(bk[i]);
	 }
	 HttpSession hs=req.getSession();
	 hs.setAttribute("sum1",sum);
	 res.sendRedirect("Shop3.html");
 }
}
