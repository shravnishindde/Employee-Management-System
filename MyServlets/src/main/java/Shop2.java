import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
public class Shop2 extends HttpServlet {
 public void doGet(HttpServletRequest req,HttpServletResponse res)throws ServletException,IOException
 {
	 res.setContentType("text/html");
	 PrintWriter out=res.getWriter();
	 String[] bk=req.getParameterValues("books");
	 int i,sum=0;
	 for(i=0;i<bk.length;i++)
	 {
		 sum=sum+Integer.parseInt(bk[i]);
	 }
	 HttpSession hs=req.getSession();
	 int s=((Integer)hs.getAttribute("sum1")).intValue();
	 int tot=sum+s;
	 out.println("sum"+tot);
 }
}
