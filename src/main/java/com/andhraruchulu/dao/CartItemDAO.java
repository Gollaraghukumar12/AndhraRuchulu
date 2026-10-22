

package com.andhraruchulu.dao;

import java.util.List;

import com.andhraruchulu.model.CartItem;

public interface CartItemDAO {

    boolean addCartItem(CartItem cartItem);

    CartItem getCartItemById(int cartItemId);

    List<CartItem> getCartItemsByCartId(int cartId);

    boolean updateCartItem(CartItem cartItem);

    boolean deleteCartItem(int cartItemId);

    boolean deleteCartItemsByCartId(int cartId);
}
