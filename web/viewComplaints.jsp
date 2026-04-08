<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    String admin = (String) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }
%>

<html>
<head>
    <title>Admin Dashboard</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body {
            background: linear-gradient(135deg,#141e30,#243b55);
            color:white;
        }

        .navbar-custom {
            padding:15px 40px;
            display:flex;
            justify-content:space-between;
            background:rgba(255,255,255,0.05);
        }

        .card, .table-container, .chart-box {
            background:rgba(255,255,255,0.08);
            border-radius:20px;
            padding:20px;
            color: white;
        }

        .badge-pending { background:#ffc107; color:black; }
        .badge-resolved { background:#28a745; }
        .badge-rejected { background:#dc3545; }

        .preview-img {
            width:60px;
            border-radius:8px;
        }

        .search-wrapper {
            position:relative;
        }
        .search-wrapper i {
            position:absolute;
            top:12px;
            left:15px;
            color:#aaa;
        }
        .search-input {
            padding-left:40px;
            border-radius:25px;
            background:rgba(255,255,255,0.1);
            border:none;
            color:white;
        }

        th, td {
            text-align:center;
            vertical-align:middle;
        }
    </style>
</head>

<body>

<div class="navbar-custom">
    <b><i class="fas fa-user-shield"></i> Admin Panel</b>
    <div>
        <%= admin %>
        <a href="logout" class="btn btn-danger btn-sm">Logout</a>
    </div>
</div>

<div class="container mt-4">

    <%
        int total=0,pending=0,resolved=0,rejected=0;

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/complaint_db","root","bharath@123");

        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM complaints");

        while(rs.next()){
            total++;
            String s=rs.getString("status");

            if("Pending".equalsIgnoreCase(s)) pending++;
            else if("Resolved".equalsIgnoreCase(s)) resolved++;
            else rejected++;
        }
    %>

    <!-- CARDS -->
    <div class="row text-center mb-4">
        <div class="col-md-3"><div class="card"><h6>Total</h6><h3><%= total %></h3></div></div>
        <div class="col-md-3"><div class="card"><h6>Pending</h6><h3 id="pending"><%= pending %></h3></div></div>
        <div class="col-md-3"><div class="card"><h6>Resolved</h6><h3 id="resolved"><%= resolved %></h3></div></div>
        <div class="col-md-3"><div class="card"><h6>Rejected</h6><h3 id="rejected"><%= rejected %></h3></div></div>
    </div>

    <!-- PIE CHART -->
    <div class="row justify-content-center mb-4">
        <div class="col-md-4">
            <div class="chart-box text-center">
                <h6>Status Overview</h6>
                <canvas id="pieChart"></canvas>
            </div>
        </div>
    </div>

    <!-- SEARCH -->
    <div class="search-wrapper mb-3">
        <i class="fas fa-search"></i>
        <input type="text" id="searchInput" class="form-control search-input"
               placeholder="Search complaints...">
    </div>

    <!-- TABLE -->
    <div class="table-container">
        <table class="table table-dark table-hover" id="complaintTable">

            <thead>
            <tr>
                <th>ID</th>
                <th>User</th>
                <th>Subject</th>
                <th>Category</th>
                <th>Date</th>
                <th>Status</th>
                <th>File</th>
                <th>Action</th>
            </tr>
            </thead>

            <tbody>

            <%
                rs = st.executeQuery("SELECT * FROM complaints ORDER BY id DESC");
                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy hh:mm a");

                while(rs.next()){

                    int id = rs.getInt("id");
                    String status = rs.getString("status");

                    String badgeClass = status.equals("Pending")?"badge-pending":
                            status.equals("Resolved")?"badge-resolved":"badge-rejected";

                    String category = rs.getString("category");
                    if(category==null) category="N/A";

                    Timestamp ts = rs.getTimestamp("created_at");
                    String date = (ts!=null)?sdf.format(ts):"N/A";

                    String file = rs.getString("file_path");
                    String filePath = "uploads/" + file;
            %>

            <tr>
                <td><%= id %></td>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("subject") %></td>
                <td><%= category %></td>
                <td><%= date %></td>

                <td>
                    <span id="status-<%= id %>" class="badge <%= badgeClass %>"><%= status %></span>
                </td>

                <td>
                    <%
                        if(file!=null && !file.isEmpty()){
                            if(file.endsWith(".jpg")||file.endsWith(".png")||file.endsWith(".jpeg")){
                    %>
                    <img src="<%= filePath %>" class="preview-img">
                    <%
                    } else {
                    %>
                    <a href="<%= filePath %>" target="_blank" class="btn btn-info btn-sm">
                        <i class="fas fa-eye"></i>
                    </a>
                    <%
                            }
                        }
                    %>
                </td>

                <td>
                    <button class="btn btn-success btn-sm" onclick="updateStatus(this,<%= id %>,'Resolved')">
                        <i class="fas fa-check"></i>
                    </button>

                    <button class="btn btn-warning btn-sm" onclick="updateStatus(this,<%= id %>,'Pending')">
                        <i class="fas fa-hourglass-half"></i>
                    </button>

                    <button class="btn btn-danger btn-sm" onclick="updateStatus(this,<%= id %>,'Rejected')">
                        <i class="fas fa-times"></i>
                    </button>
                </td>

            </tr>

            <% } %>

            </tbody>
        </table>
    </div>

</div>

<!-- SEARCH -->
<script>
    document.getElementById("searchInput").addEventListener("keyup", function(){
        let v=this.value.toLowerCase();
        document.querySelectorAll("#complaintTable tbody tr").forEach(r=>{
            r.style.display=r.innerText.toLowerCase().includes(v)?"":"none";
        });
    });
</script>

<!-- PIE CHART -->
<script>
    let pendingCount = <%= pending %>;
    let resolvedCount = <%= resolved %>;
    let rejectedCount = <%= rejected %>;

    let pieChart = new Chart(document.getElementById("pieChart"),{
        type:'pie',
        data:{
            labels:['Pending','Resolved','Rejected'],
            datasets:[{
                data:[pendingCount, resolvedCount, rejectedCount],
                backgroundColor:['#ffc107','#28a745','#dc3545']
            }]
        },
        options:{
            plugins:{
                legend:{ labels:{color:'white'} }
            }
        }
    });
</script>

<!-- AJAX STATUS UPDATE -->
<script>
    function updateStatus(btn, id, newStatus){

        btn.disabled = true;

        let badge = document.getElementById("status-"+id);
        let oldStatus = badge.innerText.trim();

        fetch("UpdateStatusServlet",{
            method:"POST",
            headers:{'Content-Type':'application/x-www-form-urlencoded'},
            body:"id="+id+"&status="+newStatus
        })
            .then(res=>res.text())
            .then(data=>{

                badge.classList.remove("badge-pending","badge-resolved","badge-rejected");

                if(newStatus==="Pending") badge.classList.add("badge-pending");
                else if(newStatus==="Resolved") badge.classList.add("badge-resolved");
                else badge.classList.add("badge-rejected");

                badge.innerText = newStatus;

                /* FIX COUNTS */
                if(oldStatus==="Pending") pendingCount--;
                if(oldStatus==="Resolved") resolvedCount--;
                if(oldStatus==="Rejected") rejectedCount--;

                if(newStatus==="Pending") pendingCount++;
                if(newStatus==="Resolved") resolvedCount++;
                if(newStatus==="Rejected") rejectedCount++;

                /* UPDATE CARDS */
                document.getElementById("pending").innerText = pendingCount;
                document.getElementById("resolved").innerText = resolvedCount;
                document.getElementById("rejected").innerText = rejectedCount;

                /* UPDATE CHART */
                pieChart.data.datasets[0].data = [pendingCount, resolvedCount, rejectedCount];
                pieChart.update();

                btn.disabled = false;

            });
    }
</script>

</body>
</html>