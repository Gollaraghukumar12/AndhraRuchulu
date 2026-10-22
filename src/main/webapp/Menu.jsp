
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Andhra Ruchulu - Menu</title>

<style>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: Arial, sans-serif;
    background: #f8f8f8;
    color: #333;
}

.navbar {
    background: #a83218;
    color: white;
    padding: 18px 6%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
}

.logo {
    font-size: 25px;
    font-weight: bold;
}

.nav-links {
    display: flex;
    gap: 18px;
    align-items: center;
}

.nav-links a {
    color: white;
    text-decoration: none;
    font-weight: bold;
}

.nav-links a:hover {
    text-decoration: underline;
}

.page-header {
    padding: 35px 6% 20px;
    text-align: center;
}

.page-header h1 {
    color: #a83218;
    margin-bottom: 10px;
}

.page-header p {
    color: #666;
    line-height: 1.6;
}

.menu-container {
    width: 88%;
    max-width: 1300px;
    margin: 20px auto 50px;
}

.menu-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 25px;
}

.menu-card {
    background: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 3px 12px rgba(0, 0, 0, 0.10);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    display: flex;
    flex-direction: column;
}

.menu-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 7px 18px rgba(0, 0, 0, 0.15);
}

.food-image {
    width: 100%;
    height: 190px;
    object-fit: cover;
    display: block;
    background: #eee;
}

.image-placeholder {
    width: 100%;
    height: 190px;
    background: #f0e2d7;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #80543d;
    font-size: 15px;
}

.menu-details {
    padding: 18px;
    display: flex;
    flex-direction: column;
    flex: 1;
}

.menu-details h3 {
    color: #292929;
    font-size: 19px;
    margin-bottom: 10px;
}

.description {
    color: #666;
    font-size: 14px;
    line-height: 1.5;
    margin-bottom: 12px;
    flex: 1;
}

.category {
    display: inline-block;
    align-self: flex-start;
    background: #fff0e8;
    color: #a83218;
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 12px;
    margin-bottom: 12px;
}

.price {
    color: #188038;
    font-size: 21px;
    font-weight: bold;
    margin-bottom: 12px;
}

.add-cart-form {
    margin-top: auto;
}

.add-cart-btn {
    width: 100%;
    background: #a83218;
    color: white;
    border: none;
    padding: 12px 15px;
    border-radius: 7px;
    font-size: 15px;
    font-weight: bold;
    cursor: pointer;
    transition: background 0.2s ease;
}

.add-cart-btn:hover {
    background: #7e2412;
}

.add-cart-btn:disabled {
    background: #999;
    cursor: not-allowed;
}

.empty-message {
    text-align: center;
    background: white;
    padding: 35px;
    border-radius: 10px;
    color: #666;
    line-height: 1.8;
}

.back-link {
    display: inline-block;
    margin-bottom: 20px;
    color: #a83218;
    text-decoration: none;
    font-weight: bold;
}

.back-link:hover {
    text-decoration: underline;
}

/* Warning for items from different restaurants */
.cart-warning {
    background: #fff0e8;
    color: #a83218;
    border: 1px solid #e7a18e;
    padding: 15px 18px;
    border-radius: 8px;
    margin: 0 0 22px;
    font-weight: bold;
    line-height: 1.5;
}

footer {
    background: #292929;
    color: white;
    text-align: center;
    padding: 20px;
    margin-top: 30px;
}

@media (max-width: 600px) {
    .navbar {
        padding: 16px 5%;
    }

    .menu-container {
        width: 92%;
    }

    .page-header {
        padding: 25px 5% 15px;
    }

    .nav-links {
        gap: 12px;
        flex-wrap: wrap;
    }
}
</style>
</head>

<body>

