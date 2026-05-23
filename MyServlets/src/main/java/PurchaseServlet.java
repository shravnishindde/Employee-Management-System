import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
@SuppressWarnings("serial")
public class PurchaseServlet extends HttpServlet{
	
	    public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
	        
	    	res.setContentType("text/html");
	    	PrintWriter out=res.getWriter();
	    	
	    	String [] val=req.getParameterValues("item");
	    	int i,sum1=0;
	    	for(i=0;i<val.length;i++)
	    	{
	    		sum1+=Integer.parseInt(val[i]);
	    	}
	    	HttpSession hs = req.getSession();
	    	hs.setAttribute("shop1", sum1);
	    	res.sendRedirect("book1.html");
}
	}

