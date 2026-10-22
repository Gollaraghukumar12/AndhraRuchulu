

package com.andhraruchulu.dao;

import com.andhraruchulu.model.Cart;

public interface CartDAO {

    boolean addCart(Cart cart);

    Cart getCartById(int cartId);

    Cart getCartByUserId(int userId);

    boolean updateCart(Cart cart);

    boolean deleteCart(int cartId);
}
