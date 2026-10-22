<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,java.util.Map" %>
<%
    List<Map<String, Object>> restaurants =
        (List<Map<String, Object>>) request.getAttribute("restaurants");

    Object sessionUserId = session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    String email = (String) session.getAttribute("email");
    String role = (String) session.getAttribute("role");
    boolean loggedIn = sessionUserId != null;

    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Andhra Ruchulu | Restaurants</title>

<style>
:root {
    --page-text: #241b16;
    --muted-text: #6f625a;
    --surface: rgba(255,255,255,.96);
    --surface-soft: rgba(255,250,246,.94);
    --border: #eaded5;
    --brand: #b84220;
    --brand-dark: #8f2e14;
    --shadow: 0 12px 34px rgba(45,24,12,.12);
}

* {
    box-sizing: border-box;
}

html {
    scroll-behavior: smooth;
}

body {
    margin: 0;
    font-family: Arial, Helvetica, sans-serif;
    color: var(--page-text);
    background: #f7f0e9;
    position: relative;
    isolation: isolate;
    min-height: 100vh;
}

/* Blurred background across the entire homepage */
body::before {
    content: "";
    position: fixed;
    inset: -14px;
    z-index: -2;
    background-image: url("https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=2000&q=85");
    background-size: cover;
    background-position: center;
    filter: blur(9px);
    transform: scale(1.04);
    pointer-events: none;
}

body::after {
    content: "";
    position: fixed;
    inset: 0;
    z-index: -1;
    pointer-events: none;
    background: rgba(255,248,241,.76);
}

body.dark-theme {
    --page-text: #f8eee7;
    --muted-text: #d0bfb3;
    --surface: rgba(35,27,23,.96);
    --surface-soft: rgba(45,34,28,.96);
    --border: #59463b;
    --brand: #f0784d;
    --brand-dark: #ff9b74;
    --shadow: 0 12px 34px rgba(0,0,0,.28);
}

body.dark-theme::after {
    background: rgba(18,12,9,.78);
}

body.large-text {
    font-size: 18px;
}

a {
    color: inherit;
    text-decoration: none;
}

button,
input {
    font: inherit;
}

/* Navbar */
.navbar {
    position: sticky;
    top: 0;
    z-index: 20;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 22px;
    padding: 15px clamp(18px, 5vw, 70px);
    background: var(--surface);
    border-bottom: 1px solid var(--border);
    box-shadow: 0 4px 18px rgba(45,24,12,.06);
    backdrop-filter: blur(12px);
}

.brand {
    font-size: 25px;
    font-weight: 800;
    color: var(--brand);
    white-space: nowrap;
}

.brand span {
    color: var(--page-text);
}

.nav-links {
    display: flex;
    align-items: center;
    gap: 22px;
    color: var(--muted-text);
    font-weight: 600;
}

.nav-links a:hover {
    color: var(--brand);
}

/* Profile dropdown */
.profile-area {
    position: relative;
}

.profile-button {
    border: 0;
    border-radius: 999px;
    padding: 10px 15px;
    background: var(--brand);
    color: #fff;
    font-weight: 700;
    cursor: pointer;
}

.profile-menu {
    display: none;
    position: absolute;
    right: 0;
    top: calc(100% + 12px);
    width: min(310px, calc(100vw - 28px));
    padding: 17px;
    border: 1px solid var(--border);
    border-radius: 16px;
    background: var(--surface);
    box-shadow: var(--shadow);
    z-index: 30;
}

.profile-menu.open {
    display: block;
}

.profile-heading {
    padding-bottom: 12px;
    margin-bottom: 9px;
    border-bottom: 1px solid var(--border);
}

.profile-heading strong {
    display: block;
    margin-bottom: 5px;
}

.profile-heading small {
    display: block;
    color: var(--muted-text);
    overflow-wrap: anywhere;
    margin-top: 4px;
}

.profile-link,
.settings-toggle {
    display: block;
    width: 100%;
    text-align: left;
    padding: 10px 8px;
    border: 0;
    border-radius: 8px;
    color: var(--page-text);
    background: transparent;
    cursor: pointer;
}

