package controller;

import java.io.IOException;
import java.sql.*;

import db.DBConnection;
import model.HealthCalculator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {
            Connection con = DBConnection.getConnection();

            // Total workouts
            PreparedStatement ps1 = con.prepareStatement(
                "SELECT COUNT(*) FROM workout WHERE user_id=?");
            ps1.setInt(1, userId);
            ResultSet rs1 = ps1.executeQuery();
            rs1.next();
            request.setAttribute("totalWorkouts", rs1.getInt(1));

            // Total calories burned
            PreparedStatement ps3 = con.prepareStatement(
            	    "SELECT IFNULL(SUM(calories_burned),0) FROM cardio WHERE user_id=?");
            	ps3.setInt(1, userId);
            	ResultSet rs3 = ps3.executeQuery();
            	rs3.next();

            	int totalCalories = rs3.getInt(1);

            	request.setAttribute("totalCalories", totalCalories);

            // Avg sleep hours
            PreparedStatement ps4 = con.prepareStatement(
                "SELECT IFNULL(AVG(sleep_hours),0) FROM sleep WHERE user_id=?");
            ps4.setInt(1, userId);
            ResultSet rs4 = ps4.executeQuery();
            rs4.next();
            request.setAttribute("avgSleep", rs4.getDouble(1));

            // Total cardio duration
            PreparedStatement ps5 = con.prepareStatement(
                "SELECT IFNULL(SUM(duration),0) FROM cardio WHERE user_id=?");
            ps5.setInt(1, userId);
            ResultSet rs5 = ps5.executeQuery();
            rs5.next();
            request.setAttribute("totalCardio", rs5.getInt(1));

            // BMI LOGIC 
            PreparedStatement ps6 = con.prepareStatement(
                "SELECT height, weight FROM users WHERE id=?");
            ps6.setInt(1, userId);
            ResultSet rs6 = ps6.executeQuery();

            if (rs6.next()) {
                int height = rs6.getInt("height");
                int weight = rs6.getInt("weight");

                double bmi = HealthCalculator.calculateBMI(height, weight);
                String bmiStatus = HealthCalculator.bmiStatus(bmi);

                request.setAttribute("bmi", String.format("%.2f", bmi));
                request.setAttribute("bmiStatus", bmiStatus);
            }

         // ================= DAILY INTAKE =================
	        PreparedStatement ps7 = con.prepareStatement(
	            "SELECT calories_intake, water_intake_ml FROM daily_intake " +
	            "WHERE user_id=? AND intake_date = CURDATE()");
	        ps7.setInt(1, userId);
	        ResultSet rs7 = ps7.executeQuery();
	
	        int caloriesIntake = 0;
	        int waterIntake = 0;
	
	        if (rs7.next()) {
	            caloriesIntake = rs7.getInt("calories_intake");
	            waterIntake = rs7.getInt("water_intake_ml");
	        }
	
	        request.setAttribute("caloriesIntake", caloriesIntake);
	        request.setAttribute("waterIntake", waterIntake);

	     // ================= USER PROFILE =================
	        PreparedStatement ps8 = con.prepareStatement(
	            "SELECT age, height_cm, weight_kg, gender, activity_level FROM users WHERE id=?");
	        ps8.setInt(1, userId);
	        ResultSet rs8 = ps8.executeQuery();

	        if (rs8.next()) {
	            int age = rs8.getInt("age");
	            double height = rs8.getDouble("height_cm");
	            double weight = rs8.getDouble("weight_kg");
	            String gender = rs8.getString("gender");
	            String activityLevel = rs8.getString("activity_level");

            int requiredCalories = HealthCalculator.getRequiredCalories(
                weight, height, age, gender, activityLevel
            );

            float requiredWater = HealthCalculator.getRequiredWater(weight);

            request.setAttribute("requiredCalories", requiredCalories);
            request.setAttribute("requiredWater", requiredWater);
        }

        } catch (Exception e) {
            e.printStackTrace();
        }
	     
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
