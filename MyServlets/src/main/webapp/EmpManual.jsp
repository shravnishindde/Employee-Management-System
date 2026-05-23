<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Manual</title>
    <style>
        /* General Page Styles */
        body {
            font-family: 'Poppins', sans-serif;
            background: url('https://source.unsplash.com/1600x900/?office,work') no-repeat center center/cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        /* Glassmorphism Container */
        .manual-container {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
           border-radius: 12px;
            padding: 25px;
            width: 50%;
            max-width: 600px;
            text-align: center;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        }

        /* Headings */
        h2 {
            color: #fff;
            font-size: 24px;
            margin-bottom: 10px;
        }

        p {
            color: #f1f1f1;
            font-size: 16px;
            line-height: 1.6;
        }

        /* List Styling */
        ul {
            list-style: none;
            padding: 0;
            text-align: left;
        }

        ul li {
            background: rgba(255, 255, 255, 0.2);
            padding: 10px;
            border-radius: 8px;
            margin: 5px 0;
            color: #fff;
            font-size: 15px;
        }

        /* Checkbox & Button */
        .checkbox-container {
            margin-top: 20px;
        }

        input[type="checkbox"] {
            transform: scale(1.3);
            margin-right: 8px;
        }

        button {
            background: linear-gradient(135deg, #5c67f2, #3840a2);
            color: white;
            border: none;
            padding: 12px 20px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 10px;
            transition: 0.3s ease;
            width: 100%;
        }

        button:disabled {
            background-color: rgba(255, 255, 255, 0.4);
            cursor: not-allowed;
        }
    </style>

    <script>
        function toggleProceedButton() {
            document.getElementById("proceedBtn").disabled = !document.getElementById("agreeCheckbox").checked;
        }
    </script>
</head>
<body>

    <div class="manual-container">
        <h2>📖 Employee Manual</h2>
        <p>Welcome to our company! Please read the policies carefully:</p>

        <ul>
            <li><strong>🟢 Paid Leaves:</strong> You get <b>5 paid leaves</b> per month.</li>
            <li><strong>🏥 Medical Leaves:</strong> A <b>valid medical certificate</b> is required.</li>
            <li><strong>💰 Annual Salary:</strong> ₹8,00,000 per year or may vary according to position.</li>
            <li><strong>🏆 Performance Bonus:</strong> Awarded based on <b>your performance</b>.</li>
            <li><strong>💼 PF Deduction:</strong>  Deduction for Provident Fund.</li>
            <li><strong>⏳ Working Hours:</strong> Less than <b>8 hours</b> is a <b>half-day</b>.</li>
        </ul>

        
    </div>

</body>
</html>