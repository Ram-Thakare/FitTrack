package controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import db.DBConnection;
import model.Sleep;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SleepServlet")
public class SleepServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	HttpSession session = request.getSession(false);
    	if (session == null || session.getAttribute("userId") == null) {
    	    response.sendRedirect("index.jsp");
    	    return;
    	}
    	int userId = (int) session.getAttribute("userId");

        int sleepHours = Integer.parseInt(request.getParameter("sleep_hours"));
        Date sleepDate = Date.valueOf(request.getParameter("sleep_date"));

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO sleep (user_id, sleep_hours, sleep_date) VALUES (?,?,?)");
            ps.setInt(1, userId);
            ps.setInt(2, sleepHours);
            ps.setDate(3, sleepDate);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("SleepServlet");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // DELETE
        if ("delete".equals(request.getParameter("action"))) {
            int id = Integer.parseInt(request.getParameter("id"));

            try (Connection con = DBConnection.getConnection()) {
                PreparedStatement ps = con.prepareStatement(
                    "DELETE FROM sleep WHERE id=? AND user_id=?");
                ps.setInt(1, id);
                ps.setInt(2, userId);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }

            response.sendRedirect("SleepServlet");
            return;
        }

        List<Sleep> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM sleep WHERE user_id=? ORDER BY sleep_date DESC");
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Sleep s = new Sleep();
                s.setId(rs.getInt("id"));
                s.setSleepHours(rs.getInt("sleep_hours"));
                s.setSleepDate(rs.getDate("sleep_date"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("sleepList", list);
        request.getRequestDispatcher("sleep.jsp").forward(request, response);
    }
}
