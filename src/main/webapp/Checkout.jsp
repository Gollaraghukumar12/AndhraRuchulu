
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,java.math.BigDecimal" %>

<%
    String contextPath = request.getContextPath();

    if (session.getAttribute("userId") == null) {
        response.sendRedirect(contextPath + "/login");
        return;
    }

    Object cartObject = session.getAttribute("cart");

    if (!(cartObject instanceof Map<?, ?>)
            || ((Map<?, ?>) cartObject).isEmpty()) {
        response.sendRedirect(contextPath + "/cart");
        return;
    }

    Object itemsObject = request.getAttribute("cartItems");

    if (!(itemsObject instanceof List<?>)) {
        response.sendRedirect(contextPath + "/checkout");
        return;
    }

    List<?> cartItems = (List<?>) itemsObject;

    BigDecimal cartTotal = BigDecimal.ZERO;
    Object totalObject = request.getAttribute("cartTotal");

    if (totalObject instanceof BigDecimal) {
        cartTotal = (BigDecimal) totalObject;
    } else if (totalObject instanceof Number) {
        cartTotal = BigDecimal.valueOf(
            ((Number) totalObject).doubleValue());
    }

    String deliveryAddress =
        request.getAttribute("deliveryAddress") == null
        ? ""
        : request.getAttribute("deliveryAddress").toString();

    String message =
        request.getAttribute("message") == null
        ? ""
        : request.getAttribute("message").toString();

    String userName =
        session.getAttribute("userName") == null
        ? "Customer"
        : session.getAttribute("userName").toString();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Checkout | Andhra Ruchulu</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #f7f7f7;
            color: #262626;
        }

        .navbar {
            background: #a82020;
            color: white;
            padding: 17px 6%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            flex-wrap: wrap;
        }

        .brand {
            color: white;
            text-decoration: none;
            font-size: 23px;
            font-weight: bold;
        }

        .nav-links {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            font-size: 14px;
        }

        .page-title {
            text-align: center;
            padding: 25px 15px 10px;
        }

        .page-title h1 {
            margin-bottom: 8px;
        }

        .page-title p {
            color: #666;
        }

        .checkout-container {
            width: 92%;
            max-width: 1100px;
            margin: 20px auto 45px;
            display: grid;
            grid-template-columns: minmax(0, 1.5fr) minmax(280px, 1fr);
            gap: 22px;
            align-items: start;
        }

        .panel {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 3px 14px rgba(0, 0, 0, 0.06);
        }

        .panel h2 {
            margin-top: 0;
            margin-bottom: 18px;
            font-size: 21px;
        }

        .message {
            padding: 12px;
            margin-bottom: 16px;
            background: #fff0f0;
            color: #a82020;
            border-radius: 7px;
        }

        .food-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }

        .food-image-container {
            width: 100px;
            height: 90px;
            flex-shrink: 0;
            background: #f0f0f0;
            border-radius: 8px;
            overflow: hidden;
        }

        .food-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .food-details {
            flex: 1;
            min-width: 0;
        }

        .food-name {
            font-weight: bold;
            margin-bottom: 7px;
            overflow-wrap: anywhere;
        }

        .food-description {
            color: #777;
            font-size: 13px;
            margin-bottom: 6px;
        }

        .food-quantity {
            color: #666;
            font-size: 13px;
        }

        .food-price {
            text-align: right;
            white-space: nowrap;
            font-weight: bold;
        }

        .field-label {
            display: block;
            font-weight: bold;
            margin: 20px 0 8px;
        }

        textarea {
            width: 100%;
            min-height: 110px;
            resize: vertical;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 7px;
            font: inherit;
        }

        textarea:focus {
            outline: 2px solid #f0b6b6;
            border-color: #a82020;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            margin: 15px 0;
        }

        .grand-total {
            border-top: 1px solid #ddd;
            padding-top: 17px;
            margin-top: 18px;
            font-size: 20px;
            font-weight: bold;
        }

        .button {
            display: block;
            width: 100%;
            border: none;
            border-radius: 8px;
            padding: 14px 16px;
            background: #a82020;
            color: white;
            font-size: 16px;
            font-weight: bold;
            text-align: center;
            cursor: pointer;
            text-decoration: none;
        }

        .button:hover {
            background: #861818;
        }

        .secondary-button {
            background: #555;
            margin-top: 10px;
        }

        .secondary-button:hover {
            background: #333;
        }

        .payment-options {
            display: none;
            margin-top: 22px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .payment-option {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 15px;
            margin-bottom: 12px;
            border: 1px solid #ddd;
            border-radius: 9px;
            cursor: pointer;
        }

        .payment-option input {
            margin-top: 4px;
            accent-color: #a82020;
        }

        .payment-name {
            font-weight: bold;
            margin-bottom: 5px;
        }

        .payment-description {
            color: #666;
            font-size: 13px;
            line-height: 1.5;
        }

        .notice {
            color: #666;
            font-size: 13px;
            line-height: 1.6;
            margin-top: 15px;
        }

        .back-link {
            display: inline-block;
            color: #a82020;
            text-decoration: none;
            margin-top: 18px;
        }

        @media (max-width: 760px) {
            .checkout-container {
                grid-template-columns: 1fr;
            }

            .panel {
                padding: 18px;
            }

            .food-image-container {
                width: 78px;
                height: 78px;
            }

            .navbar {
                padding: 16px 5%;
            }
        }
    </style>
</head>

<body>

<header class="navbar">
    <a class="brand" href="<%= contextPath %>/restaurants">
        Andhra Ruchulu
    </a>

    <nav class="nav-links">
        <a href="<%= contextPath %>/restaurants">Restaurants</a>
        <a href="<%= contextPath %>/cart">Cart</a>
        <a href="<%= contextPath %>/logout">Logout</a>
    </nav>
</header>

<section class="page-title">
    <h1>Checkout</h1>
    <p>Hello, <%= userName %>! Review your order and delivery details.</p>
</section>

<main class="checkout-container">

    <section class="panel">
        <h2>Your Order</h2>

        <% if (!message.trim().isEmpty()) { %>
            <div class="message"><%= message %></div>
        <% } %>

        <% if (cartItems.isEmpty()) { %>

            <p>Your cart has no items.</p>

            <a class="button" href="<%= contextPath %>/restaurants">
                Browse Restaurants
            </a>

        <% } else { %>

            <% for (Object itemObject : cartItems) {

                if (!(itemObject instanceof Map<?, ?>)) {
                    continue;
                }

                Map<?, ?> item = (Map<?, ?>) itemObject;

                Object itemNameObject = item.get("item_name");
                Object descriptionObject = item.get("description");
                Object imagePathObject = item.get("image_path");
                Object quantityObject = item.get("quantity");
                Object priceObject = item.get("price");
                Object subtotalObject = item.get("subtotal");

                String itemName = itemNameObject == null
                    ? "Menu Item"
                    : itemNameObject.toString();

                String description = descriptionObject == null
                    ? ""
                    : descriptionObject.toString();

                String imagePath = imagePathObject == null
                    ? ""
                    : imagePathObject.toString().trim();

                int quantity = quantityObject instanceof Number
                    ? ((Number) quantityObject).intValue()
                    : 0;

                BigDecimal price =
                    priceObject instanceof BigDecimal
                    ? (BigDecimal) priceObject
                    : priceObject instanceof Number
                        ? BigDecimal.valueOf(
                            ((Number) priceObject).doubleValue())
                        : BigDecimal.ZERO;

                BigDecimal subtotal =
                    subtotalObject instanceof BigDecimal
                    ? (BigDecimal) subtotalObject
                    : subtotalObject instanceof Number
                        ? BigDecimal.valueOf(
                            ((Number) subtotalObject).doubleValue())
                        : price.multiply(BigDecimal.valueOf(quantity));

                String safeItemName = itemName
                    .replace("&", "&amp;")
                    .replace("\"", "&quot;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;");

                String safeImagePath = imagePath
                    .replace("&", "&amp;")
                    .replace("\"", "&quot;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;");
            %>

                <div class="food-item">

                    <div class="food-image-container">
                        <% if (!imagePath.isEmpty()) { %>
                            <img
                                class="food-image"
                                src="<%= safeImagePath %>"
                                alt="<%= safeItemName %>"
                                loading="lazy"
                                onerror="this.style.display='none';">
                        <% } %>
                    </div>

                    <div class="food-details">

                        <div class="food-name">
                            <%= itemName %>
                        </div>

                        <% if (!description.trim().isEmpty()) { %>
                            <div class="food-description">
                                <%= description %>
                            </div>
                        <% } %>

                        <div class="food-quantity">
                            Quantity: <%= quantity %>
                        </div>

                    </div>

                    <div class="food-price">
                        &#8377;<%= subtotal.toPlainString() %>
                    </div>

                </div>

            <% } %>

        <% } %>

        <label class="field-label" for="deliveryAddress">
            Delivery Address
        </label>

        <textarea
            id="deliveryAddress"
            name="deliveryAddress"
            form="checkoutForm"
            required
            maxlength="1000"
            placeholder="Enter your complete delivery address"><%= deliveryAddress %></textarea>

        <a class="back-link" href="<%= contextPath %>/cart">
            &larr; Back to Cart
        </a>

    </section>

    <aside class="panel">

        <h2>Payment Summary</h2>

        <div class="summary-row">
            <span>Items Total</span>
            <span>&#8377;<%= cartTotal.toPlainString() %></span>
        </div>

        <div class="summary-row">
            <span>Delivery Fee</span>
            <span>As applicable</span>
        </div>

        <div class="summary-row grand-total">
            <span>Total</span>
            <span>&#8377;<%= cartTotal.toPlainString() %></span>
        </div>

        <p class="notice">
            Please verify your delivery address before confirming your order.
        </p>

        <form id="checkoutForm"
              action="<%= contextPath %>/place-order"
              method="post">

            <button
                type="button"
                class="button"
                id="placeOrderButton"
                onclick="showPaymentOptions()">
                Place Order
            </button>

            <section id="paymentOptions" class="payment-options">

                <h2>Select Payment Method</h2>

                <label class="payment-option">
                    <input
                        type="radio"
                        name="paymentMethod"
                        value="COD"
                        required>

                    <span>
                        <div class="payment-name">Cash on Delivery</div>
                        <div class="payment-description">
                            Pay when your order arrives.
                        </div>
                    </span>
                </label>

                <label class="payment-option">
                    <input
                        type="radio"
                        name="paymentMethod"
                        value="UPI"
                        required>

                    <span>
                        <div class="payment-name">UPI Payment</div>
                        <div class="payment-description">
                            Digital payment will be enabled after the
                            payment gateway integration is completed.
                        </div>
                    </span>
                </label>

                <button type="submit" class="button">
                    Confirm Order
                </button>

                <button
                    type="button"
                    class="button secondary-button"
                    onclick="hidePaymentOptions()">
                    Go Back
                </button>

                <p class="notice">
                    UPI orders must remain unpaid until the payment gateway
                    confirms the transaction on the server.
                </p>

            </section>

        </form>

    </aside>

</main>

<script>
    function showPaymentOptions() {
        const address = document.getElementById("deliveryAddress");

        if (!address.value.trim()) {
            address.setCustomValidity(
                "Please enter your delivery address."
            );
            address.reportValidity();
            return;
        }

        address.setCustomValidity("");

        document.getElementById("paymentOptions").style.display = "block";
        document.getElementById("placeOrderButton").style.display = "none";
    }

    function hidePaymentOptions() {
        document.getElementById("paymentOptions").style.display = "none";
        document.getElementById("placeOrderButton").style.display = "block";
    }

    document.getElementById("deliveryAddress")
        .addEventListener("input", function () {
            this.setCustomValidity("");
        });
</script>

</body>
</html>
