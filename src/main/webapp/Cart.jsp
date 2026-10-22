
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>

<%
    String contextPath = request.getContextPath();

    if (session.getAttribute("userId") == null) {
        response.sendRedirect(contextPath + "/login?required=1");
        return;
    }

    List<Map<String, Object>> cartItems =
        (List<Map<String, Object>>) request.getAttribute("cartItems");

    BigDecimal cartTotal =
        (BigDecimal) request.getAttribute("cartTotal");

    if (cartItems == null) {
        cartItems = new java.util.ArrayList<>();
    }

    if (cartTotal == null) {
        cartTotal = BigDecimal.ZERO;
    }

    String cartMessage = (String) session.getAttribute("cartMessage");
    session.removeAttribute("cartMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>My Cart | Andhra Ruchulu</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f7f7f7;
    color: #292929;
}

.navbar {
    background: #b83224;
    color: white;
    padding: 18px 6%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
}

.logo {
    font-size: 25px;
    font-weight: bold;
}

.nav-links a {
    color: white;
    text-decoration: none;
    margin-left: 20px;
    font-weight: bold;
}

.nav-links a:hover {
    text-decoration: underline;
}

.container {
    width: 90%;
    max-width: 1100px;
    margin: 35px auto;
}

h1 {
    margin-bottom: 25px;
}

.cart-layout {
    display: grid;
    grid-template-columns: minmax(0, 1fr) 320px;
    gap: 25px;
    align-items: start;
}

.cart-list {
    display: flex;
    flex-direction: column;
    gap: 18px;
}

.cart-item {
    display: flex;
    align-items: center;
    gap: 18px;
    background: white;
    padding: 18px;
    border-radius: 10px;
    box-shadow: 0 2px 8px #0000000d;
}

.food-image {
    width: 125px;
    height: 110px;
    object-fit: cover;
    border-radius: 8px;
    background: #eeeeee;
    flex-shrink: 0;
}

.item-details {
    flex: 1;
    min-width: 0;
}

.item-details h3 {
    margin: 0 0 8px;
    overflow-wrap: anywhere;
}

.description {
    color: #666;
    font-size: 14px;
    margin: 5px 0;
}

.price {
    color: #b83224;
    font-weight: bold;
    margin: 8px 0;
}

.quantity-control {
    display: inline-flex;
    align-items: center;
    border: 1px solid #b83224;
    border-radius: 6px;
    overflow: hidden;
    margin: 8px 0;
}

.quantity-control button {
    width: 38px;
    height: 36px;
    border: none;
    background: #fff;
    color: #b83224;
    font-size: 22px;
    cursor: pointer;
}

.quantity-control button:hover:not(:disabled) {
    background: #fff0ed;
}

.quantity-control button:disabled {
    color: #aaa;
    cursor: not-allowed;
}

.quantity-number {
    min-width: 42px;
    text-align: center;
    font-weight: bold;
}

.subtotal {
    font-weight: bold;
    margin: 8px 0;
}

.remove-btn {
    background: white;
    color: #b83224;
    border: 1px solid #b83224;
    padding: 8px 13px;
    border-radius: 5px;
    cursor: pointer;
}

.remove-btn:hover {
    background: #fff0ed;
}

.unavailable {
    color: #b00020;
    font-size: 13px;
    font-weight: bold;
}

.summary {
    background: white;
    padding: 22px;
    border-radius: 10px;
    box-shadow: 0 2px 8px #0000000d;
}

.summary h2 {
    margin-top: 0;
}

.total-row {
    display: flex;
    justify-content: space-between;
    gap: 10px;
    font-size: 18px;
    font-weight: bold;
    padding: 15px 0;
    border-top: 1px solid #ddd;
}

.primary-btn {
    display: block;
    width: 100%;
    padding: 13px;
    border: none;
    border-radius: 6px;
    background: #b83224;
    color: white;
    font-size: 16px;
    font-weight: bold;
    text-align: center;
    text-decoration: none;
    cursor: pointer;
    margin-top: 12px;
}

.primary-btn:hover {
    background: #94271d;
}

.checkout-note {
    color: #666;
    font-size: 13px;
    line-height: 1.5;
    margin-top: 12px;
}

.empty-cart {
    background: white;
    text-align: center;
    padding: 50px 20px;
    border-radius: 10px;
}

.empty-cart p {
    color: #666;
}

.cart-message {
    padding: 14px;
    margin-bottom: 20px;
    border-radius: 7px;
    background: #fff0e0;
    color: #8a3b00;
}

@media (max-width: 760px) {
    .cart-layout {
        grid-template-columns: 1fr;
    }

    .cart-item {
        align-items: flex-start;
        flex-wrap: wrap;
    }

    .food-image {
        width: 100px;
        height: 100px;
    }

    .nav-links a {
        margin-left: 10px;
    }
}
</style>
</head>

<body>

<header class="navbar">
    <div class="logo">Andhra Ruchulu</div>

    <nav class="nav-links">
        <a href="<%= contextPath %>/restaurants">Restaurants</a>
        <a href="<%= contextPath %>/cart">My Cart</a>
        <a href="<%= contextPath %>/logout">Logout</a>
    </nav>
</header>

