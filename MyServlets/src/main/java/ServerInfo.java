import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
public class ServerInfo extends HttpServlet
{
	public void doGet(HttpServletRequest req,HttpServletResponse res)throws ServletException,IOException
	{
		res.setContentType("text/html");
		PrintWriter out=res.getWriter();
		java.util.Properties p=System.getProperties();
		out.println("<html>");
		out.println("<body bgcolor=cyan>");
		out.println("Server name: "+req.getServerName()+"<br>");
		out.println("Remote Address: "+req.getRemoteAddr()+"<br>");
		out.println("Remote user: "+req.getRemoteUser()+"<br>");
		out.println("Server port: "+req.getServerPort()+"<br>");
		out.println("Remote host: "+req.getRemoteHost()+"<br>");
		out.println("Local name: "+req.getLocalName()+"<br>");
		out.println("Local Address: "+req.getLocalAddr()+"<br>");
		out.println("Servlet name: "+this.getServletName()+"<br>");
		out.println("OS Properties: "+p.getProperty("os.name")+"<br>");
		out.println("</body>");
		out.println("</html>");
	}
}
		

