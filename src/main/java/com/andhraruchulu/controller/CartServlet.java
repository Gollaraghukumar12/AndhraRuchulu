
package com.andhraruchulu.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
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

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int MAX_QUANTITY = 99;

    // Display the cart using data saved in MySQL.
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = getUserId(session);

        List<Map<String, Object>> cartItems = new ArrayList<>();
        Map<Integer, Integer> cart = new HashMap<>();
        BigDecimal cartTotal = BigDecimal.ZERO;

        String sql =
            "SELECT ci.menu_id, ci.quantity, m.restaurant_id, " +
            "m.item_name, m.description, m.price, m.image_path, " +
            "m.available " +
            "FROM carts c " +
            "JOIN cart_items ci ON c.cart_id = ci.cart_id " +
            "JOIN menus m ON ci.menu_id = m.menu_id " +
            "WHERE c.user_id = ? " +
            "ORDER BY ci.cart_item_id";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            try (ResultSet rs = statement.executeQuery()) {

                while (rs.next()) {

                    int menuId = rs.getInt("menu_id");
                    int quantity = rs.getInt("quantity");
                    BigDecimal price = rs.getBigDecimal("price");
                    boolean available = rs.getBoolean("available");

                    if (quantity < 1 || quantity > MAX_QUANTITY
                            || price == null) {
                        continue;
                    }

                    BigDecimal subtotal = price.multiply(
                        BigDecimal.valueOf(quantity));

                    Map<String, Object> item = new HashMap<>();

                    item.put("menu_id", menuId);
                    item.put("restaurant_id",
                             rs.getInt("restaurant_id"));
                    item.put("item_name", rs.getString("item_name"));
                    item.put("description", rs.getString("description"));
                    item.put("price", price);
                    item.put("image_path", rs.getString("image_path"));
                    item.put("available", available);
                    item.put("quantity", quantity);
                    item.put("subtotal", subtotal);

                    cartItems.add(item);
                    cart.put(menuId, quantity);

                    if (available) {
                        cartTotal = cartTotal.add(subtotal);
                    }
                }
            }

        } catch (Exception e) {
            throw new ServletException("Unable to load cart items.", e);
        }

        session.setAttribute("cart", cart);

        if (cart.isEmpty()) {
            session.removeAttribute("cartMessage");
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);

        request.getRequestDispatcher("/Cart.jsp")
               .forward(request, response);
    }

    // Add, update, and remove items in MySQL.
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = getUserId(session);
        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        try (Connection connection = DBConnection.getConnection()) {

            connection.setAutoCommit(false);

            try {
                int cartId = getOrCreateCartId(connection, userId);

                Map<Integer, Integer> cart =
                    loadCart(connection, cartId);

                switch (action) {

                    case "add": {
                        int menuId = Integer.parseInt(
                            request.getParameter("menuId"));

                        int requestedRestaurantId = Integer.parseInt(
                            request.getParameter("restaurantId"));

                        if (menuId <= 0 || requestedRestaurantId <= 0) {
                            throw new IllegalArgumentException(
                                "Invalid food item.");
                        }

                        MenuInfo menu = getMenuInfo(connection, menuId);

                        if (menu == null || !menu.available
                                || menu.restaurantId != requestedRestaurantId) {
                            session.setAttribute(
                                "cartMessage",
                                "This food item is no longer available.");
                            connection.rollback();
                            response.sendRedirect(
                                request.getContextPath() + "/restaurants");
                            return;
                        }

                        Integer currentRestaurantId =
                            getCartRestaurantId(connection, cart);

                        if (currentRestaurantId != null
                                && currentRestaurantId != menu.restaurantId) {
                            session.setAttribute(
                                "cartMessage",
                                "You can order from only one restaurant " +
                                "at a time. Please clear your cart first.");
                            connection.rollback();
                            response.sendRedirect(
                                request.getContextPath()
                                + "/menu?restaurantId="
                                + requestedRestaurantId);
                            return;
                        }

                        int currentQuantity =
                            cart.getOrDefault(menuId, 0);

                        if (currentQuantity >= MAX_QUANTITY) {
                            session.setAttribute(
                                "cartMessage",
                                "Maximum quantity is " + MAX_QUANTITY +
                                " for one item.");
                        } else {
                            saveCartItem(
                                connection, cartId, menuId,
                                currentQuantity + 1, menu.price);

                            session.removeAttribute("cartMessage");
                        }
                        break;
                    }

                    case "update": {
                        int menuId = Integer.parseInt(
                            request.getParameter("menuId"));

                        int quantity = Integer.parseInt(
                            request.getParameter("quantity"));

                        if (menuId <= 0 || quantity < 0
                                || quantity > MAX_QUANTITY) {
                            throw new IllegalArgumentException(
                                "Invalid quantity.");
                        }

                        if (cart.containsKey(menuId)) {
                            if (quantity == 0) {
                                deleteCartItem(connection, cartId, menuId);
                            } else {
                                MenuInfo menu =
                                    getMenuInfo(connection, menuId);

                                if (menu == null) {
                                    throw new IllegalArgumentException(
                                        "Food item no longer exists.");
                                }

                                saveCartItem(
                                    connection, cartId, menuId,
                                    quantity, menu.price);
                            }
                        }
                        break;
                    }

                    case "remove": {
                        int menuId = Integer.parseInt(
                            request.getParameter("menuId"));

                        if (menuId <= 0) {
                            throw new IllegalArgumentException(
                                "Invalid food item.");
                        }

                        deleteCartItem(connection, cartId, menuId);
                        break;
                    }

                    default:
                        throw new IllegalArgumentException(
                            "Unknown cart action.");
                }

                connection.commit();

                // Keep the existing session cart synchronized.
                session.setAttribute(
                    "cart", loadCart(connection, cartId));

                if (((Map<?, ?>) session.getAttribute("cart")).isEmpty()) {
                    session.removeAttribute("cartMessage");
                }

            } catch (Exception e) {
                try {
                    connection.rollback();
                } catch (Exception rollbackError) {
                    e.addSuppressed(rollbackError);
                }
                throw e;
            } finally {
                try {
                    connection.setAutoCommit(true);
                } catch (Exception ignored) {
                    // Connection is closed by try-with-resources.
                }
            }

            response.sendRedirect(request.getContextPath() + "/cart");

        } catch (NumberFormatException e) {
            session.setAttribute(
                "cartMessage", "Invalid cart request. Please try again.");
            response.sendRedirect(request.getContextPath() + "/cart");

        } catch (IllegalArgumentException e) {
            session.setAttribute("cartMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cart");

        } catch (Exception e) {
            throw new ServletException(
                "Unable to update the cart in the database.", e);
        }
    }

    private int getUserId(HttpSession session)
            throws ServletException {

        try {
            Object value = session.getAttribute("userId");

            if (value instanceof Number) {
                return ((Number) value).intValue();
            }

            return Integer.parseInt(value.toString());

        } catch (Exception e) {
            throw new ServletException("Invalid user session.", e);
        }
    }

    private int getOrCreateCartId(Connection connection, int userId)
            throws Exception {

        String selectSql =
            "SELECT cart_id FROM carts WHERE user_id = ? LIMIT 1";

        try (PreparedStatement ps =
                 connection.prepareStatement(selectSql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("cart_id");
                }
            }
        }

        String insertSql =
            "INSERT INTO carts (user_id, created_at, updated_at) " +
            "VALUES (?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";

        try (PreparedStatement ps = connection.prepareStatement(
                insertSql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, userId);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }

        throw new java.sql.SQLException("Unable to create cart.");
    }

    private Map<Integer, Integer> loadCart(
            Connection connection, int cartId) throws Exception {

        Map<Integer, Integer> cart = new HashMap<>();

        String sql =
            "SELECT menu_id, quantity FROM cart_items WHERE cart_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, cartId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cart.put(
                        rs.getInt("menu_id"),
                        rs.getInt("quantity"));
                }
            }
        }

        return cart;
    }

    private MenuInfo getMenuInfo(
            Connection connection, int menuId) throws Exception {

        String sql =
            "SELECT restaurant_id, price, available " +
            "FROM menus WHERE menu_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, menuId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new MenuInfo(
                        rs.getInt("restaurant_id"),
                        rs.getBigDecimal("price"),
                        rs.getBoolean("available"));
                }
            }
        }

        return null;
    }

    private Integer getCartRestaurantId(
            Connection connection,
            Map<Integer, Integer> cart) throws Exception {

        Integer restaurantId = null;

        for (Integer menuId : cart.keySet()) {
            MenuInfo menu = getMenuInfo(connection, menuId);

            if (menu == null) {
                continue;
            }

            if (restaurantId == null) {
                restaurantId = menu.restaurantId;
            } else if (restaurantId != menu.restaurantId) {
                // Existing cart contains items from multiple restaurants.
                return -1;
            }
        }

        return restaurantId;
    }

    private void saveCartItem(
            Connection connection,
            int cartId,
            int menuId,
            int quantity,
            BigDecimal price) throws Exception {

        String selectSql =
            "SELECT cart_item_id FROM cart_items " +
            "WHERE cart_id = ? AND menu_id = ?";

        Integer cartItemId = null;

        try (PreparedStatement ps = connection.prepareStatement(selectSql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, menuId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cartItemId = rs.getInt("cart_item_id");
                }
            }
        }

        if (cartItemId != null) {
            String updateSql =
                "UPDATE cart_items SET quantity = ?, price = ?, " +
                "updated_at = CURRENT_TIMESTAMP " +
                "WHERE cart_item_id = ?";

            try (PreparedStatement ps =
                     connection.prepareStatement(updateSql)) {
                ps.setInt(1, quantity);
                ps.setBigDecimal(2, price);
                ps.setInt(3, cartItemId);
                ps.executeUpdate();
            }

        } else {
            String insertSql =
                "INSERT INTO cart_items " +
                "(cart_id, menu_id, quantity, price, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";

            try (PreparedStatement ps =
                     connection.prepareStatement(insertSql)) {
                ps.setInt(1, cartId);
                ps.setInt(2, menuId);
                ps.setInt(3, quantity);
                ps.setBigDecimal(4, price);
                ps.executeUpdate();
            }
        }

        try (PreparedStatement ps = connection.prepareStatement(
                "UPDATE carts SET updated_at = CURRENT_TIMESTAMP " +
                "WHERE cart_id = ?")) {
            ps.setInt(1, cartId);
            ps.executeUpdate();
        }
    }

    private void deleteCartItem(
            Connection connection, int cartId, int menuId)
            throws Exception {

        String sql =
            "DELETE FROM cart_items WHERE cart_id = ? AND menu_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, menuId);
            ps.executeUpdate();
        }
    }

    private static class MenuInfo {
        private final int restaurantId;
        private final BigDecimal price;
        private final boolean available;

        private MenuInfo(int restaurantId,
                         BigDecimal price,
                         boolean available) {
            this.restaurantId = restaurantId;
            this.price = price;
            this.available = available;
        }
    }
}
