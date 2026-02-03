<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f5f7fa; margin: 0; padding: 40px; }
        
        .container { max-width: 1000px; margin: 0 auto; display: flex; gap: 30px; align-items: flex-start; }
        
        /* CỘT TRÁI: THÔNG TIN */
        .profile-card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); width: 300px; text-align: center; position: sticky; top: 20px; }
        .avatar { width: 90px; height: 90px; background: #00aeef; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 36px; font-weight: bold; margin: 0 auto 15px; }
        .info-row { text-align: left; margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 8px; }
        .label { font-size: 11px; color: #888; font-weight: bold; text-transform: uppercase; }
        .value { font-size: 14px; color: #333; font-weight: 500; word-break: break-all; }
        .btn-home { display: inline-block; margin-top: 25px; text-decoration: none; color: #555; font-weight: 600; font-size: 14px; transition: 0.2s; }
        .btn-home:hover { color: #00aeef; }

        /* CỘT PHẢI: KHÓA HỌC */
        .courses-section { flex: 1; }
        .section-header { margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between; }
        .section-title { font-size: 20px; font-weight: bold; color: #333; }
        .badge { background: #00aeef; color: white; font-size: 12px; padding: 3px 10px; border-radius: 12px; font-weight: bold; }
        
        /* GRID & CARD STYLE */
        .course-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 20px; }
        
        .course-card { 
            background: white; 
            border-radius: 10px; 
            overflow: hidden; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.05); 
            transition: 0.3s; 
            text-decoration: none; 
            color: inherit; 
            border: 1px solid #eee;
            display: flex; 
            flex-direction: column; 
            height: 100%; 
        }
        
        .course-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.1); border-color: #00aeef; }
        
        .c-img { height: 140px; background: #f0f2f5; display: flex; align-items: center; justify-content: center; color: #999; font-size: 30px; overflow: hidden; flex-shrink: 0; }
        
        .c-body { padding: 15px; flex: 1; display: flex; flex-direction: column; }
        
        .c-title { font-weight: bold; font-size: 15px; margin-bottom: 5px; line-height: 1.4; }
        
        .c-desc { 
            font-size: 13px; 
            color: #666; 
            line-height: 1.5; 
            margin-bottom: 15px; 
        }
        
        .c-price { font-weight: bold; color: #ff4d4f; font-size: 15px; margin-top: auto; }
        
    </style>
</head>
<body>

    <div class="container">
        
        <div class="profile-card">
            <div class="avatar">
                ${profile.fullName != null ? profile.fullName.charAt(0) : 'U'}
            </div>
            
            <h2 style="margin: 0 0 5px 0; font-size: 22px;">${profile.fullName}</h2>
            <p style="color: #777; font-size: 13px; margin-bottom: 30px;">Học viên</p>

            <div class="info-row">
                <div class="label">Email</div>
                <div class="value">${profile.email}</div>
            </div>

            <div class="info-row">
                <div class="label">Số điện thoại</div>
                <div class="value">${profile.phone != null ? profile.phone : '---'}</div>
            </div>

            <div class="info-row">
                <div class="label">Ngày tham gia</div>
                <div class="value">${profile.createdAt}</div>
            </div>
            
            <a href="home" class="btn-home">← Quay lại trang chủ</a>
        </div>

        <div class="courses-section">
            <div class="section-header">
                <div class="section-title">Khóa học của tôi</div>
                <span class="badge">${myCourses.size()} khóa</span>
            </div>

            <c:if test="${empty myCourses}">
                <div style="background: white; padding: 50px; text-align: center; border-radius: 12px; color: #888; border: 1px dashed #ccc;">
                    <div style="font-size: 40px; margin-bottom: 10px;">🎓</div>
                    <p>Bạn chưa đăng ký khóa học nào.</p>
                </div>
            </c:if>

            <div class="course-grid">
                <c:forEach items="${myCourses}" var="c">
                    <a href="#" class="course-card">
                        <div class="c-img">
                            <c:if test="${c.image != null && !c.image.isEmpty()}">
                                <img src="${c.image}" style="width:100%; height:100%; object-fit: cover;" alt="${c.name}">
                            </c:if>
                            <c:if test="${c.image == null || c.image.isEmpty()}">📖</c:if>
                        </div>
                        <div class="c-body">
                            <div class="c-title">${c.name}</div>
                            <div class="c-desc">${c.description}</div>
                            
                            <div class="c-price">
                                <fmt:setLocale value="vi_VN"/>
                                <fmt:formatNumber value="${c.price}" type="currency"/>
                            </div>
                            
                        </div>
                    </a>
                </c:forEach>
            </div>
        </div>

    </div>

</body>
</html>