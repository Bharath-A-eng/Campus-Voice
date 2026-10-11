# Campus Voice — College Complaint Management System

Campus Voice is a Java-based web application designed to help students submit complaints and report issues related to college facilities and services. It provides a centralized platform for managing complaints and tracking their status.

## Features

- **Student Registration and Login:** Allows students to access the application.
- **Complaint Submission:** Students can submit complaints about college-related issues.
- **Complaint Tracking:** View submitted complaints and their current status.
- **User Profile:** Access and manage profile information.
- **Admin Login:** Provides administrative access to complaint management.
- **Complaint Status Updates:** Administrators can update complaint statuses.
- **Dashboard:** Provides access to relevant complaint information.

## Technologies Used

| Technology | Purpose |
|---|---|
| Java | Backend programming |
| Java Servlets | Request handling and application logic |
| JSP | Dynamic web pages |
| JDBC | Database connectivity |
| MySQL | Database management |
| Apache Tomcat | Web application server |
| HTML and CSS | User interface |
| JavaScript | Client-side interactions |
| Git and GitHub | Version control |
| IntelliJ IDEA | Development environment |

## Project Structure

```text
CampusVoice/
├── src/
│   └── Java source files
├── web/
│   ├── complaint.jsp
│   ├── profile.jsp
│   ├── userDashboard.jsp
│   └── viewComplaints.jsp
├── .gitignore
└── README.md
```

Note: Update this structure to match the actual repository, including the servlet, utility, database, and other JSP files.

## Prerequisites

- JDK compatible with the project
- Apache Tomcat compatible with the application's Servlet API
- MySQL Server
- IntelliJ IDEA
- MySQL Connector/J

## Installation and Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Bharath-A-eng/Campus-Voice.git
```

### 2. Open the Project

Open the cloned repository in IntelliJ IDEA and configure the project JDK.

### 3. Configure the Database

Start MySQL Server and create the database and tables required by the application. Use the existing database queries and source code to determine the correct schema.

### 4. Configure Database Connectivity

Locate the database connection configuration in the project source code and update the connection URL, database name, username, and password for your local environment.

Do not publish real database credentials or other secrets to GitHub.

### 5. Configure the Application Server

Configure Apache Tomcat in IntelliJ IDEA and deploy the web application. Ensure that the Java, Servlet API, and Tomcat versions are compatible.

### 6. Run the Application

Start Tomcat and open the deployed application in your browser. For example:

```text
http://localhost:8080/CampusVoice/
```

The URL may differ depending on the deployment configuration.

## Security Considerations

- Keep database credentials and secrets out of source control.
- Use secure password hashing.
- Validate user input on the server.
- Restrict administrative actions to authorized users.
- Use parameterized SQL queries to help prevent SQL injection.

## Future Improvements

- Add email or in-app notifications for complaint updates.
- Improve dashboard charts and complaint statistics.
- Add filtering and search for complaints.
- Improve mobile responsiveness.
- Add automated testing and deployment documentation.

## Project Objective

Campus Voice aims to provide students with a convenient and organized way to raise college-related concerns and help administrators manage complaints transparently.

## Developer

**Bharath A-eng**

GitHub: https://github.com/Bharath-A-eng

Project Repository: https://github.com/Bharath-A-eng/Campus-Voice
