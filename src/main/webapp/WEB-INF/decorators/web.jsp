<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title"/></title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            background-color: #f0f2f5;
        }
        main {
            flex: 1;
            /* Đẩy nội dung xuống để không bị Header che (do header fixed-top) */
            margin-top: 76px; 
        }
    </style>
    
    <sitemesh:write property="head"/>
</head>
<body>

    <jsp:include page="/common/web/header.jsp"></jsp:include>

    <main>
        <sitemesh:write property="body"/>
    </main>

    <jsp:include page="/common/web/footer.jsp"></jsp:include>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>