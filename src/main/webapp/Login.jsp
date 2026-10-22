
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login | Andhra Ruchulu</title>
<style>
* { box-sizing: border-box; }
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #fff7f0;
    color: #333;
}
.navbar {
    background: #b83224;
    color: white;
    padding: 18px 7%;
    font-size: 25px;
    font-weight: bold;
}
.container {
    min-height: 85vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 25px;
}
.login-card {
    width: 100%;
    max-width: 420px;
    padding: 32px;
    background: white;
    border-radius: 12px;
    box-shadow: 0 5px 22px #00000014;
}
h1 { margin-top: 0; text-align: center; }
.subtitle {
    text-align: center;
    color: #666;
    margin-bottom: 25px;
}
label {
    display: block;
    font-weight: bold;
    margin: 16px 0 7px;
}
input {
    width: 100%;
    padding: 12px;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 15px;
}
button {
    width: 100%;
    margin-top: 24px;
    padding: 13px;
    border: none;
    border-radius: 6px;
    background: #b83224;
    color: white;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
}
button:hover { background: #94271d; }
.error {
    background: #ffe8e8;
    color: #a40000;
    padding: 12px;
    border-radius: 6px;
    margin-bottom: 15px;
}
.success {
    background: #e7f7e8;
    color: #216b2a;
    padding: 12px;
    border-radius: 6px;
    margin-bottom: 15px;
}
.links {
    text-align: center;
    margin-top: 20px;
    line-height: 2;
}
a { color: #b83224; }
</style>
</head>
<body>

<header class="navbar">Andhra Ruchulu</header>

<main class="container">
    <section class="login-card">
        <h1>Welcome Back!</h1>
        <p class="subtitle">Login to continue ordering delicious food.</p>

        <% if (errorMessage != null) { %>
            <div class="error"><%= errorMessage %></div>
        <% } %>

        <% if ("success".equals(request.getParameter("registered"))) { %>
            <div class="success">
                Registration successful! Please log in.
            </div>
        <% } %>

        <% if (request.getParameter("required") != null) { %>
            <div class="success">
                Please log in to add food to your cart.
            </div>
        <% } %>

        <% if ("success".equals(request.getParameter("logout"))) { %>
            <div class="success">You have logged out successfully.</div>
        <% } %>

        <form action="<%= contextPath %>/login" method="post">
            <label for="email">Email</label>
            <input type="email" id="email" name="email"
                   required maxlength="254" autocomplete="email">

            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   required autocomplete="current-password">

            <button type="submit">Login</button>
        </form>

        <div class="links">
            Don't have an account?
            <a href="<%= contextPath %>/register">Create Account</a>
            <br>
            <a href="<%= contextPath %>/restaurants">Browse Restaurants</a>
        </div>
    </section>
</main>

</body>
</html>
