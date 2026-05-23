<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Employee Registration</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
           background: linear-gradient(135deg, #6a11cb, #2575fc);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden;
            color: #fff;
            flex-direction: column;
        }

        /* Navbar Styling */
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
       
        /* Scrollable Container */
        .form-container {
            width: 100%;
            max-width: 750px;
            max-height: 90%;
            overflow-y: auto;
            background: rgba(255, 255, 255, 0.1);
            box-shadow: 0 8px 32px rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.18);
            box-sizing: border-box;
            margin-top: 60px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            font-size: 2rem;
            color: #fff;
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

        input[type="text"],
        input[type="email"],
        input[type="number"],
        input[type="date"],
        input[type="password"],
        select,
        textarea {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            background: rgba(255, 255, 255, 0.2);
            border: none;
            border-radius: 8px;
            box-shadow: inset 0 4px 6px rgba(0, 0, 0, 0.2);
            color: #fff;
            font-size: 1.1rem;
        }

        input::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        textarea {
            resize: none;
        }

        input[type="submit"] {
            background: linear-gradient(135deg, #6a11cb, #2575fc);
            color: #fff;
            border: none;
            padding: 15px;
            font-size: 1.1rem;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        input[type="submit"]:hover {
            background: linear-gradient(135deg, #2575fc, #6a11cb);
        }

        /* Scrollbar Styling */
        .form-container::-webkit-scrollbar {
            width: 10px;
        }

        .form-container::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.5);
            border-radius: 10px;
        }

        .form-container::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.7);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .form-container {
                padding: 20px;
            }

            h2 {
                font-size: 1.5rem;
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
        <h2>Employee Registration</h2>
        <form name="reg" method="get" action="register_process.jsp">
            <label for="fn">First Name</label>
            <input type="text" name="fn" id="fn" placeholder="Enter first name" required>

            <label for="mn">Middle Name</label>
            <input type="text" name="mn" id="mn" placeholder="Enter middle name">

            <label for="ln">Last Name</label>
            <input type="text" name="ln" id="ln" placeholder="Enter last name" required>

            <label for="ml">Email</label>
            <input type="email" name="ml" id="ml" placeholder="Enter email" required>

            <label for="phone">Phone Number</label>
            <input type="number" name="phone" id="phone" placeholder="Enter phone number" required>

            <label for="dob">Date of Birth</label>
            <input type="date" name="dob" id="dob" required>

            <label for="gender">Gender</label>
            <select name="gender" id="gender" required>
                <option value="">Select Gender</option>
                <option value="male">Male</option>
                <option value="female">Female</option>
                <option value="other">Other</option>
            </select>
            
             <label>Department</label>
            <input type="text" name="department" id="dept" required>

            <label>Designation</label>
            <input type="text" name="designation" id="desig" required>
            

            <label for="address">Address</label>
            <textarea name="address" id="address" rows="3" placeholder="Enter address" required></textarea>

            <label for="password">New Password</label>
            <input type="password" name="password" id="password" placeholder="Enter new password" required>

           <label for="confirm_password">Confirm Password</label>
            <input type="password" name="cpassword" id="cpassword" placeholder="Enter password" required>

            <input type="submit" value="Register Now!">
        </form>
    </div>
</body>
</html>