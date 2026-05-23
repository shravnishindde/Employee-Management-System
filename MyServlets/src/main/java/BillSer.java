import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
@SuppressWarnings("serial")
public class BillSer extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

    	res.setContentType("text/html");

    	PrintWriter out=res.getWriter();

    	String [] val=req.getParameterValues("item1");

    	int i,sum2=0;

    	for(i=0;i<val.length;i++)

    	{

    		sum2+=Integer.parseInt(val[i]);

    	}

    	HttpSession hs = req.getSession();

    	int sum1=(Integer)(hs.getAttribute("shop1"));

    	out.println("<html>");

    	out.println("<h3>Total 1: "+sum1+"</h3>");

    	out.println("<h3>Total 2: "+sum2+"</h3>");

    	int total=sum1+sum2;

    	out.println("<h3>Total: "+total+"</h3>");

    	

    

 }

}

