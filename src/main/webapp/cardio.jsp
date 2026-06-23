<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Cardio" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<title>Cardio Tracker</title>

<style>
body {
    font-family: Arial;
    background: #f4f6f8;
}

.card {
    width: 85%;
    margin: 30px auto;
    background: white;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 0 15px rgba(0,0,0,0.08);
}

h2 {
    margin-bottom: 20px;
}

.form-row {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

select, input {
    padding: 10px;
    flex: 1;
    border-radius: 6px;
    border: 1px solid #ccc;
}

button {
    background: #9b59b6;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 10px 20px;
    cursor: pointer;
}

button:hover {
    background: #8e44ad;
}

.note {
    font-size: 13px;
    color: #666;
    margin-top: 5px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
}

th, td {
    border: 1px solid #ccc;
    padding: 10px;
    text-align: center;
}

th {
    background: #222;
    color: white;
}

.delete-btn {
    background: #e74c3c;
    color: white;
    padding: 6px 14px;
    border-radius: 6px;
    text-decoration: none;
}

.delete-btn:hover {
    background: #c0392b;
}
</style>
</head>

<body>

<%@ include file="navbar.jsp" %>

<!-- ADD CARDIO CARD -->
<div class="card">
    <h2>🏃 Cardio Tracker</h2>

    <form action="CardioServlet" method="post">
        <div class="form-row">

            <select name="cardio_type" required>
                <option value="">Select Cardio</option>
                <option>Running</option>
                <option>Walking</option>
                <option>Cycling</option>
                <option>Skipping</option>
                <option>Swimming</option>
            </select>

            <input type="number" name="duration" placeholder="Duration (minutes)" required>

            <input type="date" name="cardio_date" required>

        </div>

        <div class="note">
            Calories will be calculated automatically.
        </div>

        <br>
        <button type="submit">Add Cardio</button>
    </form>
</div>


<!-- CARDIO HISTORY CARD -->
<div class="card">
    <h2>📊 Cardio History</h2>

<%
List<Cardio> list = (List<Cardio>) request.getAttribute("cardioList");

if (list != null && !list.isEmpty()) {
%>

    <table>
        <tr>
            <th>Type</th>
            <th>Duration</th>
            <th>Calories</th>
            <th>Date</th>
            <th>Action</th>
        </tr>

<%
    for (Cardio c : list) {
%>
        <tr>
            <td><%= c.getCardioType() %></td>
            <td><%= c.getDuration() %> min</td>
            <td><%= c.getCalories() %></td>
            <td><%= c.getCardioDate() %></td>
            <td>
                <a class="delete-btn"
                   href="CardioServlet?action=delete&id=<%= c.getId() %>"
                   onclick="return confirm('Delete this cardio entry?');">
                   Delete
                </a>
            </td>
        </tr>
<%
    }
%>

    </table>

<%
} else {
%>

    <p>No cardio records found.</p>

<%
}
%>

</div>

</body>
</html>