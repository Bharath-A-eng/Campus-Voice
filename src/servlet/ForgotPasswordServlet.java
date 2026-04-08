package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/complaint_db",
                    "root",
                    "bharath@123"
            );

            PreparedStatement ps = con.prepareStatement(
                    "SELECT password FROM users WHERE email=?"
            );

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String password = rs.getString("password");
                response.getWriter().println("<h3>Your Password: " + password + "</h3>");
            } else {
                response.getWriter().println("<h3>Email not found</h3>");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}