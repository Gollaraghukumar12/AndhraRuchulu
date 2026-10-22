
package com.andhraruchulu.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart =
                (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        List<Map<String, Object>> cartItems = new ArrayList<>();
        BigDecimal cartTotal = BigDecimal.ZERO;
        Integer restaurantId = null;

        String sql =
            "SELECT menu_id, restaurant_id, item_name, description, " +
            "price, image_path, available " +
            "FROM menus WHERE menu_id = ?";

        try (Connection connection = DBConnection.getConnection()) {

            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {

                int menuId = entry.getKey();
                int quantity = entry.getValue();

                if (quantity <= 0 || quantity > 99) {
                    continue;
                }

                try (PreparedStatement statement =
                        connection.prepareStatement(sql)) {

                    statement.setInt(1, menuId);

                    try (ResultSet resultSet = statement.executeQuery()) {

                        if (!resultSet.next()) {
                            continue;
                        }

                        int itemRestaurantId =
                                resultSet.getInt("restaurant_id");

                        boolean available =
                                resultSet.getBoolean("available");

                        /*
                         * Prevent checkout from containing items
                         * from multiple restaurants.
                         */
                        if (restaurantId == null) {
                            restaurantId = itemRestaurantId;
                        } else if (restaurantId != itemRestaurantId) {
                            session.setAttribute(
                                "cartMessage",
                                "Your cart contains items from different " +
                                "restaurants. Please order from one " +
                                "restaurant at a time."
                            );

                            response.sendRedirect(
                                request.getContextPath() + "/cart"
                            );
                            return;
                        }

                        BigDecimal price =
                                resultSet.getBigDecimal("price");

                        if (price == null) {
                            price = BigDecimal.ZERO;
                        }

                        BigDecimal subtotal =
                                price.multiply(BigDecimal.valueOf(quantity));

                        Map<String, Object> item = new LinkedHashMap<>();

                        item.put("menu_id", menuId);
                        item.put("restaurant_id", itemRestaurantId);
                        item.put("item_name",
                                resultSet.getString("item_name"));
                        item.put("description",
                                resultSet.getString("description"));
                        item.put("price", price);
                        item.put("image_path",
                                resultSet.getString("image_path"));
                        item.put("available", available);
                        item.put("quantity", quantity);
                        item.put("subtotal", subtotal);

                        cartItems.add(item);

                        if (available) {
                            cartTotal = cartTotal.add(subtotal);
                        }
                    }
                }
            }

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to load checkout details.", e);
        }

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        /*
         * Load the logged-in user's saved delivery address.
         */
        String addressSql =
                "SELECT address FROM users WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(addressSql)) {

            statement.setInt(
                    1,
                    ((Number) session.getAttribute("userId")).intValue()
            );

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    request.setAttribute(
                            "deliveryAddress",
                            resultSet.getString("address")
                    );
                }
            }

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to load delivery address.", e);
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);

        request.getRequestDispatcher("/Checkout.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * Order placement will be implemented separately.
         * For now, the checkout page is opened using GET.
         */
        response.sendRedirect(request.getContextPath() + "/checkout");
    }
}
