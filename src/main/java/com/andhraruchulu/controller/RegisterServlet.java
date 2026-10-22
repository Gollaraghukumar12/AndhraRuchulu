
package com.andhraruchulu.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import com.andhraruchulu.daoimpl.UserDAOImpl;
import com.andhraruchulu.model.User;
import com.andhraruchulu.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAOImpl userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/Register.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String userName = request.getParameter("userName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (isBlank(userName) || isBlank(email)
                || isBlank(password) || isBlank(phone)
                || isBlank(address)) {

            showError(request, response,
                    "Please fill in all fields.");
            return;
        }

        if (password.length() < 8
                || password.getBytes(StandardCharsets.UTF_8).length > 72) {

            showError(request, response,
                    "Password must contain at least 8 characters "
                    + "and no more than 72 UTF-8 bytes.");
            return;
        }

        try {
            // Hash the password before sending the user to the DAO.
            String hashedPassword = PasswordUtil.hashPassword(password);

            User user = new User();
            user.setUserName(userName.trim());
            user.setEmail(email.trim());
            user.setPassword(hashedPassword);
            user.setPhone(phone.trim());
            user.setAddress(address.trim());

            boolean registered = userDAO.addUser(user);

            if (registered) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/login?registered=success");
            } else {
                showError(request, response,
                        "Registration failed. The email may already be registered.");
            }

        } catch (Exception e) {
            throw new ServletException("Unable to register the user.", e);
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void showError(HttpServletRequest request,
                           HttpServletResponse response,
                           String message)
            throws ServletException, IOException {

        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/Register.jsp")
               .forward(request, response);
    }
}
