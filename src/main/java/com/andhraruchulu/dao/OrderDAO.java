


package com.andhraruchulu.dao;

import java.util.List;

import com.andhraruchulu.model.Order;

public interface OrderDAO {

    boolean addOrder(Order order);

    Order getOrderById(int orderId);

    List<Order> getOrdersByUserId(int userId);

    List<Order> getAllOrders();

    boolean updateOrder(Order order);

    boolean updateOrderStatus(int orderId, String orderStatus);

    boolean deleteOrder(int orderId);
}



