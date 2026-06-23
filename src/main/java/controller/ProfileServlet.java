package controller;

import db.DBConnection;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    // ================= LOAD PROFILE =================
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT * FROM users WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User();

                user.setId(rs.getInt("id"));
                user.setName(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setHeight(rs.getFloat("height"));
                user.setWeight(rs.getFloat("weight"));
                user.setAge(rs.getInt("age"));
                user.setGender(rs.getString("gender"));
                user.setActivityLevel(rs.getString("activity_level"));
                user.setFitnessGoal(rs.getString("fitness_goal"));
                user.setExperienceLevel(rs.getString("experience_level"));

                request.setAttribute("user", user);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    // ================= UPDATE PROFILE =================
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

            // ================= PASSWORD UPDATE =================
        	if ("password".equals(action)) {

        	    String oldPassword = request.getParameter("old_password");
        	    String newPassword = request.getParameter("new_password");
        	    String confirmPassword = request.getParameter("confirm_password");

        	    // ===== VALIDATIONS =====
        	    if (oldPassword == null || newPassword == null || confirmPassword == null ||
        	        oldPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {

        	        request.setAttribute("message", "All password fields are required.");
        	    }

        	    else if (!newPassword.equals(confirmPassword)) {
        	        request.setAttribute("message", "New password and confirm password do not match.");
        	    }

        	    else {

        	        // ===== CHECK OLD PASSWORD =====
        	        String checkSql = "SELECT password FROM users WHERE id=?";
        	        PreparedStatement psCheck = con.prepareStatement(checkSql);
        	        psCheck.setInt(1, userId);

        	        ResultSet rs = psCheck.executeQuery();

        	        if (rs.next()) {

        	            String dbPassword = rs.getString("password");

        	            if (!dbPassword.equals(oldPassword)) {
        	                request.setAttribute("message", "Old password is incorrect.");
        	            }

        	            else {
        	                // ===== UPDATE PASSWORD =====
        	                String updateSql = "UPDATE users SET password=? WHERE id=?";
        	                PreparedStatement psUpdate = con.prepareStatement(updateSql);

        	                psUpdate.setString(1, newPassword);
        	                psUpdate.setInt(2, userId);

        	                psUpdate.executeUpdate();

        	                request.setAttribute("message", "Password updated successfully!");
        	            }
        	        }
        	    }
        	}

            // ================= PROFILE UPDATE =================
            else {

                String username = request.getParameter("username");
                String email = request.getParameter("email");
                float height = Float.parseFloat(request.getParameter("height"));
                float weight = Float.parseFloat(request.getParameter("weight"));
                int age = Integer.parseInt(request.getParameter("age"));
                String gender = request.getParameter("gender");
                String activity = request.getParameter("activity_level");
                String goal = request.getParameter("fitness_goal");
                String experience = request.getParameter("experience_level");

                String sql = "UPDATE users SET username=?, email=?, height=?, weight=?, age=?, gender=?, activity_level=?, fitness_goal=?, experience_level=? WHERE id=?";

                PreparedStatement ps = con.prepareStatement(sql);

                ps.setString(1, username);
                ps.setString(2, email);
                ps.setFloat(3, height);
                ps.setFloat(4, weight);
                ps.setInt(5, age);
                ps.setString(6, gender);
                ps.setString(7, activity);
                ps.setString(8, goal);
                ps.setString(9, experience);
                ps.setInt(10, userId);

                ps.executeUpdate();

                request.setAttribute("message", "Profile updated successfully!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Something went wrong!");
        }

        doGet(request, response);
    }
}