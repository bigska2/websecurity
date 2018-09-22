<%@ page import="java.sql.*"%>

<html lang="en">

<head>
	<link rel="stylesheet" type="text/css" href="css/table.css">

</head>
<body>

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

			 String lineupQuery = "select * from lineup where userName = '"+username+"'";
		     lineupRs = statement.executeQuery(lineupQuery) ;
%>

	<table border=0 class="user_header">
		<tr>
			<td>
				Welcome <span class="userName"><%=username%></span>!
			</td>
			<td>
	<form class="changeTeamName" method="post">
		<input onfocus="if(this.value == 'Change Team Name'){this.value = '';}" type="text" onblur="if(this.value == ''){this.value='Change Team Name';}" id="name" value="Change Team Name" name="teamName"/>
	</form>	
			</td>
		</tr>
	</table>


	<div class="banner"><img class="banner_center" src="../images/VHT_Header_Football.png"/></div>

<p>
	<table class="demo-table center">
		<thead>
			<tr>
				<th>Team Name</th>
				<th>Points</th>
				<th>Opponent Name</th>
				<th>Opponent Points</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><span class="teamName"><%=curTeamName%></span></td>
				<td><%=curOwnPoints%></td>
				<td><span class="teamName"><%=oppTeamName%></span></td>
				<td><%=curOpponentPoints%></td>
			</tr>
		</tbody>
	</table>
<p>
	<table class="demo-table center">
		<caption class="title">Week 4</caption>
		<thead>
			<tr class="row100 head">
				<th>Player</th>
				<th>Position</th>
				<th>Team</th>
				<th>Status</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<%
				while(lineupRs.next()){
					String helmetImg = "images/"+lineupRs.getString(4)+"-icon.png";
			%>
			<tr class="row100 body">
				<td><%=lineupRs.getString(2)%></td>
				<td><%=lineupRs.getString(3)%></td>
				<td><img class="helmetLogo" src="<%=helmetImg%>"/></td>
				<td><%=lineupRs.getString(5)%></td>
				<td><a href="?player=<%=lineupRs.getString(2)%>">Change Status</a></td>
			</tr>

<%
 	 }
%>

		</tbody>
	</table>
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
