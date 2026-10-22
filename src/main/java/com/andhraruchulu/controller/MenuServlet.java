
package com.andhraruchulu.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.andhraruchulu.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String restaurantIdValue = request.getParameter("restaurantId");

        if (restaurantIdValue == null || restaurantIdValue.isBlank()) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Restaurant ID is required."
            );
            return;
        }

        int restaurantId;

        try {
            restaurantId = Integer.parseInt(restaurantIdValue);
        } catch (NumberFormatException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid restaurant ID."
            );
            return;
        }

        if (restaurantId <= 0) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid restaurant ID."
            );
            return;
        }

        List<Map<String, Object>> menuItems = new ArrayList<>();
        String restaurantName = "Restaurant Menu";

        String restaurantSql =
            "SELECT restaurant_name FROM restaurants WHERE restaurant_id = ?";

        String menuSql =
            "SELECT menu_id, restaurant_id, item_name, description, " +
            "price, category, image_path, available " +
            "FROM menus " +
            "WHERE restaurant_id = ? AND available = 1 " +
            "ORDER BY menu_id";

        try (Connection connection = DBConnection.getConnection()) {

            // Get the restaurant name
            try (PreparedStatement ps =
                     connection.prepareStatement(restaurantSql)) {

                ps.setInt(1, restaurantId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Restaurant not found."
                        );
                        return;
                    }

                    restaurantName = rs.getString("restaurant_name");
                }
            }

            // Get menu items for the selected restaurant
            try (PreparedStatement ps =
                     connection.prepareStatement(menuSql)) {

                ps.setInt(1, restaurantId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> item = new LinkedHashMap<>();

                        item.put("menu_id", rs.getInt("menu_id"));
                        item.put("restaurant_id",
                                 rs.getInt("restaurant_id"));
                        item.put("item_name",
                                 rs.getString("item_name"));
                        item.put("description",
                                 rs.getString("description"));
                        item.put("price", rs.getBigDecimal("price"));
                        item.put("category",
                                 rs.getString("category"));
                        item.put("image_path",
                                 rs.getString("image_path"));
                        item.put("available",
                                 rs.getBoolean("available"));

                        menuItems.add(item);
                    }
                }
            }

            request.setAttribute("restaurantId", restaurantId);
            request.setAttribute("restaurantName", restaurantName);
            request.setAttribute("menuItems", menuItems);

            request.getRequestDispatcher("/Menu.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to load the restaurant menu.", e
            );
        }
    }
}
