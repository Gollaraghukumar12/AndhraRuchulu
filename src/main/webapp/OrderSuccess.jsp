
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    String contextPath = request.getContextPath();

    Object userId = session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect(contextPath + "/login");
        return;
    }

    Object orderIdObject = request.getAttribute("orderId");
    Object paymentMethodObject = request.getAttribute("paymentMethod");
    Object paymentStatusObject = request.getAttribute("paymentStatus");

    if (orderIdObject == null
            || paymentMethodObject == null
            || paymentStatusObject == null) {
        response.sendRedirect(contextPath + "/restaurants");
        return;
    }

    int orderId = ((Number) orderIdObject).intValue();
    String paymentMethod = paymentMethodObject.toString();
    String paymentStatus = paymentStatusObject.toString();

    String userName = session.getAttribute("userName") == null
            ? "Customer"
            : session.getAttribute("userName").toString();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Order Confirmation | Andhra Ruchulu</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #f7f7f7;
            color: #292929;
        }

        .navbar {
            background: #a82020;
            color: white;
            padding: 18px 6%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .brand {
            font-size: 23px;
            font-weight: bold;
            color: white;
            text-decoration: none;
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

        .success-container {
            width: 92%;
            max-width: 650px;
            margin: 55px auto;
            background: white;
            padding: 35px;
            border-radius: 14px;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.07);
            text-align: center;
        }

        .success-icon {
            width: 76px;
            height: 76px;
            margin: 0 auto 20px;
            border-radius: 50%;
            background: #e5f7e9;
            color: #16813b;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 42px;
            font-weight: bold;
        }

        h1 {
            margin-bottom: 10px;
            font-size: 28px;
        }

        .subtitle {
            color: #666;
            line-height: 1.6;
        }

        .order-details {
            margin: 28px 0;
            padding: 20px;
            background: #fafafa;
            border: 1px solid #eee;
            border-radius: 10px;
            text-align: left;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            padding: 13px 0;
            border-bottom: 1px solid #e8e8e8;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            color: #666;
        }

        .detail-value {
            font-weight: bold;
            text-align: right;
            overflow-wrap: anywhere;
        }

        .status {
            color: #a05a00;
        }

        .notice {
            background: #fff7e8;
            color: #79520c;
            padding: 13px;
            border-radius: 8px;
            font-size: 14px;
            line-height: 1.6;
            text-align: left;
            margin-bottom: 24px;
        }

        .button {
            display: block;
            width: 100%;
            padding: 14px;
            background: #a82020;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            margin-top: 12px;
        }

        .button:hover {
            background: #861818;
        }

        .secondary-button {
            background: #555;
        }

        .secondary-button:hover {
            background: #333;
        }

        @media (max-width: 500px) {
            .success-container {
                padding: 22px;
                margin: 30px auto;
            }

            h1 {
                font-size: 24px;
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

<main class="success-container">

    <div class="success-icon">&#10003;</div>

    <h1>Order Placed Successfully!</h1>

    <p class="subtitle">
        Thank you, <%= userName %>! Your order request has been received.
    </p>

    <section class="order-details">

        <div class="detail-row">
            <span class="detail-label">Order ID</span>
            <span class="detail-value">#<%= orderId %></span>
        </div>

        <div class="detail-row">
            <span class="detail-label">Payment Method</span>
            <span class="detail-value">
                <%= "COD".equals(paymentMethod)
                    ? "Cash on Delivery"
                    : "UPI Payment" %>
            </span>
        </div>

        <div class="detail-row">
            <span class="detail-label">Payment Status</span>
            <span class="detail-value status">
                <%= paymentStatus %>
            </span>
        </div>

    </section>

    <% if ("UPI".equals(paymentMethod)) { %>

        <div class="notice">
            Your order's UPI payment is still pending. Do not consider
            the payment completed until the payment gateway confirms it.
            Online UPI checkout will be enabled in the next integration step.
        </div>

    <% } else { %>

        <div class="notice">
            Please pay when your order arrives. Your order has not been
            marked as paid online.
        </div>

    <% } %>

    <a class="button" href="<%= contextPath %>/restaurants">
        Continue Shopping
    </a>

    <a class="button secondary-button" href="<%= contextPath %>/cart">
        View Cart
    </a>

</main>

</body>
</html>
