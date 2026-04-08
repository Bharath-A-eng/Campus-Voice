<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String error = request.getParameter("error");
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- ✅ FONT AWESOME -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

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
            animation: fadeIn 0.6s ease-in-out;
        }

        /* LEFT */
        .left {
            width: 50%;
            background: url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1') center/cover;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
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

        .left-text img {
            width: 70px;
            margin-bottom: 10px;
        }

        /* RIGHT */
        .right {
            width: 50%;
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(10px);
            color: white;
            padding: 40px;
        }

        /* FLOATING INPUT */
        .form-group {
            position: relative;
            margin-bottom: 25px;
        }

        .form-control {
            width: 100%;
            padding: 12px 12px 12px 40px;
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
            left: 40px;
            color: #aaa;
            transition: 0.3s;
        }

        .form-control:focus + label,
        .form-control:valid + label {
            top: -8px;
            left: 30px;
            font-size: 12px;
            background: #2c2c3c;
            padding: 0 5px;
            color: #7b5cff;
        }

        /* ICONS */
        .input-icon {
            position: absolute;
            top: 12px;
            left: 10px;
            color: #aaa;
        }

        /* BUTTON */
        .btn-custom {
            background: #7b5cff;
            border: none;
        }

        .btn-custom:hover {
            background: #5a3fd6;
        }

        /* FADE */
        @keyframes fadeIn {
            from {opacity:0; transform:translateY(20px);}
            to {opacity:1; transform:translateY(0);}
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

<div class="container-box">

    <!-- LEFT -->
    <div class="left">
        <div class="left-text">
            <!-- ✅ LOGO -->
            <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png" alt="Logo">

            <h2>CampusVoice Admin</h2>
            <p>Manage Complaints Efficiently</p>
        </div>
    </div>

    <!-- RIGHT -->
    <div class="right">

        <h3 class="mb-4">Admin Login</h3>

        <% if ("invalid".equals(error)) { %>
        <div class="alert alert-danger">Invalid Admin Credentials</div>
        <% } %>

        <form action="AdminLoginServlet" method="post">

            <!-- USERNAME -->
            <div class="form-group">
                <i class="fa fa-user input-icon"></i>
                <input type="text" name="username" class="form-control" required>
                <label>Admin Username</label>
            </div>

            <!-- PASSWORD -->
            <div class="form-group">
                <i class="fa fa-lock input-icon"></i>
                <input type="password" name="password" class="form-control" required>
                <label>Password</label>
            </div>

            <button class="btn btn-custom w-100">Login</button>

        </form>

        <div class="mt-3 text-center">
            <a href="index.jsp" style="color:#ccc;">← Back to Home</a>
        </div>

    </div>

</div>

</body>
</html>