<%--
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
--%>

<%@ page import="java.sql.*"%>

<html>
<head>
<title>Sample Application JSP Page</title>


<%--
Context initCtx = new InitialContext();

Context envCtx = (Context) initCtx.lookup("java:comp/env");

DataSource ds = (DataSource) envCtx.lookup("jdbc/mysql");
--%>

</head>
<body bgcolor=white>

<%
  String db = "techcon";
  String user = "mysql"; // assumes database name is the same as username
  ResultSet resultset = null;
  ResultSet resultset2 = null;
  try {
    java.sql.Connection con;
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost/"+db+"?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC", user, "mysql");
    out.println (db+ " database successfully opened.");
    Statement statement = con.createStatement() ;
             //resultset = statement.executeQuery("select * from lineup") ; 
             String teamName = request.getParameter("teamName");
             String updateStr1 = "update team set name = '";
             String updateStr2 = "'";
             //teamName = "hack', points='100";
             //teamName = "<img src=\"javascript:alert(''hello everybody'')\"></img>";
             teamName = "<script src=\"alert.js\"></script>";
             String updateStr = updateStr1 + teamName + updateStr2;

             if(teamName!=null){
	             statement.execute(updateStr);
    		 }         
    		 String query2 = "select name, points from team";
             resultset2 = statement.executeQuery(query2) ;
             resultset2.next(); 

    //con.close();
  }
  catch(SQLException e) {
    out.println("SQLException caught: " +e.getMessage());
  }
%>

<form method="post">
	<input type="textField" name="teamName"/>
</form>

<p>


Team name is <%=resultset2.getString(1) %>, you have <%=resultset2.getString(2)%> points<p>
<%--
        <TABLE BORDER="1">
            <TR>
                <TH>ID</TH>
                <TH>Position</TH>
                <TH>Team</TH>
                <TH>Player</TH>
            </TR>
            <% while(resultset.next()){ %>
            <TR>
                <TD> <%= resultset.getString(1) %></td>
                <TD> <%= resultset.getString(2) %></TD>
                <TD> <%= resultset.getString(3) %></TD>
                <TD> <%= resultset.getString(4) %></TD>
            </TR>
            <% } %>
        </TABLE>
--%>
<!--
 <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
     url="jdbc:mysql://localhost/mysql"
     user="mysql"  password="mysql"/>
 
<sql:query dataSource="${snapshot}" var="result">
select * from lineup
</sql:query>

<c:forEach var="row" items="${result.rows}">
   <c:out value="${row.id}"/><br>
   <c:out value="${row.player}"/><br>
</c:forEach>
-->
<!--
<table border="0">
<tr>
<td align=center>
<img src="images/tomcat.gif">
</td>
<td>
<h1>Sample Application JSP Page</h1>
This is the output of a JSP page that is part of the Hello, World
application.
</td>
</tr>
</table>
-->
Welcome <%=request.getUserPrincipal().getName()%>!
<br>
<br>
Your account # is 55200011
<br>
<br>
Your balance is $5,234
</body>
</html>
