import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
public class Book1 extends HttpServlet
{
   public void doGet(HttpServletRequest req,HttpServletResponse res)throws ServletException,IOException
   {
	   res.setContentType("text/html");
	   PrintWriter out=res.getWriter();
	   String sub=req.getParameter("s");
	   Cookie c[]=req.getCookies();
	   int i,f=0;
	   if(c!=null)
	   {
		   out.println("Cookies length:"+c.length);
		   for(i=0;i<c.length;i++)
		   {
			   Cookie co=c[i];
			   out.println("cookie value"+co.getValue()+"<br>cookie name"+co.getName());
			   if(co.getName().equals(sub))
			   {
				   f=1;
				   out.println("Cookie exists");
			   }
			   else
			   {
				   Cookie c2=new Cookie(sub,String.valueOf(100));
				   res.addCookie(c2);
			   }
		   }
	   }
	   if(f==0)
	   {
		   Cookie c3=new Cookie(sub,String.valueOf(100));
		   res.addCookie(c3);
		   out.println("Cookie created");
	   }
   }
}
