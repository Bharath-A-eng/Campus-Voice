<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<div class="container mt-5" style="max-width:400px;">
    <h3>Forgot Password</h3>

    <form action="ForgotPasswordServlet" method="post">
        <input type="email" name="email" class="form-control mt-2" placeholder="Enter Email" required>
        <button class="btn btn-primary w-100 mt-3">Get Password</button>
    </form>
</div>

</body>
</html>