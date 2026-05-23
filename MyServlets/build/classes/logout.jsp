<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Logout Page</title>
  <style>
    /* Global Styles */
    body {
      margin: 0;
      padding: 0;
      font-family: 'Arial', sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      background: linear-gradient(135deg, #4e54c8, #8f94fb);
      overflow: hidden;
    }

    /* Glassmorphism Container */
    .glass-container {
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 20px;
      padding: 40px;
      text-align: center;
      max-width: 400px;
      color: #fff;
      animation: fadeIn 1s ease-in-out;
    }

    /* Header Text */
    .glass-container h1 {
      font-size: 2.5rem;
      margin-bottom: 20px;
      color: #ffffff;
      text-shadow: 0 2px 5px rgba(0, 0, 0, 0.5);
    }

    .glass-container p {
      font-size: 1.2rem;
      margin-bottom: 30px;
      line-height: 1.6;
    }

    /* Button Styling */
    .glass-container a {
      display: inline-block;
      text-decoration: none;
      background: linear-gradient(135deg, #6a11cb, #2575fc);
      color: #fff;
      padding: 12px 25px;
      border-radius: 25px;
      font-size: 1rem;
      font-weight: bold;
      transition: transform 0.3s ease, background 0.3s ease, box-shadow 0.3s ease;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
    }

    .glass-container a:hover {
      transform: scale(1.1);
      background: linear-gradient(135deg, #2575fc, #6a11cb);
      box-shadow: 0 6px 15px rgba(0, 0, 0, 0.5);
    }

    /* Animations */
    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: translateY(-30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
  </style>
</head>
<body>
  <div class="glass-container">
    <h1>Logout</h1>
    <p>Are you sure you want to logout?</p>
    <a href="home.jsp">Yes, Logout</a>
  </div>
</body>
</html>
