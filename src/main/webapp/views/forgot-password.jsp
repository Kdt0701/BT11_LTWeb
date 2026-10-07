<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: "Segoe UI", sans-serif;
        }

        .forgot-card {
            width: 420px;
            background: #fff;
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 10px 35px rgba(0,0,0,0.15);
        }

        .forgot-card h2 {
            font-weight: 700;
            margin-bottom: 10px;
        }

        .description {
            color: #6c757d;
            text-align: center;
            margin-bottom: 25px;
        }

        .input-group-text {
            background: #f0f0f0;
        }

        .btn-primary {
            border: none;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 18px;
            text-decoration: none;
        }
    </style>
</head>
<body>

<div class="forgot-card">
    <h2 class="text-center">QUÊN MẬT KHẨU</h2>
    <p class="description">Nhập tài khoản, email và mật khẩu mới.</p>

    <c:if test="${alert != null}">
        <div class="alert alert-danger text-center">${alert}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/forgot-password" method="post">
        <div class="mb-3 input-group">
            <span class="input-group-text"><i class="fa fa-user"></i></span>
            <input type="text" class="form-control" name="username"
                   placeholder="Tài khoản" required>
        </div>

        <div class="mb-3 input-group">
            <span class="input-group-text"><i class="fa fa-envelope"></i></span>
            <input type="email" class="form-control" name="email"
                   placeholder="Email đã đăng ký" required>
        </div>

        <div class="mb-3 input-group">
            <span class="input-group-text"><i class="fa fa-lock"></i></span>
            <input type="password" class="form-control" name="newPassword"
                   placeholder="Mật khẩu mới" minlength="6" required>
        </div>

        <div class="mb-3 input-group">
            <span class="input-group-text"><i class="fa fa-lock"></i></span>
            <input type="password" class="form-control" name="confirmPassword"
                   placeholder="Nhập lại mật khẩu mới" minlength="6" required>
        </div>

        <button type="submit" class="btn btn-primary w-100">
            <i class="fa fa-key me-2"></i>Đổi mật khẩu
        </button>
    </form>

    <a class="back-link" href="${pageContext.request.contextPath}/login">
        <i class="fa fa-arrow-left me-1"></i>Quay lại đăng nhập
    </a>
</div>

</body>
</html>
