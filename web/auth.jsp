<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>CampusVoice Auth</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- ✅ FONT AWESOME -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        body {
            margin: 0;
            height: 100vh;
            background: linear-gradient(135deg, #1e1e2f, #2c2c3c);
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI';
        }

        /* MAIN BOX */
        .container-box {
            width: 900px;
            height: 550px;
            background: #1e1e2f;
            border-radius: 20px;
            overflow: hidden;
            display: flex;
            position: relative;
            box-shadow: 0px 20px 60px rgba(0,0,0,0.4);
        }

        /* LEFT */
        .left {
            width: 50%;
            background: url('https://images.unsplash.com/photo-1501785888041-af3ef285b470') center/cover;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
        }

        .left-content {
            background: rgba(0,0,0,0.5);
            padding: 20px;
            border-radius: 10px;
        }

        .left-content img {
            width: 70px;
            margin-bottom: 10px;
        }

        /* RIGHT */
        .right {
            width: 50%;
            position: relative;
            overflow: hidden;
        }

        /* SLIDE WRAPPER */
        .form-wrapper {
            display: flex;
            width: 200%;
            transition: 0.6s;
        }

        .form-box {
            width: 50%;
            padding: 40px;
            color: white;
        }

        /* INPUT GROUP */
        .form-group {
            position: relative;
            margin-bottom: 25px;
        }

        .form-control {
            background: transparent;
            border: 1px solid #aaa;
            color: white;
            padding-left: 40px;
        }

        .form-control:focus {
            border-color: #7b5cff;
            box-shadow: none;
        }

        /* ICON */
        .input-icon {
            position: absolute;
            top: 12px;
            left: 12px;
            color: #aaa;
        }

        label {
            position: absolute;
            top: 10px;
            left: 40px;
            color: #aaa;
            transition: 0.3s;
        }

        .form-control:focus + label,
        .form-control:valid + label {
            top: -8px;
            font-size: 12px;
            color: #7b5cff;
            background: #1e1e2f;
            padding: 0 5px;
        }

        /* BUTTON */
        .btn-custom {
            background: linear-gradient(45deg, #7b5cff, #00c9a7);
            border: none;
            border-radius: 25px;
        }

        .btn-custom:hover {
            background: linear-gradient(45deg, #5a3fd6, #009e87);
        }

        /* SWITCH */
        .switch {
            text-align: center;
            margin-top: 15px;
        }

        .switch a {
            color: #7b5cff;
            cursor: pointer;
        }

        /* SLIDE */
        .slide {
            transform: translateX(-50%);
        }

        /* MOBILE */
        @media(max-width:768px){
            .container-box {
                flex-direction: column;
                height: auto;
                width: 95%;
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
        <div class="left-content">
            <!-- ✅ LOGO -->
            <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png">

            <h3>CampusVoice</h3>
            <p>Raise & Track Complaints Easily</p>
        </div>
    </div>

    <!-- RIGHT -->
    <div class="right">

        <div id="formWrapper" class="form-wrapper">

            <!-- LOGIN -->
            <div class="form-box">
                <h3 class="mb-4">Login</h3>

                <form action="LoginServlet" method="post">

                    <div class="form-group">
                        <i class="fa fa-user input-icon"></i>
                        <input type="text" name="username" class="form-control" required>
                        <label>Username</label>
                    </div>

                    <div class="form-group">
                        <i class="fa fa-lock input-icon"></i>
                        <input type="password" name="password" class="form-control" required>
                        <label>Password</label>
                    </div>

                    <button class="btn btn-custom w-100">Login</button>
                </form>

                <div class="switch">
                    Don’t have account?
                    <a onclick="showRegister()">Register</a>
                </div>
            </div>

            <!-- REGISTER -->
            <div class="form-box">
                <h3 class="mb-4">Register</h3>

                <form action="RegisterServlet" method="post">

                    <div class="form-group">
                        <i class="fa fa-user input-icon"></i>
                        <input type="text" name="username" class="form-control" required>
                        <label>Username</label>
                    </div>

                    <div class="form-group">
                        <i class="fa fa-envelope input-icon"></i>
                        <input type="email" name="email" class="form-control" required>
                        <label>Email</label>
                    </div>

                    <div class="form-group">
                        <i class="fa fa-lock input-icon"></i>
                        <input type="password" name="password" class="form-control" required>
                        <label>Password</label>
                    </div>

                    <button class="btn btn-custom w-100">Register</button>
                </form>

                <div class="switch">
                    Already have account?
                    <a onclick="showLogin()">Login</a>
                </div>
            </div>

        </div>

    </div>

</div>

<script>
    function showRegister() {
        document.getElementById("formWrapper").classList.add("slide");
    }

    function showLogin() {
        document.getElementById("formWrapper").classList.remove("slide");
    }
</script>

</body>
</html>