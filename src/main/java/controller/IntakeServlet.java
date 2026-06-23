package controller;

import db.DBConnection;
import model.HealthCalculator;
import model.Intake;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/IntakeServlet")
public class IntakeServlet extends HttpServlet {

    // ================= LOAD PAGE =================
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try (Connection con = DBConnection.getConnection()) {

            int requiredCalories = 0;
            float requiredWater = 0;

            // ===== LOAD USER DATA =====
            String userSql =
                    "SELECT age,height,weight,gender,activity_level,fitness_goal FROM users WHERE id=?";

            PreparedStatement psUser = con.prepareStatement(userSql);
            psUser.setInt(1, userId);

            ResultSet rsUser = psUser.executeQuery();

            if (rsUser.next()) {

                int age = rsUser.getInt("age");
                double height = rsUser.getDouble("height");
                double weight = rsUser.getDouble("weight");
                String gender = rsUser.getString("gender");
                String activity = rsUser.getString("activity_level");
                String goal = rsUser.getString("fitness_goal");

                int baseCalories =
                        HealthCalculator.getRequiredCalories(weight, height, age, gender, activity);

                if ("muscle gain".equalsIgnoreCase(goal)) {
                    requiredCalories = baseCalories + 500;
                } else if ("weight loss".equalsIgnoreCase(goal)) {
                    requiredCalories = baseCalories - 300;
                } else {
                    requiredCalories = baseCalories;
                }

                requiredWater = HealthCalculator.getRequiredWater(weight);
            }

            request.setAttribute("requiredCalories", requiredCalories);
            request.setAttribute("requiredWater", requiredWater);

            // ===== LOAD INTAKE HISTORY =====

            String sql = "SELECT * FROM intake WHERE user_id=? ORDER BY intake_date DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            List<Intake> intakeList = new ArrayList<>();

            while (rs.next()) {

                Intake intake = new Intake();

                intake.setId(rs.getInt("id"));
                intake.setUserId(rs.getInt("user_id"));
                intake.setIntakeDate(rs.getDate("intake_date"));
                intake.setCalories(rs.getInt("calories"));
                intake.setWaterLiters(rs.getFloat("water_liters"));

                intakeList.add(intake);
            }

            request.setAttribute("history", intakeList);

            RequestDispatcher rd = request.getRequestDispatcher("intake.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("intake.jsp?error=server");
        }
    }

    // ================= INSERT / DELETE =================
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");

        try (Connection con = DBConnection.getConnection()) {

            // ===== DELETE =====
            if ("delete".equals(action)) {

                Date intakeDate = Date.valueOf(request.getParameter("intake_date"));

                String deleteSql = "DELETE FROM intake WHERE user_id=? AND intake_date=?";

                PreparedStatement psDelete = con.prepareStatement(deleteSql);

                psDelete.setInt(1, userId);
                psDelete.setDate(2, intakeDate);

                psDelete.executeUpdate();

                request.setAttribute("message", "Intake deleted successfully!");
            }

            // ===== INSERT =====
            else {

                Date intakeDate = Date.valueOf(request.getParameter("intake_date"));
                int calories = Integer.parseInt(request.getParameter("calories"));
                float water = Float.parseFloat(request.getParameter("water"));

                String checkSql = "SELECT id FROM intake WHERE user_id=? AND intake_date=?";

                PreparedStatement psCheck = con.prepareStatement(checkSql);

                psCheck.setInt(1, userId);
                psCheck.setDate(2, intakeDate);

                ResultSet rs = psCheck.executeQuery();

                if (rs.next()) {

                    request.setAttribute("message", "Intake already added for this date.");

                } else {

                    String insertSql =
                            "INSERT INTO intake(user_id,intake_date,calories,water_liters) VALUES (?,?,?,?)";

                    PreparedStatement psInsert = con.prepareStatement(insertSql);

                    psInsert.setInt(1, userId);
                    psInsert.setDate(2, intakeDate);
                    psInsert.setInt(3, calories);
                    psInsert.setFloat(4, water);

                    psInsert.executeUpdate();

                    request.setAttribute("message", "Daily intake added successfully!");
                }
            }

            doGet(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("intake.jsp?error=server");
        }
    }
}