.profile-link:hover,
.settings-toggle:hover {
    background: var(--surface-soft);
    color: var(--brand);
}

.settings-panel {
    display: none;
    padding: 12px 9px 4px;
    border-top: 1px solid var(--border);
    margin-top: 8px;
}

.settings-panel.open {
    display: block;
}

.setting-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin: 12px 0;
    color: var(--muted-text);
    font-size: 14px;
}

.setting-row select {
    max-width: 130px;
    padding: 6px;
    border: 1px solid var(--border);
    border-radius: 7px;
    background: var(--surface);
    color: var(--page-text);
}

.logout-link {
    color: #c0392b;
}

.container {
    width: min(1200px, calc(100% - 36px));
    margin: 0 auto;
}

/* Hero section */
.hero {
    position: relative;
    isolation: isolate;
    overflow: hidden;
    margin-top: 28px;
    min-height: 320px;
    border-radius: 20px;
    padding: clamp(28px, 5vw, 52px);
    display: flex;
    flex-direction: column;
    justify-content: center;
    color: #fff;
    background: #39251d;
    box-shadow: var(--shadow);
}

.hero::before {
    content: "";
    position: absolute;
    inset: -12px;
    z-index: -2;
    background-image: url("https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=1600&q=85");
    background-size: cover;
    background-position: center;
    filter: blur(6px);
    transform: scale(1.04);
}

.hero::after {
    content: "";
    position: absolute;
    inset: 0;
    z-index: -1;
    background: rgba(25,12,7,.58);
    border-radius: 20px;
}

.hero h1 {
    font-size: clamp(30px, 4.2vw, 48px);
    line-height: 1.14;
    max-width: 720px;
    margin: 0 0 14px;
}

.hero p {
    font-size: 16px;
    line-height: 1.65;
    max-width: 620px;
    margin: 0 0 23px;
    color: #fff4ec;
}

/* Search */
.search-form {
    display: flex;
    gap: 10px;
    width: min(650px, 100%);
}

.search-form input {
    flex: 1;
    min-width: 0;
    padding: 14px 16px;
    border: 1px solid rgba(255,255,255,.65);
    border-radius: 10px;
    outline: none;
    color: #241b16;
    background: #fff;
}

.search-form input:focus {
    border-color: #f0784d;
    box-shadow: 0 0 0 3px rgba(240,120,77,.25);
}

.search-form button {
    border: 0;
    border-radius: 10px;
    padding: 14px 19px;
    color: #fff;
    background: var(--brand);
    font-weight: 700;
    cursor: pointer;
}

.search-form button:hover {
    background: var(--brand-dark);
}

/* General sections */
.section {
    padding: 36px 0 8px;
}

.section-heading {
    display: flex;
    align-items: end;
    justify-content: space-between;
    gap: 16px;
    margin-bottom: 18px;
}

.section-heading h2 {
    margin: 0;
    font-size: clamp(23px, 3vw, 30px);
}

.section-heading p {
    margin: 7px 0 0;
    color: var(--muted-text);
}

/* Food categories with image paths */
.category-grid {
    display: grid;
    grid-template-columns: repeat(7, minmax(0, 1fr));
    gap: 15px;
}

.category-card {
    position: relative;
    height: 150px;
    overflow: hidden;
    padding: 0;
    border: 1px solid var(--border);
    border-radius: 15px;
    background: #39251d;
    cursor: pointer;
    isolation: isolate;
    transition: transform .2s ease, box-shadow .2s ease;
}

.category-card img {
    position: absolute;
    inset: 0;
    z-index: -2;
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform .3s ease;
}

.category-card::after {
    content: "";
    position: absolute;
    inset: 0;
    z-index: -1;
    background: linear-gradient(
        to top,
        rgba(0,0,0,.82),
        rgba(0,0,0,.08)
    );
}

.category-card span {
    position: absolute;
    left: 10px;
    right: 10px;
    bottom: 13px;
    color: white;
    font-size: 16px;
    font-weight: 700;
    text-align: left;
    text-shadow: 0 1px 4px rgba(0,0,0,.5);
}

