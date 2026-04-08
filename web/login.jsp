<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>CampusVoice</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            height: 100vh;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #1e1e2f, #2c2c3c);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* MAIN BOX */
        .container-box {
            width: 900px;
            height: 550px;
            display: flex;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0px 20px 60px rgba(0,0,0,0.4);
        }

        /* LEFT PANEL */
        .left {
            width: 50%;
            background: url('https://i.ibb.co/VcXns1tP/image.png') center/cover no-repeat;
            position: relative;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .left::before {
            content: "";
            position: absolute;
            inset: 0;
            background: rgba(0,0,0,0.5);
        }

        .left-text {
            position: relative;
            text-align: center;
        }

        /* RIGHT PANEL */
        .right {
            width: 50%;
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(10px);
            color: white;
            padding: 40px;
            position: relative;
        }

        /* ✅ HOME BUTTON */
        .home-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            border-radius: 20px;
            font-size: 14px;
            padding: 5px 12px;
        }

        /* FLOATING INPUT */
        .form-group {
            position: relative;
            margin-bottom: 25px;
        }

        .form-control {
            width: 100%;
            padding: 12px;
            background: transparent;
            border: 1px solid #aaa;
            color: white;
            border-radius: 5px;
        }

        .form-control:focus {
            outline: none;
            border-color: #7b5cff;
        }

        label {
            position: absolute;
            top: 12px;
            left: 12px;
            color: #aaa;
            transition: 0.3s;
            pointer-events: none;
        }

        .form-control:focus + label,
        .form-control:valid + label {
            top: -8px;
            left: 8px;
            font-size: 12px;
            background: #2c2c3c;
            padding: 0 5px;
            color: #7b5cff;
        }

        /* BUTTON */
        .btn-custom {
            background: #7b5cff;
            border: none;
        }

        .btn-custom:hover {
            background: #5a3fd6;
        }

        /* SWITCH LINK */
        .switch {
            text-align: center;
            margin-top: 15px;
        }

        .switch a {
            color: #7b5cff;
            text-decoration: none;
        }

        /* ANIMATION */
        .fade-page {
            animation: fadeIn 0.6s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* MOBILE */
        @media(max-width: 768px) {
            .container-box {
                flex-direction: column;
                width: 95%;
                height: auto;
            }

            .left {
                height: 200px;
                width: 100%;
            }

            .right {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<div class="container-box fade-page">

    <!-- LEFT -->
    <div class="left">
        <div class="left-text">
            <h2>CampusVoice</h2>
            <p>Your Voice Matters</p>
        </div>
    </div>

    <!-- RIGHT -->
    <div class="right">

        <!-- ✅ GO TO HOME BUTTON -->
        <a href="index.jsp" class="btn btn-outline-light btn-sm home-btn">
            <i class="fas fa-home"></i> Home
        </a>

        <h3>Login</h3>

        <% if ("registered".equals(msg)) { %>
        <div class="alert alert-success">Registration successful!</div>
        <% } %>

        <% if ("invalid".equals(error)) { %>
        <div class="alert alert-danger">Invalid credentials!</div>
        <% } %>

        <form action="LoginServlet" method="post">

            <div class="form-group">
                <input type="text" name="username" class="form-control" required>
                <label>Username</label>
            </div>

            <div class="form-group">
                <input type="password" id="password" name="password" class="form-control" required>
                <label>Password</label>
            </div>

            <div class="form-check mb-2">
                <input type="checkbox" name="remember" class="form-check-input">
                <label class="form-check-label">Remember Me</label>
            </div>

            <a href="forgotPassword.jsp">Forgot Password?</a>

            <button class="btn btn-custom w-100 mt-3">Login</button>
        </form>

        <div class="switch">
            Don’t have account? <a href="register.jsp">Register</a>
        </div>

    </div>

</div>

</body>
</html>