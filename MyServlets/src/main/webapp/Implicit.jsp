<%@page import="java.io.*, java.util.*, java.util.Date, jakarta.servlet.ServletConfig.*, jakarta.servlet.ServletContext" %>"
<html>
<head>
<title>Implicit objects</title>
</head>
<body bgcolor=cyan>
<% Date d=new Date();%>
Implicit objects<br>
<% out.println("current date and time"+d);%>
<br>Header Information <%=request.getHeaderNames()%>
<br>Response <%response.addCookie(new Cookie("aish",String.valueOf(70)));%>
<%Cookie c[]=request.getCookies(); 
int i;
for(i=0;i<c.length;i++)
{
	out.println(c[i].getName());
}
%>
<br>Config:<%=config.getInitParameter("dname")%>
<br>Application:<%=application.getInitParameter("key")%>
<br>session<%=session.getId()%>
<br>page context<%pageContext.setAttribute("user","Aishwarya"); %>
<br><%=pageContext.getAttribute("user")%>
<br>servlet name:<%=request.getRequestURL()%>
</body>
</html>