.category-card:hover,
.category-card.active {
    transform: translateY(-4px);
    box-shadow: 0 9px 22px rgba(45,24,12,.2);
    border-color: var(--brand);
}

.category-card:hover img {
    transform: scale(1.08);
}

/* Restaurant cards */
.restaurant-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0,1fr));
    gap: 20px;
}

.restaurant-card {
    overflow: hidden;
    border-radius: 16px;
    border: 1px solid var(--border);
    background: var(--surface);
    box-shadow: var(--shadow);
    min-width: 0;
    transition: transform .18s ease;
}

.restaurant-card:hover {
    transform: translateY(-4px);
}

.restaurant-image {
    height: 190px;
    width: 100%;
    object-fit: cover;
    display: block;
    background: #e8d7ca;
}

.restaurant-image.placeholder {
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 42px;
}

.restaurant-info {
    padding: 17px;
}

.restaurant-info h3 {
    margin: 0 0 8px;
    font-size: 20px;
}

.restaurant-info p {
    margin: 0 0 13px;
    color: var(--muted-text);
    line-height: 1.5;
    font-size: 14px;
}

.restaurant-address {
    min-height: 21px;
}

.restaurant-actions {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
}

.menu-button {
    display: inline-block;
    background: var(--brand);
    color: white;
    border-radius: 9px;
    padding: 10px 13px;
    font-weight: 700;
    font-size: 14px;
    white-space: nowrap;
}

.menu-button:hover {
    background: var(--brand-dark);
}

.empty-state {
    padding: 28px;
    border-radius: 14px;
    text-align: center;
    background: var(--surface);
    border: 1px solid var(--border);
    color: var(--muted-text);
}

footer {
    margin-top: 48px;
    padding: 24px 18px;
    text-align: center;
    background: var(--surface);
    color: var(--muted-text);
    border-top: 1px solid var(--border);
}

body.reduce-motion *,
body.reduce-motion *::before,
body.reduce-motion *::after {
    animation: none !important;
    transition: none !important;
    scroll-behavior: auto !important;
}

/* Responsive layout */
@media (max-width: 900px) {
    .category-grid {
        grid-template-columns: repeat(4, minmax(0, 1fr));
    }

    .restaurant-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .nav-links {
        gap: 13px;
    }
}

@media (max-width: 620px) {
    .navbar {
        flex-wrap: wrap;
        gap: 12px;
        padding: 13px 16px;
    }

    .nav-links {
        order: 3;
        width: 100%;
        justify-content: space-between;
        font-size: 14px;
    }

    .brand {
        font-size: 22px;
    }

    .hero {
        margin-top: 18px;
        min-height: 300px;
        padding: 26px 20px;
    }

    .search-form {
        flex-direction: column;
    }

    .search-form button {
        width: 100%;
    }

    .category-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .category-card {
        height: 145px;
    }

    .restaurant-grid {
        grid-template-columns: 1fr;
    }

    .restaurant-image {
        height: 210px;
    }

    .section-heading {
        align-items: start;
        flex-direction: column;
    }
}
</style>
</head>

<body>

