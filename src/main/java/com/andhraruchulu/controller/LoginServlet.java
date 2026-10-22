
package com.andhraruchulu.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.andhraruchulu.util.DBConnection;
import com.andhraruchulu.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/Login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null
                || email.trim().isEmpty() || password.isEmpty()) {

            request.setAttribute("errorMessage",
                    "Please enter your email and password.");

            request.getRequestDispatcher("/Login.jsp")
                   .forward(request, response);
            return;
        }

        String sql = "SELECT user_id, user_name, email, password, role "
                   + "FROM users WHERE email = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, email.trim());

            try (ResultSet resultSet = statement.executeQuery()) {

                if (!resultSet.next()
                        || !PasswordUtil.checkPassword(
                                password, resultSet.getString("password"))) {

                    request.setAttribute("errorMessage",
                            "Invalid email or password.");

                    request.getRequestDispatcher("/Login.jsp")
                           .forward(request, response);
                    return;
                }

                int userId = resultSet.getInt("user_id");
                String userName = resultSet.getString("user_name");
                String userEmail = resultSet.getString("email");
                String role = resultSet.getString("role");

                HttpSession oldSession = request.getSession(false);

                if (oldSession != null) {
                    oldSession.invalidate();
                }

                HttpSession session = request.getSession(true);
                session.setAttribute("userId", userId);
                session.setAttribute("userName", userName);
                session.setAttribute("email", userEmail);
                session.setAttribute("role", role);
                session.setMaxInactiveInterval(30 * 60);

                response.sendRedirect(
                        request.getContextPath() + "/restaurants");
            }

        } catch (Exception e) {
            throw new ServletException("Unable to log in.", e);
        }
    }
}
