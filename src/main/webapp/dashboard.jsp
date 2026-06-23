<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true" %>

<%
    // 🔐 Session validation
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FitTrack Dashboard</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
        }

        .container {
            width: 90%;
            margin: 30px auto;
        }

        h2 {
            margin-bottom: 20px;
        }

        .cards {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .card {
            flex: 1;
            min-width: 200px;
            padding: 20px;
            border-radius: 10px;
            color: white;
            font-size: 18px;
        }

        .workout { background: #2c3e50; }
        .calories { background: #e74c3c; }
        .sleep { background: #3498db; }
        .cardio { background: #2ecc71; }

        .value {
            font-size: 32px;
            font-weight: bold;
            margin-top: 10px;
        }

        .links {
            margin-top: 40px;
        }

        .links a {
            display: inline-block;
            margin-right: 20px;
            text-decoration: none;
            font-size: 18px;
            color: #007bff;
        }

        .links a:hover {
            text-decoration: underline;
        }
        .bmi {
    		background: #9b59b6;
		}
		        
    </style>
</head>

<body>

    <%@ include file="navbar.jsp" %>

    <div class="container">

        <h2>Welcome, <%= session.getAttribute("username") %> 👋</h2>

        <!-- SUMMARY CARDS -->
        <div class="cards">

            <div class="card workout">
                🏋 Workouts
                <div class="value">
                    <%= request.getAttribute("totalWorkouts") != null ? request.getAttribute("totalWorkouts") : 0 %>
                </div>
            </div>

            <div class="card calories">
                🔥 Calories Burned
                <div class="value">
                    <%= request.getAttribute("totalCalories") != null ? request.getAttribute("totalCalories") : 0 %>
                </div>
            </div>

            <div class="card sleep">
                😴 Avg Sleep (hrs)
                <div class="value">
                    <%
                        Object avgSleep = request.getAttribute("avgSleep");
                        if (avgSleep != null) {
                            out.print(String.format("%.1f", avgSleep));
                        } else {
                            out.print("0.0");
                        }
                    %>
                </div>
            </div>

            <div class="card cardio">
                ❤️ Cardio (min)
                <div class="value">
                    <%= request.getAttribute("totalCardio") != null ? request.getAttribute("totalCardio") : 0 %>
                </div>
            </div>
			<div class="card bmi">
			    ⚖️ BMI
			    <div class="value">
			        <%= request.getAttribute("bmi") != null ? request.getAttribute("bmi") : "0.0" %>
			    </div>
			    <div style="font-size:14px;margin-top:5px;">
			        <%= request.getAttribute("bmiStatus") != null ? request.getAttribute("bmiStatus") : "" %>
			    </div>
			</div>	
			
        </div>
        
    </div>

</body>
</html>
