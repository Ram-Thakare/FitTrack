<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.User" %>
<%@ include file="navbar.jsp" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    User user = (User) request.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
<title>Profile - FitTrack</title>

<style>
body {
    background: #f4f6f8;
    font-family: Arial;
}

.card {
    background: white;
    width: 85%;
    margin: 30px auto;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 0 15px rgba(0,0,0,0.08);
}

h2 {
    margin-bottom: 20px;
}

.grid {
    display: grid;
    grid-template-columns: repeat(2,1fr);
    gap: 15px;
}

.item {
    background: #f9f9f9;
    padding: 12px;
    border-radius: 6px;
}

.label {
    font-size: 13px;
    color: #777;
}

.value {
    font-weight: bold;
}

input, select {
    width: 100%;
    padding: 8px;
    border-radius: 6px;
    border: 1px solid #ccc;
}

.btn {
    margin-top: 15px;
    padding: 8px 16px;
    border-radius: 6px;
    border: none;
    cursor: pointer;
}

.edit-btn {
    background: #3498db;
    color: white;
}

.save-btn {
    background: #2ecc71;
    color: white;
}

.cancel-btn {
    background: #e74c3c;
    color: white;
}

.password-btn {
    background: #9b59b6;
    color: white;
}

.message {
    margin-top: 10px;
    color: green;
    font-weight: bold;
}

.password-form {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;
}

.password-form input {
    width: 300px;   
    padding: 10px;
    border-radius: 6px;
    border: 1px solid #ccc;
}

.password-form button {
    width: 200px;
}
</style>

<script>
function enableEdit() {
    document.getElementById("viewMode").style.display = "none";
    document.getElementById("editMode").style.display = "block";
}

function cancelEdit() {
    document.getElementById("viewMode").style.display = "block";
    document.getElementById("editMode").style.display = "none";
}

function togglePassword() {
    var div = document.getElementById("passwordSection");
    div.style.display = (div.style.display === "none") ? "block" : "none";
}
</script>

</head>

<body>

<div class="card">
<h2>👤 My Profile</h2>

<% if(user != null){ %>

<!-- ================= VIEW MODE ================= -->
<div id="viewMode">

<div class="grid">

<div class="item">
<div class="label">Username</div>
<div class="value"><%= user.getName() %></div>
</div>

<div class="item">
<div class="label">Email</div>
<div class="value"><%= user.getEmail() %></div>
</div>

<div class="item">
<div class="label">Height</div>
<div class="value"><%= user.getHeight() %> cm</div>
</div>

<div class="item">
<div class="label">Weight</div>
<div class="value"><%= user.getWeight() %> kg</div>
</div>

<div class="item">
<div class="label">Age</div>
<div class="value"><%= user.getAge() %></div>
</div>

<div class="item">
<div class="label">Gender</div>
<div class="value"><%= user.getGender() %></div>
</div>

<div class="item">
<div class="label">Activity</div>
<div class="value"><%= user.getActivityLevel() %></div>
</div>

<div class="item">
<div class="label">Goal</div>
<div class="value"><%= user.getFitnessGoal() %></div>
</div>

<div class="item">
<div class="label">Experience</div>
<div class="value"><%= user.getExperienceLevel() %></div>
</div>

</div>

<button class="btn edit-btn" onclick="enableEdit()">Edit Profile</button>
<button class="btn password-btn" onclick="togglePassword()">Change Password</button>

</div>


<!-- ================= EDIT MODE ================= -->
<div id="editMode" style="display:none;">

<form action="ProfileServlet" method="post">

<div class="password-column">

<input type="text" name="username" value="<%= user.getName() %>" required>
<input type="email" name="email" value="<%= user.getEmail() %>" required>

<input type="number" step="0.1" name="height" value="<%= user.getHeight() %>" required>
<input type="number" step="0.1" name="weight" value="<%= user.getWeight() %>" required>

<input type="number" name="age" value="<%= user.getAge() %>" required>

<select name="gender">
<option <%= user.getGender().equals("male")?"selected":"" %>>Male</option>
<option <%= user.getGender().equals("female")?"selected":"" %>>Female</option>
</select>

<select name="activity_level">
<option <%= user.getActivityLevel().equals("light")?"selected":"" %>>Light Activity</option>
<option <%= user.getActivityLevel().equals("moderate")?"selected":"" %>>Moderate Activity</option>
<option <%= user.getActivityLevel().equals("heavy")?"selected":"" %>>Heavy Activity</option>
</select>

<select name="fitness_goal">
<option <%= user.getFitnessGoal().equals("maintain")?"selected":"" %>>Maintain</option>
<option <%= user.getFitnessGoal().equals("muscle gain")?"selected":"" %>>Muscle Gain</option>
<option <%= user.getFitnessGoal().equals("weight loss")?"selected":"" %>>Weight Loss</option>
</select>

<select name="experience_level">
<option <%= user.getExperienceLevel().equals("Beginner")?"selected":"" %>>Beginner</option>
<option <%= user.getExperienceLevel().equals("Intermediate")?"selected":"" %>>Intermediate</option>
<option <%= user.getExperienceLevel().equals("Advanced")?"selected":"" %>>Advanced</option>
</select>

</div>

<button type="submit" class="btn save-btn">Save Changes</button>
<button type="button" class="btn cancel-btn" onclick="cancelEdit()">Cancel</button>

</form>

</div>


<!-- ================= PASSWORD ================= -->
<div id="passwordSection" style="display:none; margin-top:20px;">

<form action="ProfileServlet" method="post" class="password-form">

    <input type="hidden" name="action" value="password">

    <input type="password" name="old_password" placeholder="Old Password" required>
    <input type="password" name="new_password" placeholder="New Password" required>
    <input type="password" name="confirm_password" placeholder="Confirm Password" required>

    <button type="submit" class="btn save-btn">Update Password</button>

</form>

</div>

<% } %>

<%
String msg = (String)request.getAttribute("message");
if(msg!=null){
%>
<div class="message"><%=msg%></div>
<% } %>

</div>

</body>
</html>