<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String user = (String) session.getAttribute("username");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String path = request.getContextPath();
    int total = 0, pending = 0, resolved = 0, rejected = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Dashboard</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg,#141e30,#243b55);
            color: white;
            font-family: 'Segoe UI', sans-serif;
            min-height: 100vh;
        }

        .navbar-custom {
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(10px);
        }

        .card-box,
        .chart-box,
        .table-container {
            background: rgba(255,255,255,0.08);
            border-radius: 20px;
            padding: 20px;
            color: white;
            box-shadow: 0 10px 25px rgba(0,0,0,0.18);
        }

        .card-box {
            text-align: center;
            transition: 0.3s;
        }

        .card-box:hover {
            transform: translateY(-6px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.35);
        }

        .search-wrapper {
            position: relative;
        }

        .search-wrapper i {
            position: absolute;
            top: 12px;
            left: 15px;
            color: #aaa;
        }

        .search-input {
            padding-left: 40px;
            background: rgba(255,255,255,0.1);
            border: none;
            color: white;
            border-radius: 25px;
        }

        .search-input::placeholder {
            color: #d6d6d6;
        }

        .search-input:focus {
            outline: none;
            box-shadow: 0 0 10px rgba(123,92,255,0.6);
            background: rgba(255,255,255,0.14);
            color: white;
        }

        .preview-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.2);
        }

        th, td {
            vertical-align: middle !important;
        }

        .table-dark {
            --bs-table-bg: transparent;
            --bs-table-striped-bg: rgba(255,255,255,0.03);
            --bs-table-hover-bg: rgba(255,255,255,0.06);
        }

        .badge-pending { background: #ffc107; color: black; }
        .badge-resolved { background: #28a745; }
        .badge-rejected { background: #dc3545; }

        .action-form {
            display: inline-block;
            margin: 0 2px;
        }
    </style>
</head>
<body>

<div class="navbar-custom">
    <b><i class="fas fa-graduation-cap"></i> CampusVoice</b>

    <div>
        <a href="<%= path %>/complaint.jsp" class="btn btn-primary btn-sm">
            <i class="fas fa-plus"></i> New
        </a>
        <a href="<%= path %>/profile.jsp" class="btn btn-info btn-sm">
            <i class="fas fa-user"></i> Profile
        </a>
        <a href="<%= path %>/LogoutServlet" class="btn btn-danger btn-sm">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</div>

<div class="container mt-4 mb-5">
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
        <h4 class="mb-0">Welcome, <%= user %></h4>

        <div>
            <%
                String msg = request.getParameter("msg");
                if ("deleted".equals(msg)) {
            %>
            <span class="badge bg-success p-2">Complaint deleted successfully</span>
            <%
            } else if ("updated".equals(msg)) {
            %>
            <span class="badge bg-success p-2">Complaint updated successfully</span>
            <%
            } else if ("error".equals(msg)) {
            %>
            <span class="badge bg-danger p-2">Something went wrong</span>
            <%
                }
            %>
        </div>
    </div>

    <%
        Connection con = null;
        PreparedStatement statsPs = null;
        PreparedStatement listPs = null;
        ResultSet statsRs = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/complaint_db","root","bharath@123");

            statsPs = con.prepareStatement("SELECT status, COUNT(*) AS cnt FROM complaints WHERE username=? GROUP BY status");
            statsPs.setString(1, user);
            statsRs = statsPs.executeQuery();

            while (statsRs.next()) {
                String s = statsRs.getString("status");
                int cnt = statsRs.getInt("cnt");
                total += cnt;

                if ("Pending".equalsIgnoreCase(s)) pending += cnt;
                else if ("Resolved".equalsIgnoreCase(s)) resolved += cnt;
                else if ("Rejected".equalsIgnoreCase(s)) rejected += cnt;
            }
    %>

    <div class="row text-center mt-4 g-3">
        <div class="col-md-3"><div class="card-box"><h6>Total</h6><h3><%= total %></h3></div></div>
        <div class="col-md-3"><div class="card-box"><h6>Pending</h6><h3><%= pending %></h3></div></div>
        <div class="col-md-3"><div class="card-box"><h6>Resolved</h6><h3><%= resolved %></h3></div></div>
        <div class="col-md-3"><div class="card-box"><h6>Rejected</h6><h3><%= rejected %></h3></div></div>
    </div>

    <div class="row mt-5">
        <div class="col-md-12">
            <div class="chart-box">
                <h5 class="mb-3">Complaint Overview</h5>
                <canvas id="barChart"></canvas>
            </div>
        </div>
    </div>

    <div class="table-container mt-5">
        <div class="search-wrapper mb-3">
            <i class="fas fa-search"></i>
            <input type="text" id="searchInput" class="form-control search-input"
                   placeholder="Search by subject, category, status...">
        </div>

        <div class="table-responsive">
            <table class="table table-dark table-hover text-center align-middle" id="complaintTable">
                <thead>
                <tr>
                    <th>ID</th>
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
                    listPs = con.prepareStatement("SELECT * FROM complaints WHERE username=? ORDER BY id DESC");
                    listPs.setString(1, user);
                    rs = listPs.executeQuery();
                    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy hh:mm a");

                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String subject = rs.getString("subject");
                        String category = rs.getString("category");
                        if (category == null || category.trim().isEmpty()) category = "N/A";

                        Timestamp ts = null;
                        String date = "N/A";
                        try {
                            ts = rs.getTimestamp("created_at");
                            if (ts != null) date = sdf.format(ts);
                        } catch (Exception ignore) {}

                        String status = rs.getString("status");
                        String badgeClass = "badge-pending";
                        if ("Resolved".equalsIgnoreCase(status)) badgeClass = "badge-resolved";
                        else if ("Rejected".equalsIgnoreCase(status)) badgeClass = "badge-rejected";

                        String file = rs.getString("file_path");
                %>
                <tr>
                    <td><%= id %></td>
                    <td><%= subject %></td>
                    <td><%= category %></td>
                    <td><%= date %></td>
                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                    <td>
                        <%
                            if (file != null && !file.trim().isEmpty()) {
                                String lower = file.toLowerCase();
                                String filePath = path + "/uploads/" + file;
                                if (lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") || lower.endsWith(".gif") || lower.endsWith(".webp")) {
                        %>
                        <img src="<%= filePath %>" class="preview-img" alt="Complaint File">
                        <%
                        } else {
                        %>
                        <a href="<%= filePath %>" target="_blank" class="btn btn-info btn-sm">
                            <i class="fas fa-eye"></i> View
                        </a>
                        <%
                            }
                        } else {
                        %>
                        <span class="text-light">No file</span>
                        <%
                            }
                        %>
                    </td>
                    <td>
                        <a href="<%= path %>/complaint.jsp?editId=<%= id %>" class="btn btn-warning btn-sm">
                            <i class="fas fa-edit"></i> Edit
                        </a>

                        <form action="<%= path %>/DeleteComplaintServlet" method="post" class="action-form"
                              onsubmit="return confirm('Are you sure you want to delete this complaint?');">
                            <input type="hidden" name="id" value="<%= id %>">
                            <button type="submit" class="btn btn-danger btn-sm">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <%
    } catch (Exception e) {
    %>
    <div class="alert alert-danger mt-4">Error: <%= e.getMessage() %></div>
    <%
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignore) {}
            try { if (statsRs != null) statsRs.close(); } catch (Exception ignore) {}
            try { if (listPs != null) listPs.close(); } catch (Exception ignore) {}
            try { if (statsPs != null) statsPs.close(); } catch (Exception ignore) {}
            try { if (con != null) con.close(); } catch (Exception ignore) {}
        }
    %>
</div>

<script>
    const searchInput = document.getElementById("searchInput");
    if (searchInput) {
        searchInput.addEventListener("keyup", function() {
            let v = this.value.toLowerCase();
            document.querySelectorAll("#complaintTable tbody tr").forEach(r => {
                r.style.display = r.innerText.toLowerCase().includes(v) ? "" : "none";
            });
        });
    }
</script>

<script>
    const chartCanvas = document.getElementById("barChart");
    if (chartCanvas) {
        new Chart(chartCanvas, {
            type: 'bar',
            data: {
                labels: ['Total', 'Pending', 'Resolved', 'Rejected'],
                datasets: [{
                    label: 'Complaints',
                    data: [<%= total %>, <%= pending %>, <%= resolved %>, <%= rejected %>],
                    backgroundColor: ['#7b5cff', '#ffc107', '#28a745', '#dc3545']
                }]
            },
            options: {
                plugins: { legend: { labels: { color: 'white' } } },
                scales: {
                    x: { ticks: { color: 'white' } },
                    y: { beginAtZero: true, ticks: { color: 'white' } }
                }
            }
        });
    }
</script>

</body>
</html>s