<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String user = (String) session.getAttribute("username");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    boolean editMode = false;
    int editId = 0;
    String subjectValue = "";
    String descriptionValue = "";
    String categoryValue = "";
    String existingFile = null;

    String editIdParam = request.getParameter("editId");
    if (editIdParam != null && !editIdParam.trim().isEmpty()) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            editId = Integer.parseInt(editIdParam);
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/complaint_db", "root", "bharath@123");

            ps = con.prepareStatement("SELECT * FROM complaints WHERE id=? AND username=?");
            ps.setInt(1, editId);
            ps.setString(2, user);
            rs = ps.executeQuery();

            if (rs.next()) {
                editMode = true;
                subjectValue = rs.getString("subject") != null ? rs.getString("subject") : "";
                descriptionValue = rs.getString("description") != null ? rs.getString("description") : "";
                categoryValue = rs.getString("category") != null ? rs.getString("category") : "";
                existingFile = rs.getString("file_path");
            }
        } catch (Exception e) {
            editMode = false;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignore) {}
            try { if (ps != null) ps.close(); } catch (Exception ignore) {}
            try { if (con != null) con.close(); } catch (Exception ignore) {}
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= editMode ? "Edit Complaint" : "Submit Complaint" %></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #1e1e2f, #2c2c3c);
            color: white;
        }

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

        .form-container {
            max-width: 900px;
            margin: 40px auto;
            background: rgba(255,255,255,0.05);
            padding: 30px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }

        .form-control, select {
            background: rgba(255,255,255,0.08);
            border: none;
            color: white;
            border-radius: 8px;
        }

        .form-control::placeholder {
            color: #ccc;
        }

        .form-control:focus, select:focus {
            background: rgba(255,255,255,0.12);
            color: white;
            box-shadow: 0 0 0 0.2rem rgba(123,92,255,0.25);
        }

        select option {
            color: black;
        }

        label i {
            margin-right: 6px;
            color: #00c9a7;
        }

        .upload-box {
            border: 2px dashed #aaa;
            padding: 30px;
            text-align: center;
            border-radius: 10px;
            cursor: pointer;
            transition: 0.3s;
        }

        .upload-box:hover {
            background: rgba(255,255,255,0.1);
        }

        .btn-submit {
            background: linear-gradient(45deg, #7b5cff, #00c9a7);
            border: none;
            color: white;
            padding: 12px;
            border-radius: 8px;
            transition: 0.3s;
        }

        .btn-submit:hover {
            transform: scale(1.02);
            color: white;
        }

        #preview {
            margin-top: 10px;
            display: none;
        }

        #preview img {
            width: 120px;
            border-radius: 10px;
            border: 2px solid #00c9a7;
        }

        .existing-file-box {
            background: rgba(255,255,255,0.07);
            padding: 10px 15px;
            border-radius: 10px;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="navbar-custom">
    <div>
        <b><i class="fa-solid fa-graduation-cap"></i> CampusVoice</b>
    </div>

    <div>
        <a href="userDashboard.jsp"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
        <a href="profile.jsp"><i class="fa-solid fa-user"></i> Profile</a>
        <a href="logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
    </div>
</div>

<div class="form-container">
    <h3 class="mb-4 text-center">
        <i class="fa-solid <%= editMode ? "fa-pen" : "fa-pen-to-square" %>"></i>
        <%= editMode ? "Edit Complaint" : "Submit Complaint" %>
    </h3>

    <form action="<%= editMode ? "EditComplaintServlet" : "ComplaintServlet" %>" method="post" enctype="multipart/form-data">
        <% if (editMode) { %>
        <input type="hidden" name="id" value="<%= editId %>">
        <% } %>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label><i class="fa-solid fa-user"></i> Your Name</label>
                <input type="text" name="username" class="form-control" value="<%= user %>" readonly>
            </div>

            <div class="col-md-6 mb-3">
                <label><i class="fa-solid fa-layer-group"></i> Category</label>
                <select name="category" class="form-control" required>
                    <option value="">Select a category</option>
                    <option <%= "Academic Issues".equals(categoryValue) ? "selected" : "" %>>Academic Issues</option>
                    <option <%= "Infrastructure".equals(categoryValue) ? "selected" : "" %>>Infrastructure</option>
                    <option <%= "Hostel Facilities".equals(categoryValue) ? "selected" : "" %>>Hostel Facilities</option>
                    <option <%= "Library Services".equals(categoryValue) ? "selected" : "" %>>Library Services</option>
                    <option <%= "Cafeteria".equals(categoryValue) ? "selected" : "" %>>Cafeteria</option>
                    <option <%= "Transportation".equals(categoryValue) ? "selected" : "" %>>Transportation</option>
                    <option <%= "Harassment".equals(categoryValue) ? "selected" : "" %>>Harassment</option>
                    <option <%= "Administrative Issues".equals(categoryValue) ? "selected" : "" %>>Administrative Issues</option>
                    <option <%= "Other".equals(categoryValue) ? "selected" : "" %>>Other</option>
                </select>
            </div>
        </div>

        <div class="mb-3">
            <label><i class="fa-solid fa-heading"></i> Subject</label>
            <input type="text" name="subject" class="form-control"
                   placeholder="Brief summary of your complaint" value="<%= subjectValue %>" required>
        </div>

        <div class="mb-3">
            <label><i class="fa-solid fa-align-left"></i> Description</label>
            <textarea name="description" class="form-control" rows="5"
                      placeholder="Provide detailed information" required><%= descriptionValue %></textarea>
        </div>

        <div class="mb-3">
            <label><i class="fa-solid fa-paperclip"></i> Attach File</label>
            <div class="upload-box" id="dropArea">
                <p><i class="fa-solid fa-cloud-arrow-up fa-2x"></i></p>
                <p>Drag & Drop file or click to upload</p>
                <input type="file" name="file" id="fileInput" hidden>
            </div>
            <small class="text-muted">Max file size: 5MB</small>

            <% if (editMode && existingFile != null && !existingFile.trim().isEmpty()) { %>
            <div class="existing-file-box">
                Current file: <a href="uploads/<%= existingFile %>" target="_blank" class="text-info"><%= existingFile %></a>
            </div>
            <% } %>

            <div id="preview">
                <p>Preview:</p>
                <img id="previewImg" alt="Preview">
            </div>
        </div>

        <button class="btn btn-submit w-100" type="submit">
            <i class="fa-solid <%= editMode ? "fa-floppy-disk" : "fa-paper-plane" %>"></i>
            <%= editMode ? "Update Complaint" : "Submit Complaint" %>
        </button>
    </form>
</div>

<script>
    const dropArea = document.getElementById("dropArea");
    const fileInput = document.getElementById("fileInput");
    const preview = document.getElementById("preview");
    const previewImg = document.getElementById("previewImg");

    dropArea.addEventListener("click", () => fileInput.click());

    dropArea.addEventListener("dragover", (e) => {
        e.preventDefault();
        dropArea.style.background = "#333";
    });

    dropArea.addEventListener("dragleave", () => {
        dropArea.style.background = "transparent";
    });

    dropArea.addEventListener("drop", (e) => {
        e.preventDefault();
        dropArea.style.background = "transparent";
        fileInput.files = e.dataTransfer.files;
        showPreview(fileInput.files[0]);
    });

    fileInput.addEventListener("change", () => {
        showPreview(fileInput.files[0]);
    });

    function showPreview(file) {
        if (!file) return;
        if (!file.type.startsWith("image/")) {
            preview.style.display = "none";
            return;
        }

        const reader = new FileReader();
        reader.onload = function(e) {
            preview.style.display = "block";
            previewImg.src = e.target.result;
        };
        reader.readAsDataURL(file);
    }
</script>

</body>
</html>