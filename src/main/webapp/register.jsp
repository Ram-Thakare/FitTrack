<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Register - FitTrack</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: #f4f6f8;
}

.box {
    width: 360px;
    margin: 80px auto;
    background: white;
    padding: 25px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0,0,0,0.1);
}

h2 {
    text-align: center;
    margin-bottom: 20px;
}

input, select {
    width: 100%;
    padding: 8px;
    margin: 8px 0;
    border-radius: 5px;
    border: 1px solid #ccc;
}

button {
    width: 100%;
    padding: 10px;
    background: #27ae60;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 15px;
}

button:hover {
    background: #219150;
}

a {
    text-decoration: none;
    color: #2c3e50;
}
</style>
</head>

<body>

<div class="box">
    <h2>Create Account</h2>

    <form action="RegisterServlet" method="post">

        <input type="text" name="username" placeholder="Username" required>

        <input type="email" name="email" placeholder="Email" required>

        <input type="password" name="password" placeholder="Password" required>

        <!-- Decimal supported -->
        <input type="number" step="0.1" name="height" placeholder="Height (cm)" required>

        <input type="number" step="0.1" name="weight" placeholder="Weight (kg)" required>

        <input type="number" name="age" placeholder="Age" required>

        <select name="gender" required>
            <option value="">Select Gender</option>
            <option value="male">Male</option>
            <option value="female">Female</option>
        </select>

        <!-- MUST match DB column -->
        <select name="activity_level" required>
            <option value="">Activity Level</option>
            <option value="light">Light Activity</option>
            <option value="moderate">Moderate Activity</option>
            <option value="heavy">Heavy Activity</option>
        </select>

        <!-- MUST match DB column -->
        <select name="fitness_goal" required>
            <option value="">Fitness Goal</option>
            <option value="muscle gain">Muscle Gain</option>
            <option value="weight loss">Weight Loss</option>
            <option value="maintain">Maintain</option>
        </select>

        <!-- MUST match DB column -->
        <select name="experience_level" required>
            <option value="">Experience Level</option>
            <option value="Beginner">Beginner</option>
            <option value="Intermediate">Intermediate</option>
            <option value="Advanced">Advanced</option>
        </select>

        <button type="submit">Register</button>
    </form>

    <p style="text-align:center; margin-top:15px;">
        <a href="index.jsp">⬅ Back to Login</a>
    </p>
</div>

</body>
</html>
