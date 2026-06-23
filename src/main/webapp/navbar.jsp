<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true" %>
    
<style>
/* RESET */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

/* NAVBAR */
.navbar {
    width: 100%;
    background: #111; /* deep black */
    display: flex;
    justify-content: center;
}

/* CONTAINER */
.nav-container {
    width: 100%;
    max-width: 1200px;
    height: 50px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 20px;
}

/* LEFT SIDE */
.nav-left {
    display: flex;
    gap: 25px;
}

/* LINKS */
.nav-left a {
    color: white;              /* white tabs */
    text-decoration: none;
    font-size: 15px;
    position: relative;
    padding: 5px 0;
    transition: 0.3s;
}

/* 🔥 HOVER = YELLOW */
.nav-left a:hover {
    color: #f1c40f; /* yellow */
}

/* 🔥 UNDERLINE EFFECT */
.nav-left a::after {
    content: "";
    position: absolute;
    width: 0%;
    height: 2px;
    background: #f1c40f;
    left: 0;
    bottom: -5px;
    transition: 0.3s;
}

.nav-left a:hover::after {
    width: 100%;
}

/* RIGHT SIDE */
.nav-right a {
    background: #e74c3c;
    color: white;
    padding: 6px 14px;
    border-radius: 20px;
    text-decoration: none;
    font-size: 14px;
    transition: 0.3s;
}

.nav-right a:hover {
    background: #c0392b;
}

</style>

<div class="navbar">
    <div class="nav-container">

        <div class="nav-left">
            <a href="DashboardServlet" class="active">Dashboard</a>
            <a href="WorkoutServlet">Workout</a>
            <a href="CardioServlet">Cardio</a>
            <a href="IntakeServlet">Daily Intake</a>
            <a href="SleepServlet">Sleep</a>
            <a href="ProfileServlet">Profile</a>
        </div>

        <div class="nav-right">
            <a href="LogoutServlet">Logout</a>
        </div>

    </div>
</div>