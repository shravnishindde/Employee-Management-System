<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html lang="en">

<head>

 <title>Employee Management System</title>

 <style>

 /* Global Styles */

 html, body {

 margin: 0;

 padding: 0;

 height: 100%;

 overflow-x: hidden;

 font-family: 'Arial', sans-serif;

 background: linear-gradient(135deg, #4e54c8, #8f94fb);

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



 /* Main Container Styling */

 .main-container {

 display: flex;

 flex-direction: row;

 justify-content: space-between;

 align-items: center;

 margin-top: 80px; /* Account for navbar height */

 padding: 0 10%;

 }



 .text-section {

 max-width: 50%;

 animation: fadeIn 1.5s ease-in-out;

 }



 .text-section h1 {

 font-size: 3.5rem;

 margin-bottom: 20px;

 color: #fff;

 text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.7);

 }



 .text-section p {

 font-size: 1.2rem;

 line-height: 1.8;

 color: rgba(255, 255, 255, 0.9);

 }



 .video-section {

 position: relative;

 max-width: 45%;

 animation: slideIn 1.5s ease-in-out;

 }



 .video-container {

 width: 100%;

 height: auto;

 border-radius: 15px;

 overflow: hidden;

 box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);

 transition: transform 0.5s ease;

 }



 .video-container:hover {

 transform: scale(1.05);

 }



 video {

 width: 100%;

 height: 100%;

 object-fit: cover;

 }



 /* Animations */

 @keyframes fadeIn {

 from {

 opacity: 0;

 transform: translateX(-50px);

 }

 to {

 opacity: 1;

 transform: translateX(0);

 }

 }



 @keyframes slideIn {

 from {

 opacity: 0;

 transform: translateY(50px);

 }

 to {

 opacity: 1;

 transform: translateY(0);

 }

 }



 /* Responsive Design */

 @media (max-width: 768px) {

 .navbar {

 flex-wrap: wrap;

 justify-content: center;

 padding: 10px;

 }



 .navbar a {

 margin: 5px;

 }



 .main-container {

 flex-direction: column;

 text-align: center;

 padding: 20px;

 }



 .text-section {

 max-width: 100%;

 }



 .video-section {

 max-width: 100%;

 margin-top: 20px;

 }



 .video-container {

 width: 100%;

 }

 }

 </style>

</head>

<body>

 <!-- Navbar -->

 <div class="navbar">

 <a href="home.jsp">Home</a>

 <a href="AboutUs.jsp">About Us</a>

 <a href="EmpLogin.jsp">Login</a>

 <a href="Registration.jsp">Registration</a>

 </div>



 <!-- Main Content -->

 <div class="main-container">

 <!-- Text Section -->

 <div class="text-section">

 <h1>Employee Management System</h1>

 <p>

 Welcome to the Employee Management System. Streamline and simplify the management of employee data with our powerful and intuitive platform.

 Manage payrolls, attendance, and performance efficiently all in one place.

 </p>

 </div>



 <!-- Video Section -->

 <div class="video-section">

 <div class="video-container">

 <video autoplay muted loop>

 <source src="http://localhost:8081/MyServlets/Media/videos/homevid.mp4" type="video/mp4">

 

 </video>

 </div>

</div>

</body>

</html>