<header class="navbar">

    <a class="brand" href="<%= contextPath %>/restaurants">
        Andhra <span>Ruchulu</span>
    </a>

    <nav class="nav-links" aria-label="Main navigation">
        <a href="<%= contextPath %>/restaurants">Restaurants</a>
        <a href="<%= contextPath %>/orders">My Orders</a>
        <a href="<%= contextPath %>/cart">Cart</a>
    </nav>

    <div class="profile-area">

        <button type="button"
                class="profile-button"
                id="profileButton"
                aria-expanded="false">
            👤 Profile ▾
        </button>

        <div class="profile-menu" id="profileMenu">

            <% if (loggedIn) { %>

                <div class="profile-heading">
                    <strong>
                        Hello, <%= userName == null || userName.isBlank()
                            ? "Food Lover" : userName %>!
                    </strong>

                    <small><%= email == null ? "" : email %></small>

                    <% if (role != null && !role.isBlank()) { %>
                        <small>Account: <%= role %></small>
                    <% } %>
                </div>

                <a class="profile-link"
                   href="<%= contextPath %>/orders">
                    My Orders
                </a>

            <% } else { %>

                <div class="profile-heading">
                    <strong>Welcome to Andhra Ruchulu</strong>
                    <small>Sign in to manage your account.</small>
                </div>

                <a class="profile-link"
                   href="<%= contextPath %>/login">
                    Login
                </a>

                <a class="profile-link"
                   href="<%= contextPath %>/register">
                    Create Account
                </a>

            <% } %>

            <button class="settings-toggle"
                    id="settingsToggle"
                    type="button"
                    aria-expanded="false">
                ⚙ Settings & Preferences
            </button>

            <div class="settings-panel" id="settingsPanel">

                <div class="setting-row">
                    <label for="themeSelect">Theme</label>
                    <select id="themeSelect">
                        <option value="light">Light</option>
                        <option value="dark">Dark</option>
                    </select>
                </div>

                <div class="setting-row">
                    <label for="textSizeSelect">Text size</label>
                    <select id="textSizeSelect">
                        <option value="normal">Normal</option>
                        <option value="large">Large</option>
                    </select>
                </div>

                <div class="setting-row">
                    <label for="motionToggle">Reduce animations</label>
                    <input type="checkbox" id="motionToggle">
                </div>

            </div>

            <% if (loggedIn) { %>
                <a class="profile-link logout-link"
                   href="<%= contextPath %>/logout">
                    Logout
                </a>
            <% } %>

        </div>
    </div>
</header>

