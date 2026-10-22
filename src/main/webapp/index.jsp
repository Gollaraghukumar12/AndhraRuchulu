

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Andhra Ruchulu | Authentic Andhra Food</title>

    <meta http-equiv="refresh"
          content="0;url=<%= request.getContextPath() %>/restaurants">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #fff8f0;
            color: #333;
        }

        .header {
            background: #b22222;
            color: white;
            padding: 20px 7%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 28px;
            font-weight: bold;
        }

        .tagline {
            font-size: 14px;
            margin-top: 5px;
        }

        .hero {
            min-height: 75vh;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 40px 20px;
            background: linear-gradient(
                135deg,
                #fff0d9,
                #ffe0bd
            );
        }

        .hero-content {
            max-width: 750px;
        }

        .hero h1 {
            font-size: 46px;
            color: #8b1a1a;
            margin-bottom: 20px;
        }

        .hero p {
            font-size: 18px;
            line-height: 1.7;
            margin-bottom: 30px;
        }

        .button {
            display: inline-block;
            background: #b22222;
            color: white;
            text-decoration: none;
            padding: 15px 30px;
            border-radius: 6px;
            font-size: 17px;
            font-weight: bold;
        }

        .button:hover {
            background: #851919;
        }

        .loading {
            margin-top: 20px;
            font-size: 14px;
            color: #666;
        }

        footer {
            background: #292929;
            color: white;
            text-align: center;
            padding: 18px;
        }

        @media (max-width: 600px) {
            .header {
                padding: 18px;
            }

            .logo {
                font-size: 23px;
            }

            .hero h1 {
                font-size: 32px;
            }

            .hero p {
                font-size: 16px;
            }
        }
    </style>
</head>

<body>

    <header class="header">
        <div>
            <div class="logo">Andhra Ruchulu</div>
            <div class="tagline">The authentic taste of Andhra Pradesh</div>
        </div>
    </header>

    <main class="hero">
        <div class="hero-content">

            <h1>Welcome to Andhra Ruchulu!</h1>

            <p>
                Discover delicious Andhra meals, spicy biryanis,
                traditional tiffins and your favourite local dishes.
                Explore restaurants and find your next delicious meal.
            </p>

            <a class="button"
               href="<%= request.getContextPath() %>/restaurants">
                Explore Restaurants
            </a>

            <p class="loading">
                Taking you to our restaurants page...
            </p>

        </div>
    </main>

    <footer>
        &copy; 2026 Andhra Ruchulu. All rights reserved.
    </footer>

</body>
</html>

