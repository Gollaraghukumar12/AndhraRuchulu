
package com.andhraruchulu.daoimpl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.andhraruchulu.dao.MenuDAO;
import com.andhraruchulu.model.Menu;
import com.andhraruchulu.util.DBConnection;

public class MenuDAOImpl implements MenuDAO {

    @Override
    public boolean addMenu(Menu menu) {
        String sql = "INSERT INTO menus "
                + "(restaurant_id, item_name, description, price, "
                + "category, image_path, available) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, menu.getRestaurantId());
            ps.setString(2, menu.getItemName());
            ps.setString(3, menu.getDescription());
            ps.setBigDecimal(4, menu.getPrice());
            ps.setString(5, menu.getCategory());
            ps.setString(6, menu.getImagePath());
            ps.setBoolean(7, menu.isAvailable());

            if (ps.executeUpdate() > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        menu.setMenuId(keys.getInt(1));
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
    public Menu getMenuById(int menuId) {
        String sql = "SELECT * FROM menus WHERE menu_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, menuId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapMenu(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Menu> getAllMenus() {
        List<Menu> menus = new ArrayList<>();
        String sql = "SELECT * FROM menus ORDER BY menu_id";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                menus.add(mapMenu(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }

    @Override
    public List<Menu> getMenusByRestaurantId(int restaurantId) {
        List<Menu> menus = new ArrayList<>();
        String sql = "SELECT * FROM menus "
                + "WHERE restaurant_id = ? ORDER BY menu_id";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, restaurantId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    menus.add(mapMenu(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }

    @Override
    public boolean updateMenu(Menu menu) {
        String sql = "UPDATE menus SET "
                + "restaurant_id = ?, item_name = ?, description = ?, "
                + "price = ?, category = ?, image_path = ?, available = ? "
                + "WHERE menu_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, menu.getRestaurantId());
            ps.setString(2, menu.getItemName());
            ps.setString(3, menu.getDescription());
            ps.setBigDecimal(4, menu.getPrice());
            ps.setString(5, menu.getCategory());
            ps.setString(6, menu.getImagePath());
            ps.setBoolean(7, menu.isAvailable());
            ps.setInt(8, menu.getMenuId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteMenu(int menuId) {
        String sql = "DELETE FROM menus WHERE menu_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, menuId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private Menu mapMenu(ResultSet rs) throws SQLException {
        Menu menu = new Menu();

        menu.setMenuId(rs.getInt("menu_id"));
        menu.setRestaurantId(rs.getInt("restaurant_id"));
        menu.setItemName(rs.getString("item_name"));
        menu.setDescription(rs.getString("description"));

        BigDecimal price = rs.getBigDecimal("price");
        menu.setPrice(price);

        menu.setCategory(rs.getString("category"));
        menu.setImagePath(rs.getString("image_path"));
        menu.setAvailable(rs.getBoolean("available"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            menu.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            menu.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return menu;
    }
}
