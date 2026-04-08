
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            height: 100vh;
            background: #2c2c3c;
            font-family: 'Segoe UI', sans-serif;
        }

        .container-box {
            display: flex;
            height: 90vh;
            width: 80%;
            margin: auto;
            margin-top: 30px;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0px 10px 40px rgba(0,0,0,0.3);
        }

        .left {
            width: 50%;
            background: url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1') center/cover;
        }

        .right {
            width: 50%;
            background: #1e1e2f;
            color: white;
            padding: 40px;
        }

        .form-control {
            background: #2c2c3c;
            border: none;
            color: white;
        }

        .btn-custom {
            background: #7b5cff;
            color: white;
        }
    </style>

    <style>
        .fade-page {
            animation: fadeIn 0.6s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>


</head>

<body>

<div class="container-box fade-page">

    <div class="left"></div>

    <div class="right">
        <h2>Create Account</h2>

        <form action="RegisterServlet" method="post">

            <input type="text" name="username" class="form-control mb-3" placeholder="Username" required>

            <input type="email" name="email" class="form-control mb-3" placeholder="Email" required>

            <input type="password" name="password" class="form-control mb-3" placeholder="Password" required>

            <button class="btn btn-custom w-100">Register</button>

        </form>

        <p class="mt-3">Already have account? <a href="login.jsp">Login</a></p>
    </div>

</div>

</body>
</html>