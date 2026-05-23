import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
public class Book3 extends HttpServlet
{
  public void doGet(HttpServletRequest req,HttpServletResponse res)throws ServletException,IOException
  {
	  res.setContentType("text/html");
	  PrintWriter out=res.getWriter();
	  String itm2[]=req.getParameterValues("b2");
	  int i,sum2=0;
	  for(i=0;i<itm2.length;i++)
	  {
		  sum2=sum2+Integer.parseInt(itm2[i]);
	  }
	  HttpSession hs=req.getSession();
	  int s=((Integer)hs.getAttribute("sum1")).intValue();
	  out.println("Total for 1st page:"+s);
	  out.println("Total for 2nd page:"+sum2);
	  int tsum=s+sum2;
	  out.println("Total:"+tsum);
  }
}
