

package com.andhraruchulu.dao;

import java.util.List;

import com.andhraruchulu.model.Restaurant;

public interface RestaurantDAO {

    boolean addRestaurant(Restaurant restaurant);

    Restaurant getRestaurantById(int restaurantId);

    List<Restaurant> getAllRestaurants();

    boolean updateRestaurant(Restaurant restaurant);

    boolean deleteRestaurant(int restaurantId);
}
