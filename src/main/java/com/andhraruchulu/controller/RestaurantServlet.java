
package com.andhraruchulu.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.andhraruchulu.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/restaurants")
public class RestaurantServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String SELECT_RESTAURANTS =
            "SELECT restaurant_id, restaurant_name, description, " +
            "address, phone, image_path " +
            "FROM restaurants WHERE active = 1 " +
            "ORDER BY restaurant_id DESC";

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> restaurants = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(SELECT_RESTAURANTS);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {

                Map<String, Object> restaurant = new HashMap<>();

                restaurant.put(
                        "restaurant_id",
                        resultSet.getInt("restaurant_id"));

                restaurant.put(
                        "restaurant_name",
                        resultSet.getString("restaurant_name"));

                restaurant.put(
                        "description",
                        resultSet.getString("description"));

                restaurant.put(
                        "address",
                        resultSet.getString("address"));

                restaurant.put(
                        "phone",
                        resultSet.getString("phone"));

                restaurant.put(
                        "image_path",
                        resultSet.getString("image_path"));

                restaurants.add(restaurant);
            }

            request.setAttribute("restaurants", restaurants);

            request.getRequestDispatcher("/Restaurant.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to load restaurants from the database.", e);
        }
    }
}
