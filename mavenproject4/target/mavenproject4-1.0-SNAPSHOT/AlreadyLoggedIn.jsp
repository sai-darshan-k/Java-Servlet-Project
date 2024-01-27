<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date, java.text.SimpleDateFormat, jakarta.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html>
<head>
    <title>Already Logged In</title>
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }

        #content-container {
            text-align: center;
        }
    </style>
</head>
<body>
    <div id="content-container">
        <%
            HttpSession mySession = request.getSession(false);

            // Check if the user is logged in
            if (mySession != null && mySession.getAttribute("username") != null) {
                String username = (String) mySession.getAttribute("username");
                Date login_time = (Date) mySession.getAttribute("login_time");

                // Format the login time using SimpleDateFormat
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String formattedLoginTime = sdf.format(login_time);

                // Display user information
        %>
                <h2>You are already logged in, <%= username %></h2>
                <p>Login Time: <%= formattedLoginTime %></p>
                <a href="Welcome.jsp">Go to Welcome Page</a>
        <%
            } else {
                // Redirect to login page if the user is not logged in
                response.sendRedirect("index.html"); 
            }
        %>
    </div>
</body>
</html>
