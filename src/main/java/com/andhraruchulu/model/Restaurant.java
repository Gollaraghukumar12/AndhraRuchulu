
package com.andhraruchulu.model;

import java.time.LocalDateTime;

public class Restaurant {

    private int restaurantId;
    private String restaurantName;
    private String description;
    private String address;
    private String phone;
    private String imagePath;
    private boolean active;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // No-argument constructor
    public Restaurant() {
    }

    // Parameterized constructor
    public Restaurant(int restaurantId, String restaurantName,
                      String description, String address,
                      String phone, String imagePath,
                      boolean active, LocalDateTime createdAt,
                      LocalDateTime updatedAt) {
        this.restaurantId = restaurantId;
        this.restaurantName = restaurantName;
        this.description = description;
        this.address = address;
        this.phone = phone;
        this.imagePath = imagePath;
        this.active = active;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and setters
    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
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
        return "Restaurant [restaurantId=" + restaurantId
                + ", restaurantName=" + restaurantName
                + ", description=" + description
                + ", address=" + address
                + ", phone=" + phone
                + ", imagePath=" + imagePath
                + ", active=" + active
                + ", createdAt=" + createdAt
                + ", updatedAt=" + updatedAt + "]";
    }
}
