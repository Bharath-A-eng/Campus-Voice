package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/ComplaintServlet")
@MultipartConfig
public class ComplaintServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = (String) request.getSession().getAttribute("username");
        String subject = request.getParameter("subject");
        String description = request.getParameter("description");
        String category = request.getParameter("category"); // ✅ FIX ADDED

        Part filePart = request.getPart("file");
        String fileName = null;

        try {
            // 📁 Upload folder
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            // 📌 Save file
            if (filePart != null && filePart.getSize() > 0) {
                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                filePart.write(uploadPath + File.separator + fileName);
            }

            // 🔍 DEBUG (optional - remove later)
            System.out.println("Category received: " + category);

            // ✅ DB CONNECTION
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/complaint_db",
                    "root",
                    "bharath@123"
            );

            // ✅ UPDATED INSERT QUERY (category added)
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO complaints(username, subject, description, category, file_path, status) VALUES (?,?,?,?,?,?)"
            );

            ps.setString(1, username);
            ps.setString(2, subject);
            ps.setString(3, description);
            ps.setString(4, category);   // ✅ FIXED
            ps.setString(5, fileName);
            ps.setString(6, "Pending");  // default status

            ps.executeUpdate();

            // ✅ Redirect
            response.sendRedirect("userDashboard.jsp?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("complaint.jsp?msg=error");
        }
    }
}