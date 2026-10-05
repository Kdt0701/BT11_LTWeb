<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Đăng ký tài khoản</title>

<!-- Google Font -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<!-- Bootstrap + Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
    body {
        margin: 0;
        padding: 0;
        min-height: 100vh;
        font-family: "Poppins", sans-serif;
        background: linear-gradient(135deg, #6a11cb, #2575fc);
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .register-card {
        width: 420px;
        padding: 35px;
        border-radius: 25px;
        background: rgba(255, 255, 255, 0.12);
        backdrop-filter: blur(12px);
        box-shadow: 0 12px 40px rgba(0,0,0,0.25);
        animation: fadeIn 0.6s ease;
    }

    @keyframes fadeIn {
        from {opacity: 0; transform: translateY(25px);}
        to {opacity: 1; transform: translateY(0);}
    }

    .title {
        text-align: center;
        font-size: 28px;
        font-weight: 600;
        color: #fff;
        margin-bottom: 25px;
    }

    .form-group {
        position: relative;
        margin-bottom: 22px;
    }

    .form-control {
        background: rgba(255, 255, 255, 0.15);
        border: 1px solid rgba(255,255,255,0.3);
        color: #fff;
        padding: 12px 18px;
        border-radius: 12px;
        font-size: 15px;
    }

    .form-control::placeholder {
        color: #e6e6e6;
    }

    .input-icon {
        position: absolute;
        right: 15px;
        top: 50%;
        transform: translateY(-50%);
        color: #ddd;
    }

    .btn-submit {
        width: 100%;
        padding: 12px;
        background: #fff;
        color: #6a11cb;
        border: none;
        border-radius: 12px;
        font-size: 17px;
        font-weight: 600;
        transition: 0.3s;
    }

    .btn-submit:hover {
        background: #f0e9ff;
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(255,255,255,0.3);
    }

    .bottom-text {
        text-align: center;
        margin-top: 15px;
        color: #fff;
    }

    .bottom-text a {
        color: #fffd;
        text-decoration: underline;
        font-weight: 600;
    }

    .alert-custom {
        background: rgba(255, 77, 77, 0.85);
        color: white;
        border: none;
        border-radius: 12px;
        padding: 10px;
        text-align: center;
        margin-bottom: 15px;
        backdrop-filter: blur(3px);
    }
</style>
</head>

<body>

<form action="register" method="post" class="register-card">

    <h2 class="title">Tạo tài khoản</h2>

    <!-- Hiển thị lỗi -->
    <c:if test="${alert != null}">
        <div class="alert-custom">${alert}</div>
    </c:if>

    <!-- Username -->
    <div class="form-group">
        <input type="text" name="username" class="form-control" placeholder="Tên đăng nhập" required>
        <i class="fa fa-user input-icon"></i>
    </div>

    <!-- Fullname -->
    <div class="form-group">
        <input type="text" name="fullname" class="form-control" placeholder="Họ và tên" required>
        <i class="fa fa-id-card input-icon"></i>
    </div>

    <!-- Email -->
    <div class="form-group">
        <input type="email" name="email" class="form-control" placeholder="Email" required>
        <i class="fa fa-envelope input-icon"></i>
    </div>

    <!-- Phone -->
    <div class="form-group">
        <input type="text" name="phone" class="form-control" placeholder="Số điện thoại" required>
        <i class="fa fa-phone input-icon"></i>
    </div>

    <!-- Password -->
    <div class="form-group">
        <input type="password" name="password" class="form-control" placeholder="Mật khẩu" required>
        <i class="fa fa-lock input-icon"></i>
    </div>

    <!-- Re-password -->
    <div class="form-group">
        <input type="password" name="repassword" class="form-control" placeholder="Nhập lại mật khẩu" required>
        <i class="fa fa-lock input-icon"></i>
    </div>

    <button type="submit" class="btn-submit">Đăng ký</button>

    <p class="bottom-text">
        Đã có tài khoản? <a href="login.jsp">Đăng nhập</a>
    </p>

</form>

</body>
</html>