<main class="container">

    <h1>My Cart</h1>

    <% if (cartMessage != null && !cartMessage.trim().isEmpty()) { %>
        <div class="cart-message">
            <%= cartMessage.replace("&", "&amp;")
                           .replace("<", "&lt;")
                           .replace(">", "&gt;")
                           .replace("\"", "&quot;") %>
        </div>
    <% } %>

    <% if (cartItems.isEmpty()) { %>

        <section class="empty-cart">
            <h2>Your cart is empty</h2>
            <p>Discover delicious food from our restaurants.</p>

            <a class="primary-btn"
               href="<%= contextPath %>/restaurants">
                Explore Restaurants
            </a>
        </section>

    <% } else { %>

        <div class="cart-layout">

            <section class="cart-list">

                <% for (Map<String, Object> item : cartItems) {

                    Object menuId = item.get("menu_id");
                    Object itemName = item.get("item_name");
                    Object description = item.get("description");
                    Object imagePath = item.get("image_path");
                    Object price = item.get("price");
                    Object quantity = item.get("quantity");
                    Object subtotal = item.get("subtotal");

                    boolean available =
                        Boolean.TRUE.equals(item.get("available"));

                    int qty = ((Number) quantity).intValue();

                    String safeItemName =
                        itemName == null ? "Food item" :
                        itemName.toString()
                                .replace("&", "&amp;")
                                .replace("<", "&lt;")
                                .replace(">", "&gt;")
                                .replace("\"", "&quot;");

                    String safeDescription =
                        description == null ? "" :
                        description.toString()
                                   .replace("&", "&amp;")
                                   .replace("<", "&lt;")
                                   .replace(">", "&gt;");

                    String safeImagePath =
                        imagePath == null ? "" :
                        imagePath.toString()
                                 .replace("&", "&amp;")
                                 .replace("\"", "&quot;")
                                 .replace("<", "&lt;")
                                 .replace(">", "&gt;");
                %>

                <article class="cart-item">

                    <% if (!safeImagePath.trim().isEmpty()) { %>

                        <img class="food-image"
                             src="<%= safeImagePath %>"
                             alt="<%= safeItemName %>"
                             onerror="this.style.display='none'">

                    <% } else { %>

                        <div class="food-image"></div>

                    <% } %>

                    <div class="item-details">

                        <h3><%= safeItemName %></h3>

                        <% if (!safeDescription.trim().isEmpty()) { %>
                            <p class="description">
                                <%= safeDescription %>
                            </p>
                        <% } %>

                        <p class="price">
                            Price: ₹<%= price %>
                        </p>

                        <% if (available) { %>

                            <form action="<%= contextPath %>/cart"
                                  method="post"
                                  class="quantity-form">

                                <input type="hidden"
                                       name="action"
                                       value="update">

                                <input type="hidden"
                                       name="menuId"
                                       value="<%= menuId %>">

                                <input type="hidden"
                                       name="quantity"
                                       value="<%= qty %>"
                                       class="quantity-input">

                                <div class="quantity-control">

                                    <button type="button"
                                            class="quantity-btn"
                                            data-change="-1"
                                            aria-label="Decrease quantity">
                                        −
                                    </button>

                                    <span class="quantity-number">
                                        <%= qty %>
                                    </span>

                                    <button type="button"
                                            class="quantity-btn"
                                            data-change="1"
                                            aria-label="Increase quantity"
                                            <%= qty >= 99 ? "disabled" : "" %>>
                                        +
                                    </button>

                                </div>

                            </form>

                        <% } else { %>

                            <p class="unavailable">
                                Currently unavailable
                            </p>

                            <p>Quantity: <%= qty %></p>

                        <% } %>

                        <p class="subtotal">
                            Subtotal: ₹<%= subtotal %>
                        </p>

                        <form action="<%= contextPath %>/cart"
                              method="post"
                              class="remove-cart-form">

                            <input type="hidden"
                                   name="action"
                                   value="remove">

                            <input type="hidden"
                                   name="menuId"
                                   value="<%= menuId %>">

                            <button type="submit" class="remove-btn">
                                Remove
                            </button>

                        </form>

                    </div>

                </article>

                <% } %>

            </section>

            <aside class="summary">

                <h2>Order Summary</h2>

                <div class="total-row">
                    <span>Total</span>
                    <span>₹<%= cartTotal %></span>
                </div>

                <a class="primary-btn"
                   href="<%= contextPath %>/restaurants">
                    Continue Shopping
                </a>

                <% if (cartTotal.compareTo(BigDecimal.ZERO) > 0) { %>

                    <a class="primary-btn"
                       href="<%= contextPath %>/checkout">
                        Proceed to Checkout
                    </a>

                <% } else { %>

                    <button class="primary-btn"
                            type="button"
                            disabled
                            style="opacity:0.6; cursor:not-allowed;">
                        Proceed to Checkout
                    </button>

                    <p class="checkout-note">
                        Checkout is unavailable because your cart has
                        no available food items.
                    </p>

                <% } %>

            </aside>

        </div>

    <% } %>

</main>

<script>
document.querySelectorAll(".quantity-form").forEach(function(form) {

    const buttons = form.querySelectorAll(".quantity-btn");
    const quantityInput = form.querySelector(".quantity-input");
    const quantityDisplay = form.querySelector(".quantity-number");

    buttons.forEach(function(button) {

        button.addEventListener("click", function() {

            const change = Number(button.dataset.change);
            const currentQuantity = Number(quantityDisplay.textContent.trim());
            const newQuantity = currentQuantity + change;

            if (newQuantity < 0 || newQuantity > 99) {
                return;
            }

            if (newQuantity === 0) {
                if (!confirm(
                    "Quantity is zero. Remove this item from your cart?"
                )) {
                    return;
                }
            }

            quantityInput.value = newQuantity;
            form.submit();
        });
    });
});

document.querySelectorAll(".remove-cart-form").forEach(function(form) {

    form.addEventListener("submit", function(event) {

        if (!confirm("Are you sure you want to remove this item?")) {
            event.preventDefault();
        }
    });
});
</script>

</body>
</html>
