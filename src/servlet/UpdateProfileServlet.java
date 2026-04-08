package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/complaint_db",
                    "root",
                    "bharath@123"
            );

            if (password != null && !password.isEmpty()) {
                PreparedStatement ps = con.prepareStatement(
                        "UPDATE users SET email=?, password=? WHERE username=?"
                );
                ps.setString(1, email);
                ps.setString(2, password);
                ps.setString(3, username);
                ps.executeUpdate();
            } else {
                PreparedStatement ps = con.prepareStatement(
                        "UPDATE users SET email=? WHERE username=?"
                );
                ps.setString(1, email);
                ps.setString(2, username);
                ps.executeUpdate();
            }

            response.sendRedirect("profile.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}