<%
    String restaurantName =
        (String) request.getAttribute("restaurantName");

    Object restaurantIdObject =
        request.getAttribute("restaurantId");

    List<Map<String, Object>> menuItems =
        (List<Map<String, Object>>) request.getAttribute("menuItems");

    String contextPath = request.getContextPath();

    String restaurantIdValue = restaurantIdObject == null
        ? "" : restaurantIdObject.toString();

    if (restaurantName == null || restaurantName.trim().isEmpty()) {
        restaurantName = "Restaurant Menu";
    }

    // Read and display the one-restaurant-per-cart warning.
    String cartMessage = (String) session.getAttribute("cartMessage");

    if (cartMessage != null) {
        session.removeAttribute("cartMessage");
    }
%>

<header class="navbar">
    <div class="logo">Andhra Ruchulu</div>

    <nav class="nav-links">
        <a href="<%= contextPath %>/restaurants">Restaurants</a>
        <a href="<%= contextPath %>/cart">My Cart</a>

        <% if (session.getAttribute("userId") != null) { %>
            <a href="<%= contextPath %>/logout">Logout</a>
        <% } else { %>
            <a href="<%= contextPath %>/login">Login</a>
            <a href="<%= contextPath %>/register">Sign Up</a>
        <% } %>
    </nav>
</header>

<section class="page-header">
    <h1><%= restaurantName %></h1>
    <p>Explore our delicious food and add your favourite dishes to your cart.</p>
</section>

<main class="menu-container">

    <a class="back-link" href="<%= contextPath %>/restaurants">
        &larr; Back to Restaurants
    </a>

    <% if (cartMessage != null && !cartMessage.trim().isEmpty()) { %>
        <div class="cart-warning" role="alert">
            <%= cartMessage %>
        </div>
    <% } %>

    <% if (menuItems == null || menuItems.isEmpty()) { %>

        <div class="empty-message">
            <h2>No menu items available</h2>
            <p>Please check back later or choose another restaurant.</p>
        </div>

    <% } else { %>

        <div class="menu-grid">

            <% for (Map<String, Object> item : menuItems) {

                Object menuId = item.get("menu_id");
                Object itemNameObject = item.get("item_name");
                Object descriptionObject = item.get("description");
                Object categoryObject = item.get("category");
                Object priceObject = item.get("price");
                Object imagePathObject = item.get("image_path");

                String itemName = itemNameObject == null
                    ? "Food Item" : itemNameObject.toString();

                String description = descriptionObject == null
                    ? "Delicious food prepared with care."
                    : descriptionObject.toString();

                String category = categoryObject == null
                    ? "Special" : categoryObject.toString();

                String imagePath = imagePathObject == null
                    ? "" : imagePathObject.toString().trim();
            %>

                <article class="menu-card">

                    <% if (!imagePath.isEmpty()) { %>

                        <img
                            class="food-image"
                            src="<%= imagePath %>"
                            alt="<%= itemName %>"
                            loading="lazy"
                            onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">

                        <div class="image-placeholder" style="display:none;">
                            Image unavailable
                        </div>

                    <% } else { %>

                        <div class="image-placeholder">
                            Image unavailable
                        </div>

                    <% } %>

                    <div class="menu-details">

                        <h3><%= itemName %></h3>

                        <p class="description"><%= description %></p>

                        <span class="category"><%= category %></span>

                        <div class="price">
                            &#8377;<%= priceObject == null
                                ? "0.00" : priceObject.toString() %>
                        </div>

                        <form
                            class="add-cart-form"
                            action="<%= contextPath %>/cart"
                            method="post">

                            <input
                                type="hidden"
                                name="action"
                                value="add">

                            <input
                                type="hidden"
                                name="menuId"
                                value="<%= menuId == null ? "" : menuId.toString() %>">

                            <input
                                type="hidden"
                                name="restaurantId"
                                value="<%= restaurantIdValue %>">

                            <button
                                type="submit"
                                class="add-cart-btn"
                                <%= menuId == null ? "disabled" : "" %>>
                                Add to Cart
                            </button>

                        </form>

                    </div>
                </article>

            <% } %>

        </div>

    <% } %>

</main>

<footer>
    <p>&copy; 2026 Andhra Ruchulu. All rights reserved.</p>
</footer>

</body>
</html>
