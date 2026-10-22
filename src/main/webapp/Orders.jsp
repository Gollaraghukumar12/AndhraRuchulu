
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.*,java.text.SimpleDateFormat" %>

<%!
    // Escape database text before displaying it in HTML.
    private String escapeHtml(Object value) {
        if (value == null) return "";
        String text = value.toString();
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
%>

<%
    String contextPath = request.getContextPath();

    List<Map<String, Object>> orders =
        (List<Map<String, Object>>) request.getAttribute("orders");

    SimpleDateFormat dateFormat =
        new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>My Orders - Andhra Ruchulu</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f7f5f2;
    color: #292929;
}

.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 16px;
    padding: 18px 7%;
    background: #292929;
    color: white;
}

.logo {
    font-size: 24px;
    font-weight: bold;
    color: #ffb36b;
}

.nav-links {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
}

.nav-links a {
    color: white;
    text-decoration: none;
}

.nav-links a:hover {
    color: #ffb36b;
}

.page-header {
    padding: 35px 7% 20px;
}

.page-header h1 {
    margin-bottom: 8px;
}

.page-header p {
    color: #666;
}

.orders-container {
    width: 86%;
    max-width: 1100px;
    margin: 0 auto 45px;
}

.order-card {
    background: white;
    border: 1px solid #eee;
    border-radius: 10px;
    padding: 22px;
    margin-bottom: 20px;
    box-shadow: 0 3px 12px rgba(0, 0, 0, 0.06);
}

.order-top {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    flex-wrap: wrap;
    gap: 15px;
    border-bottom: 1px solid #eee;
    padding-bottom: 15px;
}

.order-top h2 {
    font-size: 19px;
    margin: 0 0 8px;
}

.order-date {
    color: #777;
    font-size: 13px;
}

.status {
    display: inline-block;
    padding: 7px 12px;
    border-radius: 20px;
    background: #fff0d8;
    color: #805000;
    font-size: 13px;
    font-weight: bold;
}

.order-details {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 18px;
    padding-top: 18px;
}

.detail-label {
    color: #777;
    font-size: 13px;
    margin-bottom: 6px;
}

.detail-value {
    font-weight: 600;
    overflow-wrap: anywhere;
}

.total {
    color: #188038;
    font-size: 21px;
}

.items-heading {
    margin: 22px 0 12px;
    font-size: 16px;
}

.food-item {
    display: flex;
    align-items: center;
    gap: 15px;
    padding: 12px 0;
    border-top: 1px solid #eee;
}

.food-image {
    width: 88px;
    height: 76px;
    object-fit: cover;
    border-radius: 8px;
    background: #f0f0f0;
    flex-shrink: 0;
}

.food-info {
    flex: 1;
    min-width: 0;
}

.food-name {
    font-weight: bold;
    margin-bottom: 7px;
}

.food-meta {
    color: #666;
    font-size: 14px;
    line-height: 1.6;
}

.empty-state {
    background: white;
    padding: 40px 20px;
    text-align: center;
    border-radius: 10px;
}

.button {
    display: inline-block;
    margin-top: 18px;
    background: #a83218;
    color: white;
    padding: 12px 20px;
    border-radius: 7px;
    text-decoration: none;
}

.button:hover {
    background: #7e2412;
}

footer {
    text-align: center;
    padding: 20px;
    background: #292929;
    color: white;
}

@media (max-width: 600px) {
    .orders-container {
        width: 92%;
    }

    .order-details {
        grid-template-columns: 1fr;
    }

    .page-header {
        padding: 25px 5%;
    }

    .food-image {
        width: 72px;
        height: 68px;
    }
}
</style>
</head>

<body>

<header class="navbar">
    <div class="logo">Andhra Ruchulu</div>

    <nav class="nav-links">
        <a href="<%= contextPath %>/restaurants">Home</a>
        <a href="<%= contextPath %>/cart">My Cart</a>
        <a href="<%= contextPath %>/orders">My Orders</a>
        <a href="<%= contextPath %>/logout">Logout</a>
    </nav>
