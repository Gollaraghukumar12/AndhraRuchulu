
package com.andhraruchulu.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
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
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrdersServlet extends HttpServlet {

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

        int userId;

        try {
            Object value = session.getAttribute("userId");

            if (value instanceof Number) {
                userId = ((Number) value).intValue();
            } else {
                userId = Integer.parseInt(value.toString());
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Map<String, Object>> orders = new ArrayList<>();

        String ordersSql =
            "SELECT o.order_id, o.restaurant_id, " +
            "r.restaurant_name, o.total_amount, o.order_status, " +
            "o.delivery_address, o.payment_method, " +
            "o.payment_status, o.created_at " +
            "FROM orders o " +
            "LEFT JOIN restaurants r " +
            "ON o.restaurant_id = r.restaurant_id " +
            "WHERE o.user_id = ? " +
            "ORDER BY o.created_at DESC, o.order_id DESC";

        String itemsSql =
            "SELECT oi.menu_id, m.item_name, oi.quantity, " +
            "oi.price, oi.subtotal, m.image_path " +
            "FROM order_items oi " +
            "LEFT JOIN menus m ON oi.menu_id = m.menu_id " +
            "WHERE oi.order_id = ? " +
            "ORDER BY oi.order_item_id";

        try (Connection connection = DBConnection.getConnection()) {

            try (PreparedStatement orderStatement =
                     connection.prepareStatement(ordersSql)) {

                orderStatement.setInt(1, userId);

                try (ResultSet rs = orderStatement.executeQuery()) {

                    while (rs.next()) {

                        Map<String, Object> order = new HashMap<>();

                        int orderId = rs.getInt("order_id");

                        order.put("orderId", orderId);
                        order.put("restaurantId",
                                  rs.getInt("restaurant_id"));
                        order.put("restaurantName",
                                  rs.getString("restaurant_name"));
                        order.put("totalAmount",
                                  rs.getBigDecimal("total_amount"));
                        order.put("orderStatus",
                                  rs.getString("order_status"));
                        order.put("deliveryAddress",
                                  rs.getString("delivery_address"));
                        order.put("paymentMethod",
                                  rs.getString("payment_method"));
                        order.put("paymentStatus",
                                  rs.getString("payment_status"));

                        Timestamp createdAt = rs.getTimestamp("created_at");
                        order.put("createdAt", createdAt);

                        List<Map<String, Object>> orderItems =
                            new ArrayList<>();

                        try (PreparedStatement itemStatement =
                                 connection.prepareStatement(itemsSql)) {

                            itemStatement.setInt(1, orderId);

                            try (ResultSet itemRs =
                                     itemStatement.executeQuery()) {

                                while (itemRs.next()) {

                                    Map<String, Object> item =
                                        new HashMap<>();

                                    item.put("menuId",
                                             itemRs.getInt("menu_id"));
                                    item.put("itemName",
                                             itemRs.getString("item_name"));
                                    item.put("quantity",
                                             itemRs.getInt("quantity"));
                                    item.put("price",
                                             itemRs.getBigDecimal("price"));
                                    item.put("subtotal",
                                             itemRs.getBigDecimal("subtotal"));
                                    item.put("imagePath",
                                             itemRs.getString("image_path"));

                                    orderItems.add(item);
                                }
                            }
                        }

                        order.put("orderItems", orderItems);
                        orders.add(order);
                    }
                }
            }

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load orders and food item images.", e);
        }

        request.setAttribute("orders", orders);

        request.getRequestDispatcher("/Orders.jsp")
               .forward(request, response);
    }
}
