<%@page import="java.io.*,java.sql.*" %>
<html>
<head><title>Patient details</title></head>
<body>
<table border='2'>
<tr><th>Patient no</th><th>Patient name</th><th>Patient address</th><th>Patient Disease</th></tr>
<%
try
{
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/practical","root","project04");
	Statement smt=con.createStatement();
	ResultSet rs;
	String q="Select * from pat;";
	rs=smt.executeQuery(q);
	while(rs.next())
	{
		out.println("<tr><th>"+rs.getString(1)+"</th><th>"+rs.getString(2)+"</th><th>"+rs.getString(3)+"</th><th>"+rs.getString(4)+"</th></tr>");
	}
}catch(SQLException e)
{
	System.out.println(e.getMessage());
}catch(ClassNotFoundException e1)
{
	System.out.println(e1.getMessage());
}
%>
</table>
</body>
</html>