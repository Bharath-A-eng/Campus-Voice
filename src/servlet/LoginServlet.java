package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.security.MessageDigest;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    // 🔐 Password Hash Method (SAME as RegisterServlet)
    private String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes());

        StringBuilder hex = new StringBuilder();
        for (byte b : hash) {
            hex.append(String.format("%02x", b));
        }
        return hex.toString();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/complaint_db",
                    "root",
                    "bharath@123"
            );

            // 🔐 Hash password BEFORE checking
            String hashedPassword = hashPassword(password);

            String query = "SELECT * FROM users WHERE username=? AND password=?";
            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, username);
            ps.setString(2, hashedPassword); // ✅ use hashed password

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                // ✅ Session
                HttpSession session = request.getSession();
                session.setAttribute("username", username);

                // ✅ Remember Me
                String remember = request.getParameter("remember");

                if (remember != null) {
                    Cookie cookie = new Cookie("username", username);
                    cookie.setMaxAge(60 * 60 * 24); // 1 day
                    response.addCookie(cookie);
                } else {
                    Cookie cookie = new Cookie("username", "");
                    cookie.setMaxAge(0);
                    response.addCookie(cookie);
                }

                // ✅ Redirect
                response.sendRedirect("userDashboard.jsp");

            } else {
                response.sendRedirect("login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}