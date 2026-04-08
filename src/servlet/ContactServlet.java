package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

// 🔥 Uncomment ONLY if you added Jakarta Mail JAR
// import jakarta.mail.*;
// import jakarta.mail.internet.*;
// import java.util.Properties;

@WebServlet("/ContactServlet")
public class ContactServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            // ✅ Load Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // ✅ Connect DB
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/complaint_db",
                    "root",
                    "bharath@123"
            );

            // ✅ Insert into DB
            ps = con.prepareStatement(
                    "INSERT INTO contact_messages(name,email,message) VALUES(?,?,?)"
            );

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, message);

            ps.executeUpdate();

            // =====================================================
            // 🔥 OPTIONAL EMAIL FEATURE (ENABLE LATER)
            // =====================================================
            /*
            String to = "your_email@gmail.com";
            String from = "your_email@gmail.com";
            String host = "smtp.gmail.com";

            final String username = "your_email@gmail.com";
            final String password = "APP_PASSWORD"; // Use Google App Password

            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", "587");

            Session session = Session.getInstance(props,
                new jakarta.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });

            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));

            msg.setSubject("New Contact Message");

            msg.setText(
                "Name: " + name +
                "\nEmail: " + email +
                "\nMessage: " + message
            );

            Transport.send(msg);
            */
            // =====================================================

            // ✅ Redirect success
            response.sendRedirect("index.jsp?msg=sent");

        } catch (Exception e) {
            e.printStackTrace();

            // ❌ Redirect error safely
            response.sendRedirect("index.jsp?msg=error");

        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}