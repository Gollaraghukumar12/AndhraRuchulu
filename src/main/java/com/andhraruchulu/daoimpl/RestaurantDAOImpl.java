


package com.andhraruchulu.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.andhraruchulu.dao.RestaurantDAO;
import com.andhraruchulu.model.Restaurant;
import com.andhraruchulu.util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    @Override
    public boolean addRestaurant(Restaurant restaurant) {

        String sql = "INSERT INTO restaurants "
                + "(restaurant_name, description, address, phone, image_path, active) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, restaurant.getRestaurantName());
            ps.setString(2, restaurant.getDescription());
            ps.setString(3, restaurant.getAddress());
            ps.setString(4, restaurant.getPhone());
            ps.setString(5, restaurant.getImagePath());
            ps.setBoolean(6, restaurant.isActive());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        restaurant.setRestaurantId(keys.getInt(1));
                    }
                }
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Restaurant getRestaurantById(int restaurantId) {

        String sql = "SELECT * FROM restaurants WHERE restaurant_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, restaurantId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRestaurant(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {

        List<Restaurant> restaurants = new ArrayList<>();

        String sql = "SELECT * FROM restaurants ORDER BY restaurant_id";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                restaurants.add(mapRestaurant(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    @Override
    public boolean updateRestaurant(Restaurant restaurant) {

        String sql = "UPDATE restaurants SET "
                + "restaurant_name = ?, description = ?, address = ?, "
                + "phone = ?, image_path = ?, active = ? "
                + "WHERE restaurant_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, restaurant.getRestaurantName());
            ps.setString(2, restaurant.getDescription());
            ps.setString(3, restaurant.getAddress());
            ps.setString(4, restaurant.getPhone());
            ps.setString(5, restaurant.getImagePath());
            ps.setBoolean(6, restaurant.isActive());
            ps.setInt(7, restaurant.getRestaurantId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteRestaurant(int restaurantId) {

        String sql = "DELETE FROM restaurants WHERE restaurant_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, restaurantId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println(
                    "Unable to delete restaurant. It may be referenced by menu items or orders."
            );
            e.printStackTrace();
        }

        return false;
    }

    private Restaurant mapRestaurant(ResultSet rs) throws SQLException {

        Restaurant restaurant = new Restaurant();

        restaurant.setRestaurantId(rs.getInt("restaurant_id"));
        restaurant.setRestaurantName(rs.getString("restaurant_name"));
        restaurant.setDescription(rs.getString("description"));
        restaurant.setAddress(rs.getString("address"));
        restaurant.setPhone(rs.getString("phone"));
        restaurant.setImagePath(rs.getString("image_path"));
        restaurant.setActive(rs.getBoolean("active"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            restaurant.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            restaurant.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return restaurant;
    }
}
