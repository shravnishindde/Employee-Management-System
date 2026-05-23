<%@ page import="java.sql.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    String message = ""; 
    if (request.getMethod().equalsIgnoreCase("post")) {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("new-password");
        String confirmPassword = request.getParameter("confirm-password");

        if (newPassword != null && confirmPassword != null && newPassword.equals(confirmPassword)) {
            Statement stmt = null;
            ResultSet rs = null;

            try {
                stmt = conn.createStatement();

                // Check if email exists
                String checkQuery = "SELECT e_mail FROM Emp_reg WHERE e_mail='" + email + "'";
                rs = stmt.executeQuery(checkQuery);

                if (rs.next()) {
                    // Email found, update password
                    String updateQuery = "UPDATE Emp_reg SET pass='" + newPassword + "', c_pass='" + confirmPassword + "' WHERE e_mail='" + email + "'";
                    int i = stmt.executeUpdate(updateQuery);

                    if (i > 0) {
                        // Redirect to EmpLogin.jsp after successful reset
                        response.sendRedirect("EmpLogin.jsp");
                        return; // Stop further execution
                    } else {
                        message = "<div class='message error'>Error updating password. Try again.</div>";
                    }
                } else {
                    message = "<div class='message error'>Email not found. Please check again.</div>";
                }

            } catch (Exception e) {
                message = "<div class='message error'>Error: " + e.getMessage() + "</div>";
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        } else {
            message = "<div class='message error'>Passwords do not match!</div>";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #4e54c8, #8f94fb);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
        }

        .form-container {
            width: 100%;
            max-width: 400px;
            background: rgba(255, 255, 255, 0.1);
            box-shadow: 0 8px 32px rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.18);
            color: #fff;
            text-align: center;
        }

        h2 {
            font-size: 2rem;
            margin-bottom: 20px;
            color: #fff;
        }

        .message {
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
            font-size: 1rem;
            font-weight: bold;
        }

        .success {
            background: rgba(76, 175, 80, 0.3);
            color: #a5ffab;
            border: 1px solid rgba(76, 175, 80, 0.7);
        }

        .error {
            background: rgba(244, 67, 54, 0.3);
            color: #ff9a9a;
            border: 1px solid rgba(244, 67, 54, 0.7);
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            margin: 10px 0 5px;
            font-size: 1rem;
            color: rgba(255, 255, 255, 0.9);
        }

        input {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            background: rgba(255, 255, 255, 0.2);
            border: none;
            border-radius: 8px;
            box-shadow: inset 0 4px 6px rgba(0, 0, 0, 0.2);
            color: #fff;
            font-size: 1rem;
        }

        input::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        input[type="submit"] {
            background: linear-gradient(135deg, #6a11cb, #2575fc);
            color: #fff;
            border: none;
            padding: 12px;
            font-size: 1rem;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        input[type="submit"]:hover {
            background: linear-gradient(135deg, #2575fc, #6a11cb);
        }
          .navbar {
    display: flex;
    justify-content: space-between; /* Aligns brand left and links right */
    align-items: center;
    padding: 9px 18px; /* Reduced padding */
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 1000;
    height: 40px; /* Explicitly setting navbar height */
}

.navbar .brand {
    font-size: 1.3rem; /* Slightly smaller font size */
    font-weight: bold;
    color: white;
}

.navbar a {
    color: #fff;
    text-decoration: none;
    margin-left: 15px; /* Reduced spacing */
    font-size: 0.9rem; /* Smaller font size for a compact look */
    font-weight: bold;
    transition: color 0.3s ease;
}

.navbar a:hover {
    color: rgba(255, 255, 255, 0.7);
}

/* Responsive Design */
@media (max-width: 768px) {
    .navbar {
        flex-direction: column;
        align-items: center;
        padding: 8px;
        height: auto; /* Adjust height for smaller screens */
    }
    
    .navbar .brand {
        margin-bottom: 5px;
    }
    
    .navbar a {
        display: block;
        margin: 3px 0;
    }
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
    <div class="form-container">
        <h2>Forgot Password</h2>

        <!-- Display Message Here -->
        <%= message %>

        <form action="forgotpassword.jsp" method="post">
            <label for="email">Enter Your Email:</label>
            <input type="email" id="email" name="email" placeholder="Enter your registered email" required>

            <label for="new-password">New Password:</label>
            <input type="password" id="new-password" name="new-password" placeholder="Enter new password" required>

            <label for="confirm-password">Confirm Password:</label>
            <input type="password" id="confirm-password" name="confirm-password" placeholder="Confirm your password" required>

            <input type="submit" value="Reset Password">
        </form>
    </div>
</body>
</html>