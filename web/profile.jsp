<%@ page import="java.sql.*" %>

<%
  String user = (String) session.getAttribute("username");

  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  String email = "";

  try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/complaint_db",
            "root",
            "bharath@123"
    );

    PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM users WHERE username=?"
    );

    ps.setString(1, user);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
      email = rs.getString("email");
    }

  } catch (Exception e) {
    out.println(e);
  }
%>

<html>
<head>
  <meta charset="UTF-8">
  <title>My Profile</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body {
      margin: 0;
      font-family: 'Segoe UI';
      background: linear-gradient(135deg, #1e1e2f, #2c2c3c);
      color: white;
    }

    /* NAVBAR */
    .navbar-custom {
      padding: 15px 40px;
      display: flex;
      justify-content: space-between;
      background: rgba(255,255,255,0.05);
      backdrop-filter: blur(10px);
    }

    .navbar-custom a {
      color: white;
      margin-left: 20px;
      text-decoration: none;
    }

    /* PROFILE CARD */
    .profile-container {
      max-width: 800px;
      margin: 50px auto;
      background: rgba(255,255,255,0.05);
      padding: 30px;
      border-radius: 15px;
      backdrop-filter: blur(10px);
      box-shadow: 0px 10px 30px rgba(0,0,0,0.3);
      animation: fadeIn 0.8s ease-in;
    }

    /* AVATAR */
    .avatar {
      width: 100px;
      height: 100px;
      border-radius: 50%;
      background: linear-gradient(45deg, #7b5cff, #00c9a7);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 45px;
      margin: auto;
      margin-bottom: 20px;
    }

    /* INPUT */
    .form-control {
      background: rgba(255,255,255,0.08);
      border: none;
      color: green;
      border-radius: px;
    }

    .form-control::placeholder {
      color: #ccc;
    }

    /* BUTTON */
   .btn-update {
       background: linear-gradient(45deg, #7b5cff, #00c9a7);
       border: none;
       color: blue;
       padding: 12px;
       border-radius: 8px;
       transition: 0.3s;
       font-family: 'Segoe UI', sans-serif;
       font-size: 25px;
       font-weight: 500;
   }

    .btn-update:hover {
      transform: scale(1.05);
    }

    /* ANIMATION */
    @keyframes fadeIn {
      from {opacity:0; transform:translateY(20px);}
      to {opacity:1; transform:translateY(0);}
    }
  </style>
</head>

<body>

<!-- NAVBAR -->
<div class="navbar-custom">
  <div><b>🎓 CampusVoice</b></div>

  <div>
    <a href="userDashboard.jsp">Dashboard</a>
    <a href="complaint.jsp">New Complaint</a>
    <a href="logout">Logout</a>
  </div>
</div>

<div class="profile-container text-center">

  <!-- AVATAR -->
  <div class="avatar">
    <%= user.charAt(0) %>
  </div>

  <h3><%= user %></h3>
  <p class="text-muted"><%= email %></p>

  <hr>

  <!-- UPDATE FORM -->
  <form action="UpdateProfileServlet" method="post">

    <div class="mb-3 text-start">
      <label>Username</label>
      <input type="text" name="username" class="form-control"
             value="<%= user %>" readonly>
    </div>

    <div class="mb-3 text-start">
      <label>Email</label>
      <input type="email" name="email" class="form-control"
             value="<%= email %>" required>
    </div>

    <div class="mb-3 text-start">
      <label>New Password</label>
      <input type="password" name="password" class="form-control"
             placeholder="Enter new password">
    </div>



  </form>

</div>

</body>
</html>