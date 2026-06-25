<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IronFlow PTW - Register</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            background: linear-gradient(135deg, #0b0f19 0%, #111827 100%);
            min-height: 100vh;
        }
        .register-container {
            width: 100%;
            max-width: 500px;
            text-align: center;
            background-color: var(--bg-card);
            padding: 40px;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            border: var(--border-width) solid var(--border-color);
        }
        .logo-area {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            margin-bottom: 24px;
        }
        .logo-icon {
            font-size: 36px;
            color: var(--primary);
            background-color: rgba(56, 189, 248, 0.1);
            padding: 12px;
            border-radius: 12px;
        }
        .logo-text {
            font-size: 24px;
            font-weight: 700;
            color: var(--text-primary);
            letter-spacing: -0.5px;
        }
        .register-form {
            display: flex;
            flex-direction: column;
            gap: 16px;
            text-align: left;
            margin-top: 20px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .form-group label {
            color: var(--text-secondary);
            font-size: 14px;
            font-weight: 500;
        }
        .form-control, .form-select {
            background-color: var(--bg-surface);
            border: var(--border-width) solid var(--border-color);
            color: var(--text-primary);
            padding: 12px 16px;
            border-radius: var(--radius-md);
            font-size: 16px;
            outline: none;
            transition: border-color var(--transition-fast);
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
        }
        .btn-submit {
            background-color: var(--primary);
            color: #fff;
            border: none;
            padding: 14px;
            border-radius: var(--radius-md);
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color var(--transition-fast);
            margin-top: 10px;
        }
        .btn-submit:hover {
            background-color: var(--primary-hover);
        }
        .error-message {
            background-color: rgba(239, 68, 68, 0.1);
            color: var(--danger);
            padding: 12px;
            border-radius: var(--radius-md);
            margin-bottom: 20px;
            font-size: 14px;
            border: 1px solid rgba(239, 68, 68, 0.2);
            text-align: left;
        }
        .login-link {
            margin-top: 24px;
            color: var(--text-secondary);
            font-size: 14px;
        }
        .login-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="register-container">
        <div class="logo-area">
            <span class="material-symbols-outlined logo-icon">person_add</span>
            <span class="logo-text">Create Account</span>
        </div>
        
        <p style="color: var(--text-secondary); margin-bottom: 20px;">Register for IronFlow PTW Access</p>

        <c:if test="${not empty error}">
            <div class="error-message">
                <span class="material-symbols-outlined" style="vertical-align: middle; font-size: 18px; margin-right: 4px;">error</span>
                <c:out value="${error}" />
            </div>
        </c:if>

        <form class="register-form" action="${pageContext.request.contextPath}/auth" method="post">
            <input type="hidden" name="action" value="register">
            
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" class="form-control" required autofocus>
            </div>
            
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" required>
            </div>
            
            <div class="form-group">
                <label for="role">Role</label>
                <select id="role" name="role" class="form-select" required>
                    <option value="">Select a role...</option>
                    <option value="Worker">Worker</option>
                    <option value="Supervisor">Supervisor</option>
                    <option value="Safety Officer">Safety Officer</option>
                    <option value="Manager">Manager</option>
                    <option value="Admin">Admin</option>
                </select>
            </div>
            
            <button type="submit" class="btn-submit">Register</button>
        </form>
        
        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/auth?action=login">Log in here</a>
        </div>
    </div>

</body>
</html>
