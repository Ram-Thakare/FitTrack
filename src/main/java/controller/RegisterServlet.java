package controller;

import db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection con = DBConnection.getConnection()) {

            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            float height = Float.parseFloat(request.getParameter("height"));
            float weight = Float.parseFloat(request.getParameter("weight"));
            int age = Integer.parseInt(request.getParameter("age"));

            String gender = request.getParameter("gender");
            String activityLevel = request.getParameter("activity_level");
            String goal = request.getParameter("fitness_goal");
            String experience = request.getParameter("experience_level");

            String sql =
                "INSERT INTO users " +
                "(username, email, password, height, weight, age, gender, activity_level, fitness_goal, experience_level) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setFloat(4, height);
            ps.setFloat(5, weight);
            ps.setInt(6, age);
            ps.setString(7, gender);
            ps.setString(8, activityLevel);
            ps.setString(9, goal);
            ps.setString(10, experience);

            ps.executeUpdate();

            response.sendRedirect("index.jsp?msg=registered");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=1");
        }
    }
}
