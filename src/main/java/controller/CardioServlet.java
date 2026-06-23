package controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import db.DBConnection;
import model.Cardio;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CardioServlet")
public class CardioServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String type = request.getParameter("cardio_type");
        int duration = Integer.parseInt(request.getParameter("duration"));
        Date date = Date.valueOf(request.getParameter("cardio_date"));

        int calories = 0;

        try (Connection con = DBConnection.getConnection()) {

            /* Get user's weight */
            PreparedStatement psUser = con.prepareStatement(
                    "SELECT weight FROM users WHERE id=?");
            psUser.setInt(1, userId);
            ResultSet rsUser = psUser.executeQuery();

            double weight = 70; // default weight
            if (rsUser.next()) {
                weight = rsUser.getDouble("weight");
            }

            /* MET values */
            double met = 5;

            if (type.equalsIgnoreCase("Walking"))
                met = 3.8;
            else if (type.equalsIgnoreCase("Running"))
                met = 7.5;
            else if (type.equalsIgnoreCase("Cycling"))
                met = 7.0;
            else if (type.equalsIgnoreCase("Skipping"))
                met = 10.0;
            else if (type.equalsIgnoreCase("Swimming"))
                met = 8.0;
            
            /* Calories formula */
            calories = (int) Math.round((met * weight * 3.5 / 200) * duration);

            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO cardio (user_id, cardio_type, duration, calories_burned, cardio_date) VALUES (?,?,?,?,?)");

            ps.setInt(1, userId);
            ps.setString(2, type);
            ps.setInt(3, duration);
            ps.setInt(4, calories);
            ps.setDate(5, date);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("CardioServlet");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        if ("delete".equals(request.getParameter("action"))) {
            int id = Integer.parseInt(request.getParameter("id"));

            try (Connection con = DBConnection.getConnection()) {
                PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM cardio WHERE id=? AND user_id=?");
                ps.setInt(1, id);
                ps.setInt(2, userId);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }

            response.sendRedirect("CardioServlet");
            return;
        }

        List<Cardio> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM cardio WHERE user_id=? ORDER BY cardio_date DESC");
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Cardio c = new Cardio();
                c.setId(rs.getInt("id"));
                c.setCardioType(rs.getString("cardio_type"));
                c.setDuration(rs.getInt("duration"));
                c.setCalories(rs.getInt("calories_burned"));
                c.setCardioDate(rs.getDate("cardio_date"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("cardioList", list);
        request.getRequestDispatcher("cardio.jsp").forward(request, response);
    }
}