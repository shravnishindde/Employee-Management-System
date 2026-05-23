<%@ page import="java.io.*,java.sql.*,java.util.*" %>
<html>
	<head>
		<title>Patient details</title>
	</head>
		<body bgcolor="lightblue">
			<table border='2'>
				<tr><th>Patient no</th><th>Patient name</th><th>Patient address</th><th>Patient age</th><th>Patient disease</th></tr>
				<%
				 try{
					 Class.forName("com.mysql.cj.jdbc.Driver");
			            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/practical", "root", "project04");

				   Statement smt=con.createStatement();
                   String q="select * from pat;";
				   ResultSet rs=smt.executeQuery(q);
				   while(rs.next())
				   {
				      out.println("<tr><td>"+rs.getString(1)+"</td><td>"+rs.getString(2)+"</td><td>"+rs.getString(3)+"</td><td>"+rs.getString(4)+"</td><td>"+rs.getString(5)+"</td></tr>");
				   }
				   }catch(SQLException e)
				   {
				     out.println(e.getMessage());
				   }catch(ClassNotFoundException e1)
				   {
				    out.println(e1.getMessage());
				   }
				   %>

                    </table>
	</body>
</html>
