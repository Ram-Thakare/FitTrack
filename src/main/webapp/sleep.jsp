<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Sleep" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<title>Sleep Tracker</title>

<style>
body {
    background-color: #f5f6f8;
    font-family: Arial, sans-serif;
}

/* COMMON CARD STYLE */
.card {
    background: #fff;
    width: 85%;
    margin: 30px auto;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 0 15px rgba(0,0,0,0.08);
}

h2 {
    margin-bottom: 20px;
}

/* FORM */
.form-row {
    display: flex;
    gap: 15px;
}

.form-row input {
    flex: 1;
    padding: 10px;
    border-radius: 6px;
    border: 1px solid #ccc;
}

.btn {
    margin-top: 15px;
    background: #3498db;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
}

.btn:hover {
    background: #2980b9;
}

/* TABLE */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
}

th, td {
    border: 1px solid #ddd;
    padding: 12px;
    text-align: center;
}

th {
    background: #222;
    color: white;
}

/* STATUS COLORS */
.status-green {
    color: #2ecc71;
    font-weight: bold;
}

.status-orange {
    color: #f39c12;
    font-weight: bold;
}

.status-red {
    color: #e74c3c;
    font-weight: bold;
}

/* DELETE BUTTON */
.delete-btn {
    background: #e74c3c;
    color: white;
    padding: 6px 12px;
    border-radius: 5px;
    text-decoration: none;
    font-size: 14px;
}

.delete-btn:hover {
    background: #c0392b;
}
</style>
</head>

<body>

<%@ include file="navbar.jsp" %>

<!-- ADD SLEEP CARD -->
<div class="card">
    <h2>😴 Add Sleep</h2>

    <form action="SleepServlet" method="post">
        <div class="form-row">
            <input type="number" step="0.1" name="sleep_hours" placeholder="Sleep Hours" required>
            <input type="date" name="sleep_date" required>
        </div>

        <button type="submit" class="btn">Save Sleep</button>
    </form>
</div>

<!-- HISTORY CARD -->
<div class="card">
    <h2>📅 Sleep History</h2>

    <table>
        <tr>
            <th>Sleep Hours</th>
            <th>Date</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

<%
List<Sleep> list = (List<Sleep>) request.getAttribute("sleepList");

if (list != null && !list.isEmpty()) {

    for (Sleep s : list) {

        double hours = s.getSleepHours();

        String status = "";
        String statusClass = "";

        if (hours >= 7) {
            status = "🟢 Good";
            statusClass = "status-green";
        } else if (hours >= 5) {
            status = "🟡 Average";
            statusClass = "status-orange";
        } else {
            status = "🔴 Poor";
            statusClass = "status-red";
        }
%>

        <tr>
            <td><%= hours %> hrs</td>
            <td><%= s.getSleepDate() %></td>

            <td class="<%= statusClass %>">
                <%= status %>
            </td>

            <td>
                <a class="delete-btn"
                   href="SleepServlet?action=delete&id=<%= s.getId() %>"
                   onclick="return confirm('Delete this sleep record?');">
                   Delete
                </a>
            </td>
        </tr>

<%
    }

} else {
%>

        <tr>
            <td colspan="4">No sleep records found</td>
        </tr>

<%
}
%>

    </table>

</div>

</body>
</html>