<main class="container">

    <!-- Hero section -->
    <section class="hero">

        <h1>
            Discover the taste of Andhra, delivered to your door.
        </h1>

        <p>
            Find local favourites, comforting meals, and delicious food
            from restaurants around you.
        </p>

        <form class="search-form" id="restaurantSearchForm" role="search">

            <input type="search"
                   id="restaurantSearch"
                   placeholder="Search restaurants or dishes..."
                   aria-label="Search restaurants">

            <button type="submit">Search Restaurants</button>

        </form>
    </section>

    <!-- Food categories with real image URLs -->
    <section class="section" aria-labelledby="categoriesTitle">

        <div class="section-heading">
            <div>
                <h2 id="categoriesTitle">Explore by category</h2>
                <p>Choose what you feel like eating today.</p>
            </div>
        </div>

        <div class="category-grid" id="categoryGrid">

            <button class="category-card"
                    type="button"
                    data-category="Biryani"
                    aria-pressed="false">
                <img
                    src="https://images.unsplash.com/photo-1633945274405-b6c8069047b0?auto=format&fit=crop&w=600&q=85"
                    alt="Biryani"
                    loading="lazy"
                    onerror="this.style.display='none'">
                <span>Biryani</span>
            </button>

            <button class="category-card"
                    type="button"
                    data-category="Pizza"
                    aria-pressed="false">
                <img
                    src="https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=85"
                    alt="Pizza"
                    loading="lazy"
                    onerror="this.style.display='none'">
                <span>Pizza</span>
            </button>

            <button class="category-card"
                    type="button"
                    data-category="Burger"
                    aria-pressed="false">
                <img
                    src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=85"
                    alt="Burger"
                    loading="lazy"
                    onerror="this.style.display='none'">
                <span>Burgers</span>
            </button>

            <button class="category-card"
                    type="button"
                    data-category="Snacks"
                    aria-pressed="false">
                <img
                    src="https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=600&q=85"
                    alt="Snacks and fries"
                    loading="lazy"
                    onerror="this.style.display='none'">
                <span>Snacks</span>
            </button>

            <button class="category-card"
                    type="button"
                    data-category="Cake"
                    aria-pressed="false">
                <img
                    src="https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=600&q=85"
                    alt="Cake and desserts"
                    loading="lazy"
                    onerror="this.style.display='none'">
                <span>Cakes & Desserts</span>
            </button>

            <button class="category-card"
                    type="button"
                    data-category="South Indian"
                    aria-pressed="false">
                <img
                    src="https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=85"
                    alt="South Indian food"
                    loading="lazy"
                    onerror="this.style.display='none'">
                <span>South Indian</span>
            </button>

            <button class="category-card"
                    type="button"
                    data-category="Chinese"
                    aria-pressed="false">
                <img
                    src="https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=600&q=85"
                    alt="Chinese food"
                    loading="lazy"
                    onerror="this.style.display='none'">
                <span>Chinese</span>
            </button>

        </div>
    </section>

    <!-- Restaurants loaded from RestaurantServlet -->
    <section class="section"
             id="restaurantsSection"
             aria-labelledby="restaurantsTitle">

        <div class="section-heading">
            <div>
                <h2 id="restaurantsTitle">Restaurants for you</h2>
                <p>Browse restaurants and open their menus.</p>
            </div>

            <span id="restaurantCount"></span>
        </div>

        <div class="restaurant-grid" id="restaurantGrid">

        <%
            if (restaurants != null && !restaurants.isEmpty()) {

                for (Map<String, Object> restaurant : restaurants) {

                    Object id = restaurant.get("restaurant_id");
                    Object nameValue = restaurant.get("restaurant_name");
                    Object imageValue = restaurant.get("image_path");
                    Object addressValue = restaurant.get("address");
                    Object descriptionValue = restaurant.get("description");

                    String restaurantName =
                        nameValue == null ? "Restaurant" : nameValue.toString();

                    String imagePath =
                        imageValue == null ? "" : imageValue.toString();

                    String address =
                        addressValue == null ? "" : addressValue.toString();

                    String description =
                        descriptionValue == null ? "" : descriptionValue.toString();
        %>

            <article class="restaurant-card"
                     data-name="<%= restaurantName.toLowerCase().replace("\"", "&quot;") %>"
                     data-description="<%= description.toLowerCase().replace("\"", "&quot;") %>"
                     data-address="<%= address.toLowerCase().replace("\"", "&quot;") %>">

                <% if (!imagePath.isBlank()) { %>

                    <img class="restaurant-image"
                         src="<%= imagePath %>"
                         alt="<%= restaurantName %>"
                         loading="lazy"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">

                    <div class="restaurant-image placeholder"
                         style="display:none"
                         aria-hidden="true">
                        🍽️
                    </div>

                <% } else { %>

                    <div class="restaurant-image placeholder"
                         aria-hidden="true">
                        🍽️
                    </div>

                <% } %>

                <div class="restaurant-info">

                    <h3><%= restaurantName %></h3>

                    <p class="restaurant-address">
                        <%= address %>
                    </p>

                    <p>
                        <%= description.isBlank()
                            ? "Discover delicious food and local favourites."
                            : description %>
                    </p>

                    <div class="restaurant-actions">

                        <span>🍴 Fresh favourites</span>

                        <a class="menu-button"
                           href="<%= contextPath %>/menu?restaurantId=<%= id == null ? "" : id %>">
                            View Menu
                        </a>

                    </div>
                </div>
            </article>

        <%
                }
            }
        %>

        </div>

        <div class="empty-state"
             id="emptyState"
             style="display:none">
            No matching restaurants found. Try another search.
        </div>

        <% if (restaurants == null || restaurants.isEmpty()) { %>

            <div class="empty-state" style="margin-top:16px">
                No restaurants are available right now. Please try again later.
            </div>

        <% } %>

    </section>

</main>

<footer>
    © <%= java.time.Year.now() %> Andhra Ruchulu.
    Made with ❤️ for food lovers.
</footer>

