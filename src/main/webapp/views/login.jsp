<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>

    <!-- Bootstrap + FontAwesome -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: "Segoe UI", sans-serif;
        }

        .login-card {
            width: 380px;
            background: white;
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 10px 35px rgba(0,0,0,0.15);
            animation: fadeIn 0.6s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .login-card h2 {
            font-weight: 700;
            margin-bottom: 25px;
        }

        .input-group-text {
            background: #f0f0f0;
        }

        .btn-primary {
            background: #007bff;
            border: none;
            transition: 0.3s;
        }

        .btn-primary:hover {
            background: #0056d2;
        }

        .forgot-link {
            display: block;
            text-align: right;
            margin-top: 8px;
            color: #007bff;
            text-decoration: none;
        }

        .forgot-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="login-card">
    <h2 class="text-center">ĐĂNG NHẬP</h2>

    <!-- Thông báo lỗi -->
    <c:if test="${alert != null}">
        <div class="alert alert-danger text-center">${alert}</div>
    </c:if>

    <form action="login" method="post">

        <!-- Tài khoản -->
        <div class="mb-3 input-group">
            <span class="input-group-text">
                <i class="fa fa-user"></i>
            </span>
            <input type="text" class="form-control" name="username"
                   placeholder="Tài khoản" required>
        </div>

        <!-- Mật khẩu -->
        <div class="mb-3 input-group">
            <span class="input-group-text">
                <i class="fa fa-lock"></i>
            </span>
            <input type="password" class="form-control" name="password"
                   placeholder="Mật khẩu" required>
        </div>

        <a class="forgot-link" href="${pageContext.request.contextPath}/forgot-password">
            Quên mật khẩu?
        </a>

        <button type="submit" class="btn btn-primary w-100 mt-3">
            Đăng nhập
        </button>

        <p class="text-center mt-3">
            Chưa có tài khoản?
            <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
        </p>

    </form>
</div>

</body>
</html>
