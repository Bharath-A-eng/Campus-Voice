package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.File;
import java.io.IOException;
import java.sql.*;

@WebServlet("/EditComplaintServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class EditComplaintServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String username = session != null ? (String) session.getAttribute("username") : null;

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        String subject = request.getParameter("subject");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        Part filePart = request.getPart("file");

        if (idParam == null || subject == null || description == null || category == null ||
                idParam.trim().isEmpty() || subject.trim().isEmpty() || description.trim().isEmpty() || category.trim().isEmpty()) {
            response.sendRedirect("userDashboard.jsp?msg=error");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/complaint_db",
                    "root",
                    "bharath@123")) {

                String existingFile = null;
                try (PreparedStatement checkPs = con.prepareStatement(
                        "SELECT file_path FROM complaints WHERE id=? AND username=?")) {
                    checkPs.setInt(1, id);
                    checkPs.setString(2, username);

                    try (ResultSet rs = checkPs.executeQuery()) {
                        if (rs.next()) {
                            existingFile = rs.getString("file_path");
                        } else {
                            response.sendRedirect("userDashboard.jsp?msg=error");
                            return;
                        }
                    }
                }

                String fileName = existingFile;
                if (filePart != null && filePart.getSize() > 0) {
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();

                    String submitted = filePart.getSubmittedFileName();
                    fileName = System.currentTimeMillis() + "_" + submitted;
                    filePart.write(uploadPath + File.separator + fileName);
                }

                try (PreparedStatement ps = con.prepareStatement(
                        "UPDATE complaints SET subject=?, description=?, category=?, file_path=? WHERE id=? AND username=?")) {
                    ps.setString(1, subject);
                    ps.setString(2, description);
                    ps.setString(3, category);
                    ps.setString(4, fileName);
                    ps.setInt(5, id);
                    ps.setString(6, username);

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        response.sendRedirect("userDashboard.jsp?msg=updated");
                    } else {
                        response.sendRedirect("userDashboard.jsp?msg=error");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("userDashboard.jsp?msg=error");
        }
    }
}
