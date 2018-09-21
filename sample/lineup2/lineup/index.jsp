<%@ page import="java.sql.*"%>

<html lang="en">
<head>
	<title>Table V05</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
<!--===============================================================================================-->	
	<link rel="icon" type="image/png" href="images/icons/favicon.ico"/>
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="fonts/font-awesome-4.7.0/css/font-awesome.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/animate/animate.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/select2/select2.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/perfect-scrollbar/perfect-scrollbar.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="css/util.css">
	<link rel="stylesheet" type="text/css" href="css/main.css">
<!--===============================================================================================-->
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

<div class="user_header">
				Welcome <span class="userName"><%=username%></span>!
	<form class="changeTeamName" method="post">
		<input type="textField" name="teamName"/>
	</form>

</div>

	<div class="banner"><img class="center" src="/sample/images/VHT_Header_Football.png"/></div>




	<div class="limiter">

		<div class="container-table100">


				<div class="table100 ver1">
					<div class="table100-firstcol">
						<table>
							<thead>
								<tr class="row100 head">
									<th class="cell100 column1">Team Name</th>
									<th class="cell100 column1">Points</th>
								</tr>
							</thead>
							<tbody>
								<tr class="row100 body">
									<td class="cell100 column1"><span class="teamName"><%=curTeamName%></span></td>
									<td class="cell100 column1"><%=curOwnPoints%></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
&nbsp;<p>
&nbsp;<p>
&nbsp;<p>

			<div class="wrap-table100">



			</div>
			<div class="wrap-table100">
				<div class="table100 ver1">
					<div class="table100-firstcol">
						<table>
							<thead>
								<tr class="row100 head">
									<th class="cell100 column1">Player</th>
								</tr>
							</thead>
							<tbody>
								<%
									while(lineupRs.next()){
								%>
								<tr class="row100 body">
									<td class="cell100 column1"><%=lineupRs.getString(4)%></td>
								</tr>
<%
 	 }
%>
							</tbody>
						</table>
					</div>
					
					<div class="wrap-table100-nextcols js-pscroll">
						<div class="table100-nextcols">
							<table>
								<thead>
									<tr class="row100 head">
										<th class="cell100 column2">Position</th>
										<th class="cell100 column3">Team</th>
										<th class="cell100 column4">Status</th>
										<th class="cell100 column4"></th>
									</tr>
								</thead>
								<tbody>
<%
		     lineupRs = statement.executeQuery(lineupQuery) ;
		     while(lineupRs.next()){
%>
									<tr class="row100 body">
										<td class="cell100 column2"><%=lineupRs.getString(3)%></td>
										<td class="cell100 column3"><img class="helmetLogo" src="<%=lineupRs.getString(5)%>"></a></td>
										<td class="cell100 column4"><%=lineupRs.getString(6)%></td>
										<td class="cell100 column4"><a href="?player=<%=lineupRs.getString(4)%>">Change Status</a></td>
									</tr>
<%
 	 }
%>

								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

<%
  }
  catch(SQLException e) {
    out.println("SQLException caught: " +e.getMessage());
  }finally{
  	con.close();
  }

%>

<!--===============================================================================================-->	
	<script src="vendor/jquery/jquery-3.2.1.min.js"></script>
<!--===============================================================================================-->
	<script src="vendor/bootstrap/js/popper.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.min.js"></script>
<!--===============================================================================================-->
	<script src="vendor/select2/select2.min.js"></script>
<!--===============================================================================================-->
	<script src="vendor/perfect-scrollbar/perfect-scrollbar.min.js"></script>
	<script>
		$('.js-pscroll').each(function(){
			var ps = new PerfectScrollbar(this);

			$(window).on('resize', function(){
				ps.update();
			})

			$(this).on('ps-x-reach-start', function(){
				$(this).parent().find('.table100-firstcol').removeClass('shadow-table100-firstcol');
			});

			$(this).on('ps-scroll-x', function(){
				$(this).parent().find('.table100-firstcol').addClass('shadow-table100-firstcol');
			});

		});

		
		
		
	</script>
<!--===============================================================================================-->
	<script src="js/main.js"></script>

</body>
</html>