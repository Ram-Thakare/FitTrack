<%@ page session="true" %>
<%@ include file="navbar.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Intake" %>

<!DOCTYPE html>
<html>
<head>
<title>Daily Intake</title>

<style>

body{
background:#f5f6f8;
font-family:Arial;
}

.card{
background:#fff;
width:85%;
margin:30px auto;
padding:30px;
border-radius:12px;
box-shadow:0 0 15px rgba(0,0,0,0.08);
}

h2{
margin-bottom:20px;
}

.form-row{
display:flex;
gap:15px;
margin-bottom:20px;
}

.form-row input{
flex:1;
padding:10px;
border-radius:6px;
border:1px solid #ccc;
font-size:15px;
}

.btn{
background:#2ecc71;
color:white;
padding:10px 20px;
border:none;
border-radius:6px;
cursor:pointer;
}

.btn:hover{
background:#27ae60;
}

.delete-btn{
background:#e74c3c;
color:white;
border:none;
padding:6px 12px;
border-radius:5px;
cursor:pointer;
}

.delete-btn:hover{
background:#c0392b;
}

table{
width:100%;
border-collapse:collapse;
margin-top:20px;
}

th,td{
padding:12px;
text-align:center;
border:1px solid #ddd;
}

th{
background:#222;
color:white;
}

.progress-container{
margin-top:15px;
}

.progress-bar{
height:12px;
background:#ddd;
border-radius:10px;
overflow:hidden;
margin-top:5px;
}

.progress{
height:100%;
background:#2ecc71;
}

.status-green{
color:#2ecc71;
font-weight:bold;
}

.status-orange{
color:#f39c12;
font-weight:bold;
}

.status-red{
color:#e74c3c;
font-weight:bold;
}

.message{
margin-top:10px;
font-weight:bold;
}

</style>
</head>

<body>

<%
Integer requiredCaloriesObj = (Integer)request.getAttribute("requiredCalories");
Float requiredWaterObj = (Float)request.getAttribute("requiredWater");

int requiredCalories = (requiredCaloriesObj != null) ? requiredCaloriesObj : 0;
float requiredWater = (requiredWaterObj != null) ? requiredWaterObj : 0;
%>

<!-- ================= FORM ================= -->

<div class="card">

<h2>🥗 Daily Intake</h2>

<form action="IntakeServlet" method="post">

<div class="form-row">
<input type="date" name="intake_date" required>
<input type="number" name="calories" placeholder="Calories Intake" required>
<input type="number" step="0.1" name="water" placeholder="Water Intake (liters)" required>
</div>

<button type="submit" class="btn">Save Intake</button>

</form>

<%
String msg = (String)request.getAttribute("message");
if(msg!=null){
%>

<div class="message"><%=msg%></div>

<% } %>

<!-- ===== REQUIRED STATUS ===== -->

<div class="progress-container">

<p><b>Required Calories:</b> <%=requiredCalories%> kcal</p>

</div>
<br>
<p><b>Required Water:</b> <%= String.format("%.1f", requiredWater) %> L</p>

</div>

</div>

</div>

<!-- ================= HISTORY ================= -->

<div class="card">

<h2>📊 Intake History</h2>

<%
List<Intake> history = (List<Intake>)request.getAttribute("history");

if(history!=null && !history.isEmpty()){
%>

<table>

<tr>
<th>Date</th>
<th>Calories</th>
<th>Water</th>
<th>Status</th>
<th>Action</th>
</tr>

<%
for(Intake intake : history){

int calories = intake.getCalories();
float water = intake.getWaterLiters();

String status="";
String statusClass="";

if(calories>=requiredCalories && water>=requiredWater){
status="🟢 Completed";
statusClass="status-green";
}
else if(calories>=requiredCalories || water>=requiredWater){
status="🟡 Partial";
statusClass="status-orange";
}
else if(calories<requiredCalories || water<requiredWater){
status="🔴 Incomplete";
statusClass="status-red";
}
%>

<tr>

<td><%= intake.getIntakeDate() %></td>

<td>
<%= calories %> / <%= requiredCalories %>
</td>

<td>
<%= String.format("%.1f", water) %> / <%= String.format("%.1f", requiredWater) %> L
</td>

<td class="<%=statusClass%>">
<%=status%>
</td>

<td>

<form action="IntakeServlet" method="post">

<input type="hidden" name="action" value="delete">
<input type="hidden" name="intake_date" value="<%= intake.getIntakeDate() %>">

<button class="delete-btn">Delete</button>

</form>

</td>

</tr>

<%
}
%>

</table>

<%
}else{
%>

<p>No intake records found</p>

<%
}
%>

</div>

</body>
</html>