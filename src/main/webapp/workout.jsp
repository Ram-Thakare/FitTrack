<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Workout" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<title>Workout Tracker</title>

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
    gap: 15px;
    margin-bottom: 15px;
}

.form-row input,
.form-row select {
    flex: 1;
}

input, select {
    padding: 8px;
    flex: 1;
}
.form-group {
    flex: 1;
    display: flex;
    flex-direction: column;
}

.form-group label {
    font-size: 14px;
    margin-bottom: 6px;
    font-weight: 600;
}

input, select {
    padding: 10px;
    border-radius: 6px;
    border: 1px solid #ccc;
}

.date-group {
    max-width: 250px;
}

.date-group input {
    width: 100%;
}
	
button {
    background: #2ecc71;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 10px 20px;
    cursor: pointer;
}

button:hover {
    background: #27ae60;
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

<!-- ADD WORKOUT CARD -->
<div class="card">
    <h2>🏋 Workout Tracker</h2>

    <form action="WorkoutServlet" method="post">

    <!-- Row 1 -->
    <div class="form-row">
        <div class="form-group">
            <label>Workout Type</label>
            <select name="workout_type" id="workoutTypeSelect" required>
                <option value="">Select Type</option>
                <option value="Chest">Chest</option>
                <option value="Back">Back</option>
                <option value="Biceps">Biceps</option>
                <option value="Triceps">Triceps</option>
                <option value="Leg">Leg</option>
                <option value="Shoulder">Shoulder</option>
            </select>
        </div>

        <div class="form-group">
            <label>Exercise</label>
            <select id="workoutNameSelect" required>
                <option value="">Select Workout</option>
            </select>

            <input type="text"
                   id="customWorkoutName"
                   placeholder="Enter Custom Workout"
                   style="display:none; margin-top:8px;">
        </div>
    </div>

    <!-- Row 2 -->
    <div class="form-row">
        <div class="form-group">
            <label>Weight (kg)</label>
            <input type="number" name="weight" step="0.1" min="0" required>
        </div>

        <div class="form-group">
            <label>Reps</label>
            <input type="number" name="reps" required>
        </div>
    </div>

    <!-- Row 3 -->
    <div class="form-row">
        <div class="form-group date-group">
		    <label>Workout Date</label>
		    <input type="date" name="workout_date" required>
		</div>
    </div>

    <br>
    <button type="submit">Add Workout</button>
	</form>

    
</div>

<!-- WORKOUT HISTORY CARD -->
<div class="card">
    <h2>📊 Workout History</h2>

<%
List<Workout> list = (List<Workout>) request.getAttribute("workoutList");

String[] types = {"Chest", "Back", "Biceps", "Triceps", "Leg", "Shoulder"};

if (list != null && !list.isEmpty()) {

    for (String type : types) {

        boolean hasData = false;
        for (Workout w : list) {
            if (type.equals(w.getWorkoutType())) {
                hasData = true;
                break;
            }
        }

        if (hasData) {
%>

    <h3 style="margin-top:25px;"><%= type %> Workouts</h3>

    <table>
        <tr>
            <th>Name</th>
            <th>Weight (kg)</th>
            <th>Reps</th>
            <th>Date</th>
            <th>Action</th>
        </tr>

<%
            for (Workout w : list) {
                if (type.equals(w.getWorkoutType())) {
%>
        <tr>
            <td><%= w.getWorkoutName() %></td>
            <td><%= String.format("%.1f", w.getWeight()) %></td>
            <td><%= w.getReps() %></td>
            <td><%= w.getWorkoutDate() %></td>
            <td>
                <a class="delete-btn"
                   href="WorkoutServlet?action=delete&id=<%= w.getId() %>"
                   onclick="return confirm('Are you sure you want to delete this workout?');">
                   Delete
                </a>
            </td>
        </tr>
<%
                }
            }
%>
    </table>

<%
        }
    }

} else {
%>
    <p>No workouts found.</p>
<%
}
%>

</div>

<!-----For Workot selections ---->
<script>	

const workoutTypeSelect = document.getElementById("workoutTypeSelect");
const workoutNameSelect = document.getElementById("workoutNameSelect");
const customInput = document.getElementById("customWorkoutName");

const exercises = {
    Chest: ["Chest Press", "Incline Chest Press", "Decline Press", "Dumbbell Fly", "Cable Crossover", "Push Ups", "Other"],
    Back: ["Lat Pulldown", "Pull Ups", "Seated Row", "Deadlift", "T-Bar Row", "Other"],
    Biceps: ["Barbell Curl", "Dumbbell Curl", "Hammer Curl", "Preacher Curl", "Other"],
    Triceps: ["Tricep Pushdown", "Skull Crushers", "Dips", "Overhead Extension", "Other"],
    Leg: ["Squats", "Leg Press", "Lunges", "Leg Curl", "Calf Raises", "Other"],
    Shoulder: ["Shoulder Press", "Lateral Raise", "Front Raise", "Shrugs", "Arnold Press", "Other"]
};

workoutTypeSelect.addEventListener("change", function () {

    const selectedType = this.value;

    workoutNameSelect.innerHTML = '<option value="">Select Workout</option>';
    customInput.style.display = "none";
    customInput.removeAttribute("name");
    workoutNameSelect.setAttribute("name", "workout_name");

    if (exercises[selectedType]) {
        exercises[selectedType].forEach(function (exercise) {
            const option = document.createElement("option");
            option.value = exercise;
            option.textContent = exercise;
            workoutNameSelect.appendChild(option);
        });
    }
});

workoutNameSelect.addEventListener("change", function () {

    if (this.value === "Other") {
        customInput.style.display = "block";
        customInput.setAttribute("name", "workout_name");
        workoutNameSelect.removeAttribute("name");
    } else {
        customInput.style.display = "none";
        customInput.removeAttribute("name");
        workoutNameSelect.setAttribute("name", "workout_name");
    }

});

</script>

<!-----For Todays date---->
<script>
document.addEventListener("DOMContentLoaded", function() {
    const dateInput = document.querySelector("input[name='workout_date']");
    const today = new Date().toISOString().split("T")[0];
    dateInput.value = today;
});
</script>

</body>
</html>
