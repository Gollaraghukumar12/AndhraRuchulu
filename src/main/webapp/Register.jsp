
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register - Andhra Ruchulu</title>

<style>
* { box-sizing: border-box; }
body {
    margin: 0; font-family: Arial, sans-serif;
    background: #f8f6f2; display: flex;
    justify-content: center; align-items: center;
    min-height: 100vh; padding: 20px;
}
.card {
    background: white; width: 100%; max-width: 430px;
    padding: 30px; border-radius: 12px;
    box-shadow: 0 4px 18px #00000012;
}
h1 { color: #8b1e1e; text-align: center; margin-top: 0; }
p { color: #666; text-align: center; }
label { display: block; margin-top: 14px; font-weight: bold; }
input, textarea {
    width: 100%; padding: 11px; margin-top: 6px;
    border: 1px solid #ccc; border-radius: 6px;
    font-size: 15px;
}
button {
    width: 100%; margin-top: 22px; padding: 12px;
    background: #8b1e1e; color: white; border: 0;
    border-radius: 6px; font-size: 16px; cursor: pointer;
}
.error { color: #b00020; text-align: left; }
.footer { text-align: center; margin-top: 18px; }
a { color: #8b1e1e; }
</style>
</head>

<body>
<div class="card">
    <h1>Andhra Ruchulu</h1>
    <p>Create your account</p>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <p class="error">${errorMessage}</p>
    <% } %>

    <form action="${pageContext.request.contextPath}/register"
          method="post">

        <label for="userName">Full Name</label>
        <input type="text" id="userName" name="userName"
               maxlength="100" autocomplete="name" required>

        <label for="email">Email</label>
        <input type="email" id="email" name="email"
               maxlength="150" autocomplete="email" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password"
               minlength="8" autocomplete="new-password" required>

        <label for="phone">Phone Number</label>
        <input type="tel" id="phone" name="phone"
               maxlength="20" autocomplete="tel" required>

        <label for="address">Delivery Address</label>
        <textarea id="address" name="address" rows="3"
                  maxlength="500" autocomplete="street-address"
                  required></textarea>

        <button type="submit">Create Account</button>
    </form>

    <div class="footer">
        Already registered?
        <a href="${pageContext.request.contextPath}/login">Login</a>
        <br><br>
        <a href="${pageContext.request.contextPath}/restaurants">
            Back to Restaurants
        </a>
    </div>
</div>
</body>
</html>
