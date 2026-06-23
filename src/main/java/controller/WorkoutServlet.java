package controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import db.DBConnection;
import model.Workout;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/WorkoutServlet")
public class WorkoutServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // ✅ NEW PARAMETERS
        String workoutType = request.getParameter("workout_type");
        String workoutName = request.getParameter("workout_name");
        double weight = Double.parseDouble(request.getParameter("weight"));
        int reps = Integer.parseInt(request.getParameter("reps"));
        Date workoutDate = Date.valueOf(request.getParameter("workout_date"));

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO workout (user_id, workout_type, workout_name, weight, reps, workout_date) VALUES (?,?,?,?,?,?)"
            );

            ps.setInt(1, userId);
            ps.setString(2, workoutType);
            ps.setString(3, workoutName);
            ps.setDouble(4, weight);
            ps.setInt(5, reps);
            ps.setDate(6, workoutDate);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("WorkoutServlet");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // 🔥 DELETE LOGIC
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));

            try {
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(
                    "DELETE FROM workout WHERE id=? AND user_id=?"
                );
                ps.setInt(1, id);
                ps.setInt(2, userId);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }

            response.sendRedirect("WorkoutServlet");
            return;
        }

        // 🔁 FETCH WORKOUT LIST
        List<Workout> workoutList = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM workout WHERE user_id=? ORDER BY workout_date DESC"
            );
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Workout w = new Workout();
                w.setId(rs.getInt("id"));
                w.setUserId(rs.getInt("user_id"));
                w.setWorkoutType(rs.getString("workout_type"));
                w.setWorkoutName(rs.getString("workout_name"));
                w.setWeight(rs.getDouble("weight"));
                w.setReps(rs.getInt("reps"));
                w.setWorkoutDate(rs.getDate("workout_date"));

                workoutList.add(w);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("workoutList", workoutList);
        request.getRequestDispatcher("workout.jsp").forward(request, response);
    }
}
