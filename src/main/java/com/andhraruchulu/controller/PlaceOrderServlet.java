
package com.andhraruchulu.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.andhraruchulu.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/place-order")
public class PlaceOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static class OrderItemData {
        int menuId;
        int quantity;
        BigDecimal price;
        BigDecimal subtotal;

        OrderItemData(int menuId, int quantity, BigDecimal price) {
            this.menuId = menuId;
            this.quantity = quantity;
            this.price = price;
            this.subtotal = price.multiply(BigDecimal.valueOf(quantity));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/Login.jsp"
            );
            return;
        }

        int userId;

        try {
            userId = Integer.parseInt(
                session.getAttribute("userId").toString()
            );
        } catch (NumberFormatException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid user session."
            );
            return;
        }

        String deliveryAddress = request.getParameter("deliveryAddress");
        String paymentMethod = request.getParameter("paymentMethod");

        if (deliveryAddress == null || deliveryAddress.isBlank()) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please enter your delivery address."
            );
            return;
        }

        deliveryAddress = deliveryAddress.trim();

        if (paymentMethod == null ||
            (!"COD".equals(paymentMethod) &&
             !"UPI".equals(paymentMethod))) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please select COD or UPI."
            );
            return;
        }

        String cartItemsSql =
            "SELECT ci.menu_id, ci.quantity " +
            "FROM carts c " +
            "JOIN cart_items ci ON c.cart_id = ci.cart_id " +
            "WHERE c.user_id = ?";

        String menuSql =
            "SELECT restaurant_id, price, available " +
            "FROM menus WHERE menu_id = ?";

        String orderSql =
            "INSERT INTO orders " +
            "(user_id, restaurant_id, total_amount, order_status, " +
            "delivery_address, payment_method, payment_status, " +
            "created_at, updated_at) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";

        String orderItemSql =
            "INSERT INTO order_items " +
            "(order_id, menu_id, quantity, price, subtotal, " +
            "created_at, updated_at) " +
            "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";

        String clearCartItemsSql =
            "DELETE ci FROM cart_items ci " +
            "JOIN carts c ON ci.cart_id = c.cart_id " +
            "WHERE c.user_id = ?";

        Connection connection = null;

        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);

            List<OrderItemData> items = new ArrayList<>();
            BigDecimal totalAmount = BigDecimal.ZERO;
            int restaurantId = -1;

            // 1. Read this user's cart and validate menu items.
            try (PreparedStatement cartStatement =
                     connection.prepareStatement(cartItemsSql);
                 PreparedStatement menuStatement =
                     connection.prepareStatement(menuSql)) {

                cartStatement.setInt(1, userId);

                try (ResultSet cartRs = cartStatement.executeQuery()) {
                    while (cartRs.next()) {

                        int menuId = cartRs.getInt("menu_id");
                        int quantity = cartRs.getInt("quantity");

                        if (menuId <= 0 || quantity <= 0) {
                            throw new ServletException(
                                "Invalid menu item or quantity in cart."
                            );
                        }

                        menuStatement.setInt(1, menuId);

                        try (ResultSet menuRs =
                                 menuStatement.executeQuery()) {

                            if (!menuRs.next()) {
                                throw new ServletException(
                                    "A selected menu item no longer exists."
                                );
                            }

                            int itemRestaurantId =
                                menuRs.getInt("restaurant_id");

                            BigDecimal price =
                                menuRs.getBigDecimal("price");

                            boolean available =
                                menuRs.getBoolean("available");

                            if (!available) {
                                throw new ServletException(
                                    "A selected menu item is unavailable."
                                );
                            }

                            if (price == null || price.signum() < 0) {
                                throw new ServletException(
                                    "Invalid price for a menu item."
                                );
                            }

                            if (restaurantId == -1) {
                                restaurantId = itemRestaurantId;
                            } else if (restaurantId != itemRestaurantId) {
                                throw new ServletException(
                                    "Please order from one restaurant at a time."
                                );
                            }

                            OrderItemData item =
                                new OrderItemData(menuId, quantity, price);

                            items.add(item);
                            totalAmount = totalAmount.add(item.subtotal);
                        }
                    }
                }
            }

            if (items.isEmpty()) {
                connection.rollback();

                System.out.println(
                    "DEBUG: No cart items found for user ID: " + userId
                );

                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Your cart is empty in the database. Please check cart data."
                );
                return;
            }

            // 2. Insert the order.
            int orderId;

            try (PreparedStatement orderStatement =
                     connection.prepareStatement(
                         orderSql, Statement.RETURN_GENERATED_KEYS)) {

                orderStatement.setInt(1, userId);
                orderStatement.setInt(2, restaurantId);
                orderStatement.setBigDecimal(3, totalAmount);
                orderStatement.setString(4, "PLACED");
                orderStatement.setString(5, deliveryAddress);
                orderStatement.setString(6, paymentMethod);
                orderStatement.setString(7, "PENDING");

                orderStatement.executeUpdate();

                try (ResultSet keys =
                         orderStatement.getGeneratedKeys()) {

                    if (!keys.next()) {
                        throw new java.sql.SQLException(
                            "Unable to retrieve the new order ID."
                        );
                    }

                    orderId = keys.getInt(1);
                }
            }

            // 3. Insert all order items.
            try (PreparedStatement itemStatement =
                     connection.prepareStatement(orderItemSql)) {

                for (OrderItemData item : items) {
                    itemStatement.setInt(1, orderId);
                    itemStatement.setInt(2, item.menuId);
                    itemStatement.setInt(3, item.quantity);
                    itemStatement.setBigDecimal(4, item.price);
                    itemStatement.setBigDecimal(5, item.subtotal);
                    itemStatement.addBatch();
                }

                itemStatement.executeBatch();
            }

            // 4. Remove cart items only after the order data is inserted.
            try (PreparedStatement clearStatement =
                     connection.prepareStatement(clearCartItemsSql)) {

                clearStatement.setInt(1, userId);
                clearStatement.executeUpdate();
            }

            // 5. Commit the transaction.
            connection.commit();

            session.setAttribute("lastOrderId", orderId);
            session.setAttribute("lastPaymentMethod", paymentMethod);

            response.sendRedirect(
                request.getContextPath() + "/order-success"
            );

        } catch (Exception e) {

            if (connection != null) {
                try {
                    connection.rollback();
                } catch (java.sql.SQLException rollbackError) {
                    e.addSuppressed(rollbackError);
                }
            }

            log("PlaceOrderServlet failed for user ID: " + userId, e);

            if (e instanceof ServletException) {
                throw (ServletException) e;
            }

            throw new ServletException(
                "Unable to process your order. Check the Eclipse Console for details.",
                e
            );

        } finally {

            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (java.sql.SQLException e) {
                    log("Error closing database connection.", e);
                }
            }
        }
    }
}
