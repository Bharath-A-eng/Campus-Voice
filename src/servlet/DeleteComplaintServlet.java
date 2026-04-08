package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/DeleteComplaintServlet")
public class DeleteComplaintServlet extends HttpServlet {

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
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("userDashboard.jsp?msg=error");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/complaint_db",
                    "root",
                    "bharath@123");
                 PreparedStatement ps = con.prepareStatement(
                         "DELETE FROM complaints WHERE id=? AND username=?")) {

                ps.setInt(1, id);
                ps.setString(2, username);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("userDashboard.jsp?msg=deleted");
                } else {
                    response.sendRedirect("userDashboard.jsp?msg=error");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("userDashboard.jsp?msg=error");
        }
    }
}

