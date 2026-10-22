
package com.andhraruchulu.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class CartItem {

    private int cartItemId;
    private int cartId;
    private int menuId;
    private int quantity;
    private BigDecimal price;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // No-argument constructor
    public CartItem() {
    }

    // Parameterized constructor
    public CartItem(int cartItemId, int cartId, int menuId,
                    int quantity, BigDecimal price,
                    LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.cartItemId = cartItemId;
        this.cartId = cartId;
        this.menuId = menuId;
        this.quantity = quantity;
        this.price = price;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and setters
    public int getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(int cartItemId) {
        this.cartItemId = cartItemId;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    // toString method
    @Override
    public String toString() {
        return "CartItem [cartItemId=" + cartItemId
                + ", cartId=" + cartId
                + ", menuId=" + menuId
                + ", quantity=" + quantity
                + ", price=" + price
                + ", createdAt=" + createdAt
                + ", updatedAt=" + updatedAt + "]";
    }
}

