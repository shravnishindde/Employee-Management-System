<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>Employee Management System - About Us</title>
    <style>
        /* Global Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            width: 100%;
            height: 100%;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #4e54c8, #8f94fb);
            color: #fff;
        }

        /* Navbar Styling */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 30px;
            background: rgba(0, 0, 0, 0.15);
            backdrop-filter: blur(8px);
            position: fixed;
            width: 100%;
            top: 0;
            left: 0;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            z-index: 100;
        }

        .navbar .brand {
            font-size: 1.4rem;
            font-weight: bold;
            color: #fff;
        }

        .navbar a {
            color: #fff;
            text-decoration: none;
            margin: 0 10px;
            font-size: 0.95rem;
            font-weight: 600;
            position: relative;
            transition: all 0.3s ease;
        }

        .navbar a:hover::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 2px;
            background: #fff;
            left: 0;
            bottom: -3px;
            transition: all 0.3s ease;
        }

        .navbar a:hover {
            color: #ddd;
        }

        /* Hero / Main Section */
       .container {
    display: flex;
    justify-content: space-around;
    align-items: flex-start;
    padding: 80px 40px 40px 40px; /* Reduced top padding */
    gap: 30px;
    flex-wrap: wrap;
    min-height: calc(100vh - 120px); /* Adjust height considering navbar and footer */
}

        .card {
            flex: 1 1 300px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            padding: 25px 20px;
            border-radius: 20px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
            transition: transform 0.5s ease, box-shadow 0.5s ease;
            animation: slideUp 1s ease forwards;
        }

        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 25px rgba(0,0,0,0.4);
        }

        .card h1 {
            font-size: 2rem;
            margin-bottom: 15px;
            background: linear-gradient(90deg, #ffffff, #ccc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .card ul {
            list-style: none;
        }

        .card ul li {
            padding: 8px 0;
            font-size: 1rem;
            position: relative;
            padding-left: 20px;
        }

        .card ul li::before {
            content: "•";
            position: absolute;
            left: 0;
            color: black;
        }

        /* Footer */
        .footer {
            padding: 15px 0;
            text-align: center;
            background: rgba(0, 0, 0, 0.15);
            backdrop-filter: blur(6px);
            color: #ccc;
            font-size: 0.9rem;
            box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.2);
        }

        /* Animations */
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                padding: 10px;
            }
            .navbar a {
                margin: 5px;
            }
            .container {
                flex-direction: column;
                padding-top: 100px;
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
            <a href="#about">About Us</a>
            <a href="EmpLogin.jsp">Login</a>
            <a href="Registration.jsp">Registration</a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container" id="about">
        <!-- Admin Module -->
        <div class="card">
            <h1>Admin Module</h1>
            <ul>
                <li>Admin login authentication</li>
                <li>Approve & reject employee leave requests</li>
                <li>Generate employee salary</li>
                <li>Add, edit, or delete employees</li>
                <li>Set employee salary details</li>
            </ul>
        </div>

        <!-- Employee Module -->
        <div class="card">
            <h1>Employee Module</h1>
            <ul>
                <li>Register & login to the system</li>
                <li>Mark attendance with system time</li>
                <li>Apply for leave</li>
                <li>Check leave status</li>
                <li>View attendance & leave history</li>
            </ul>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        &copy; 2025 Employee Management System | All Rights Reserved
    </div>

</body>
</html>