</header>

<section class="page-header">
    <h1>My Orders</h1>
    <p>View your orders, food items, and payment details.</p>
</section>

<main class="orders-container">

<% if (orders == null || orders.isEmpty()) { %>

    <div class="empty-state">
        <h2>No orders yet</h2>
        <p>Your placed orders will appear here.</p>

        <a class="button" href="<%= contextPath %>/restaurants">
            Explore Restaurants
        </a>
    </div>

<% } else {
    for (Map<String, Object> order : orders) {

        Object createdAt = order.get("createdAt");
        Object restaurantName = order.get("restaurantName");
        Object orderItemsObject = order.get("orderItems");

        String dateText = createdAt == null
            ? "Date unavailable"
            : dateFormat.format(createdAt);

        String restaurantText = restaurantName == null
            ? "Restaurant #" + order.get("restaurantId")
            : restaurantName.toString();

        String statusText = order.get("orderStatus") == null
            ? "Pending"
            : order.get("orderStatus").toString();

        String paymentMethod = order.get("paymentMethod") == null
            ? "Not specified"
            : order.get("paymentMethod").toString();

        String paymentStatus = order.get("paymentStatus") == null
            ? "Not specified"
            : order.get("paymentStatus").toString();

        List<Map<String, Object>> orderItems =
            orderItemsObject instanceof List
            ? (List<Map<String, Object>>) orderItemsObject
            : Collections.emptyList();
%>

    <article class="order-card">

        <div class="order-top">
            <div>
                <h2>Order #<%= order.get("orderId") %></h2>
                <div class="order-date"><%= dateText %></div>
            </div>

            <span class="status"><%= escapeHtml(statusText) %></span>
        </div>

        <div class="order-details">

            <div>
                <div class="detail-label">Restaurant</div>
                <div class="detail-value">
                    <%= escapeHtml(restaurantText) %>
                </div>
            </div>

            <div>
                <div class="detail-label">Order Total</div>
                <div class="detail-value total">
                    ₹<%= order.get("totalAmount") %>
                </div>
            </div>

            <div>
                <div class="detail-label">Payment Method</div>
                <div class="detail-value">
                    <%= escapeHtml(paymentMethod) %>
                </div>
            </div>

            <div>
                <div class="detail-label">Payment Status</div>
                <div class="detail-value">
                    <%= escapeHtml(paymentStatus) %>
                </div>
            </div>

            <div style="grid-column: 1 / -1;">
                <div class="detail-label">Delivery Address</div>
                <div class="detail-value">
                    <%= escapeHtml(order.get("deliveryAddress")) %>
                </div>
            </div>

        </div>

        <h3 class="items-heading">Food Items</h3>

        <% if (orderItems.isEmpty()) { %>
            <p class="food-meta">
                Item details are not available for this order.
            </p>
        <% } else {
            for (Map<String, Object> item : orderItems) {

                Object imagePath = item.get("imagePath");
                String imageUrl = imagePath == null
                    ? ""
                    : imagePath.toString().trim();
        %>

            <div class="food-item">

                <% if (!imageUrl.isEmpty()) { %>
                    <img class="food-image"
                         src="<%= escapeHtml(imageUrl) %>"
                         alt="<%= escapeHtml(item.get("itemName")) %>"
                         onerror="this.style.display='none';">
                <% } else { %>
                    <div class="food-image"></div>
                <% } %>

                <div class="food-info">
                    <div class="food-name">
                        <%= escapeHtml(item.get("itemName")) %>
                    </div>

                    <div class="food-meta">
                        Quantity: <%= item.get("quantity") %><br>
                        Price: ₹<%= item.get("price") %>
                    </div>
                </div>

            </div>

        <%  }
           }
        %>

    </article>

<%  }
   }
%>

</main>

<footer>
    <p>&copy; 2026 Andhra Ruchulu. All rights reserved.</p>
</footer>

</body>
</html>