<script>
(function () {

    const body = document.body;

    const profileButton = document.getElementById('profileButton');
    const profileMenu = document.getElementById('profileMenu');

    const settingsToggle = document.getElementById('settingsToggle');
    const settingsPanel = document.getElementById('settingsPanel');

    const themeSelect = document.getElementById('themeSelect');
    const textSizeSelect = document.getElementById('textSizeSelect');
    const motionToggle = document.getElementById('motionToggle');

    const searchInput = document.getElementById('restaurantSearch');
    const searchForm = document.getElementById('restaurantSearchForm');

    const cards = Array.from(
        document.querySelectorAll('.restaurant-card')
    );

    const categoryButtons = Array.from(
        document.querySelectorAll('.category-card')
    );

    const emptyState = document.getElementById('emptyState');
    const countLabel = document.getElementById('restaurantCount');

    let activeCategory = '';

    function applyTheme(theme) {
        body.classList.toggle('dark-theme', theme === 'dark');
        themeSelect.value = theme;
        localStorage.setItem('andhraRuchuluTheme', theme);
    }

    function applyTextSize(size) {
        body.classList.toggle('large-text', size === 'large');
        textSizeSelect.value = size;
        localStorage.setItem('andhraRuchuluTextSize', size);
    }

    function applyReducedMotion(enabled) {
        body.classList.toggle('reduce-motion', enabled);
        motionToggle.checked = enabled;

        localStorage.setItem(
            'andhraRuchuluReduceMotion',
            String(enabled)
        );
    }

    applyTheme(
        localStorage.getItem('andhraRuchuluTheme') || 'light'
    );

    applyTextSize(
        localStorage.getItem('andhraRuchuluTextSize') || 'normal'
    );

    applyReducedMotion(
        localStorage.getItem('andhraRuchuluReduceMotion') === 'true'
    );

    /* Profile dropdown */
    profileButton.addEventListener('click', function (event) {

        event.stopPropagation();

        const isOpen = profileMenu.classList.toggle('open');

        profileButton.setAttribute(
            'aria-expanded',
            String(isOpen)
        );
    });

    profileMenu.addEventListener('click', function (event) {
        event.stopPropagation();
    });

    document.addEventListener('click', function () {

        profileMenu.classList.remove('open');

        profileButton.setAttribute('aria-expanded', 'false');
    });

    /* Settings */
    settingsToggle.addEventListener('click', function () {

        const isOpen = settingsPanel.classList.toggle('open');

        settingsToggle.setAttribute(
            'aria-expanded',
            String(isOpen)
        );
    });

    themeSelect.addEventListener('change', function () {
        applyTheme(this.value);
    });

    textSizeSelect.addEventListener('change', function () {
        applyTextSize(this.value);
    });

    motionToggle.addEventListener('change', function () {
        applyReducedMotion(this.checked);
    });

    /* Search and category filtering */
    function filterRestaurants() {

        const query = searchInput.value.trim().toLowerCase();

        let visibleCount = 0;

        cards.forEach(function (card) {

            const haystack = [
                card.dataset.name || '',
                card.dataset.description || '',
                card.dataset.address || ''
            ].join(' ');

            const matchesQuery =
                !query || haystack.includes(query);

            const matchesCategory =
                !activeCategory ||
                haystack.includes(activeCategory.toLowerCase());

            const show = matchesQuery && matchesCategory;

            card.style.display = show ? '' : 'none';

            if (show) {
                visibleCount++;
            }
        });

        if (countLabel) {
            countLabel.textContent =
                visibleCount +
                (visibleCount === 1 ? ' restaurant' : ' restaurants');
        }

        if (emptyState) {
            emptyState.style.display =
                cards.length > 0 && visibleCount === 0
                    ? 'block'
                    : 'none';
        }
    }

    searchForm.addEventListener('submit', function (event) {

        event.preventDefault();

        filterRestaurants();

        document.getElementById('restaurantsSection').scrollIntoView({
            behavior: body.classList.contains('reduce-motion')
                ? 'auto'
                : 'smooth'
        });
    });

    searchInput.addEventListener('input', filterRestaurants);

    categoryButtons.forEach(function (button) {

        button.addEventListener('click', function () {

            const category = button.dataset.category || '';

            activeCategory =
                activeCategory === category ? '' : category;

            categoryButtons.forEach(function (item) {

                const selected =
                    item.dataset.category === activeCategory;

                item.classList.toggle('active', selected);

                item.setAttribute(
                    'aria-pressed',
                    String(selected)
                );
            });

            searchInput.value = '';

            filterRestaurants();

            document.getElementById('restaurantsSection').scrollIntoView({
                behavior: body.classList.contains('reduce-motion')
                    ? 'auto'
                    : 'smooth'
            });
        });
    });

    filterRestaurants();

})();
</script>

</body>
</html>