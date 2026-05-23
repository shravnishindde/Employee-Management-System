<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
 String errorMessage = (String) session.getAttribute("error");
 session.removeAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Employee Login</title>
<style>

/* General Styling */
body {
    margin: 0;
    padding: 0;
    font-family: 'Arial', sans-serif;
    background: linear-gradient(135deg, #6a11cb, #2575fc);
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #fff;
}

/* Navbar Styling */
.navbar {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    padding: 15px 20px;
    position: fixed;
    top: 0;
    width: 100%;
    background: rgba(0, 0, 0, 0.3);
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    z-index: 1000;
}

.navbar a {
    color: #fff;
    text-decoration: none;
    margin: 0 15px;
    font-size: 1rem;
    font-weight: bold;
    transition: color 0.3s ease;
}

.navbar a:hover {
    color: rgba(255, 255, 255, 0.7);
}

/* Form Styling */
form {
    width: 400px;
    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.3);
    border-radius: 10px;
    padding: 30px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
    text-align: center;
}

h2 {
    margin-bottom: 20px;
}

.error-message {
    color: red;
    font-size: 15px;
    margin-bottom: 10px;
}

/* Form Elements */
form label {
    display: block;
    font-size: 16px;
    margin-bottom: 5px;
    text-align: left;
    color: rgba(255, 255, 255, 0.9);
}

form input,
form select,
form button {
    width: 100%;
    padding: 12px;
    margin-bottom: 15px;
    border: none;
    border-radius: 5px;
    font-size: 16px;
}

form input {
    background: rgba(255, 255, 255, 0.2);
    color: #fff;
    outline: none;
    transition: all 0.3s ease-in-out;
}

form input:focus {
    background: rgba(255, 255, 255, 0.3);
    border: 1px solid #00d2ff;
}

form input::placeholder {
    color: rgba(255, 255, 255, 0.7);
}

form button {
    background: linear-gradient(135deg, #00d2ff, #3a7bd5);
    color: white;
    cursor: pointer;
    font-weight: bold;
    transition: all 0.3s ease;
}

form button:hover {
    background: linear-gradient(135deg, #3a7bd5, #00d2ff);
    transform: scale(1.05);
}

/* Links */
form p a {
    color: #00e6e6;
    text-decoration: none;
}

form p a:hover {
    text-decoration: underline;
}


@media (max-width: 768px) {
    .navbar {
        flex-wrap: wrap;
        justify-content: center;
        padding: 8px;
    }

    .navbar a {
        margin: 5px;
    }

    form {
        width: 90%;
        padding: 20px;
    }
}

.navbar {
    display: flex;
    align-items: center;
    justify-content: space-between; /* Aligns content to the left and right */
   
    padding: 10px 20px;
}

.navbar .brand {
    font-size: 18px;
    font-weight: bold;
    color: white;
}

.navbar a {
    color: white;
    text-decoration: none;
    padding: 10px;
}

.navbar a:hover {
    background-color: #555;
    border-radius: 5px;
}
</style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <div class="brand">Employee Management System</div>
    <div>
        <a href="home.jsp">Home</a>
        <a href="AboutUs.jsp">About Us</a>
        <a href="EmpLogin.jsp">Login</a>
        <a href="Registration.jsp">Registration</a>
       
    </div>
</div>
<!-- Login Form -->
<form action="LoginVal.jsp" method="post">
    <h2>Login</h2>
    <% if (errorMessage != null) { %>
        <p class="error-message"><%= errorMessage %></p>
    <% } %>

    <label for="role">Login as:</label>
    <select id="role" name="role">
        <option value="employee">Employee</option>
        <option value="admin">Admin</option>
    </select>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" placeholder="Enter your email" required>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" placeholder="Enter your password" required>

    <p><a href="forgotpassword.jsp">Forgot Password?</a></p>

    <button type="submit">Login</button>

    <p>New here? <a href="Registration.jsp">Register</a></p>
</form>

</body>
</html>