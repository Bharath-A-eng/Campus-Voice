<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String user = (String) session.getAttribute("username");
    String msg = request.getParameter("msg");
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>CampusVoice</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- AOS -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <!-- ✅ FONT AWESOME (IMPORTANT) -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI';
            transition: 0.4s;
        }

        .dark-mode {
            background: #121212;
            color: white;
        }

        /* NAVBAR */
        .navbar-custom {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            width: 90%;
            padding: 12px 30px;
            display: flex;
            justify-content: space-between;
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(12px);
            border-radius: 15px;
            z-index: 999;
        }

        .navbar-custom a {
            margin-left: 15px;
            text-decoration: none;
            color: white;
            font-weight: 500;
        }

        /* HERO */
        .hero {
            height: 100vh;
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.7)),
            url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1');
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
        }

        .hero h1 {
            font-size: 55px;
            font-weight: bold;
        }

        /* BUTTON */
        .btn-gradient {
            background: linear-gradient(45deg, #00c9a7, #7b5cff);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 30px;
            transition: 0.4s;
        }

        .btn-gradient:hover {
            background: linear-gradient(45deg, #7b5cff, #00c9a7);
            transform: scale(1.05);
        }

        /* CARDS */
        .feature-card {
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            backdrop-filter: blur(10px);
            transition: 0.3s;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            border-color: #00c9a7;
        }

        .feature-card i {
            font-size: 30px;
            margin-bottom: 10px;
            color: #00c9a7;
        }

        /* CONTACT */
        .contact-section {
            background: white;
            padding: 60px 20px;
            margin-top: 60px;
        }

        .contact-box {
            max-width: 500px;
            margin: auto;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0px 5px 25px rgba(0,0,0,0.1);
        }

        .contact-box i {
            margin-right: 8px;
        }

        /* FOOTER */
        .footer {
            text-align: center;
            padding: 15px;
            background: #1e2a38;
            color: white;
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<div class="navbar-custom">
    <div><b><i class="fas fa-graduation-cap"></i> CampusVoice</b></div>

    <div>
        <a href="index.jsp"><i class="fas fa-home"></i> Home</a>

        <% if (user == null) { %>
        <a href="login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a>
        <a href="register.jsp"><i class="fas fa-user-plus"></i> Register</a>
        <% } else { %>
        <a href="userDashboard.jsp"><i class="fas fa-chart-line"></i> Dashboard</a>
        <a href="profile.jsp"><i class="fas fa-user"></i> Profile</a>
        <a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        <% } %>

        <a href="adminLogin.jsp"><i class="fas fa-user-shield"></i> Admin</a>

        <button onclick="toggleDarkMode()" class="btn btn-dark btn-sm ms-2">
            <i class="fas fa-moon"></i>
        </button>
    </div>
</div>

<!-- HERO -->
<div class="hero">
    <div data-aos="fade-up">
        <h1><i class="fas fa-bullhorn"></i> Your Voice Matters</h1>
        <p id="typing"></p>

        <a href="register.jsp" class="btn btn-gradient">
            <i class="fas fa-rocket"></i> Get Started
        </a>

        <a href="login.jsp" class="btn btn-outline-light">
            <i class="fas fa-sign-in-alt"></i> Login
        </a>
    </div>
</div>

<!-- MESSAGE -->
<%
    if ("sent".equals(msg)) {
%>
<div class="alert alert-success text-center mt-4">
    Message sent successfully!
</div>
<%
    }
%>

<!-- FEATURES -->
<div class="container mt-5">
    <div class="row text-center">

        <div class="col-md-4" data-aos="fade-up">
            <div class="feature-card">
                <i class="fas fa-paper-plane"></i>
                <h4>Easy Complaint</h4>
                <p>Submit complaints instantly</p>
            </div>
        </div>

        <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
            <div class="feature-card">
                <i class="fas fa-chart-pie"></i>
                <h4>Track Status</h4>
                <p>Monitor progress easily</p>
            </div>
        </div>

        <div class="col-md-4" data-aos="fade-up" data-aos-delay="400">
            <div class="feature-card">
                <i class="fas fa-bolt"></i>
                <h4>Fast Resolution</h4>
                <p>Quick admin response</p>
            </div>
        </div>

    </div>
</div>

<!-- CONTACT -->
<div class="contact-section">
    <h3 class="text-center mb-4">
        <i class="fas fa-envelope"></i> Contact Us
    </h3>

    <div class="contact-box">
        <form action="ContactServlet" method="post">

            <input type="text" name="name" class="form-control mb-3"
                   placeholder="Your Name" required>

            <input type="email" name="email" class="form-control mb-3"
                   placeholder="Email" required>

            <textarea name="message" class="form-control mb-3"
                      rows="4" placeholder="Message" required></textarea>

            <button class="btn btn-gradient w-100">
                <i class="fas fa-paper-plane"></i> Send Message
            </button>

        </form>
    </div>
</div>

<!-- FOOTER -->
<div class="footer">
    <i class="fas fa-code"></i> Developed by Bharath
</div>

<!-- SCRIPTS -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init();

    function toggleDarkMode() {
        document.body.classList.toggle("dark-mode");
    }

    const text = "A modern platform to raise, track and resolve student complaints.";
    let i = 0;

    function typeEffect() {
        if (i < text.length) {
            document.getElementById("typing").innerHTML += text.charAt(i);
            i++;
            setTimeout(typeEffect, 40);
        }
    }
    typeEffect();
</script>

</body>
</html>