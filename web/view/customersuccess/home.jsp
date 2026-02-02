<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <style>
        /* CSS reset và font chữ chuẩn */
        body { margin: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f7fa; }
        
        /* HEADER */
        .header { background: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e0e0e0; }
        .logo { font-size: 24px; font-weight: bold; color: #333; text-decoration: none; }
        .nav-right { display: flex; align-items: center; gap: 10px; font-size: 14px; color: #555; }
        
        /* Button style trên Header */
        .btn-nav { text-decoration: none; padding: 8px 15px; border: 1px solid #ccc; border-radius: 4px; color: #555; background: white; transition: 0.3s; }
        .btn-nav:hover { background-color: #f0f8ff; color: #00aeef; border-color: #00aeef; }
        
        /* CONTAINER CHÍNH */
        .container { display: flex; justify-content: center; padding: 50px; }
        
        /* CARD LỚN */
        .banner-card { width: 900px; background: white; border-radius: 20px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); display: flex; overflow: hidden; }
        
        /* Cột Trái (Thông tin) */
        .left-panel { flex: 1; padding: 40px; display: flex; flex-direction: column; justify-content: center; }
        .tag { background: #ffe6eb; color: #ff3250; padding: 5px 10px; border-radius: 4px; font-weight: bold; font-size: 12px; width: fit-content; margin-bottom: 15px; }
        .title-big { font-size: 42px; font-weight: bold; line-height: 1.1; margin-bottom: 10px; color: #333; }
        .text-blue { color: #00aeef; }
        .desc { color: gray; font-size: 14px; margin-bottom: 25px; line-height: 1.5; }
        
        /* Đồng hồ đếm ngược giả lập */
        .timer { display: flex; gap: 15px; margin-bottom: 30px; }
        .time-box { text-align: center; }
        .time-num { font-size: 20px; font-weight: bold; display: block; }
        .time-label { font-size: 11px; color: gray; text-transform: uppercase; }
        
        .btn-buy { background: #00aeef; color: white; border: none; padding: 12px 30px; border-radius: 6px; font-weight: bold; font-size: 16px; cursor: pointer; transition: 0.2s; }
        .btn-buy:hover { background: #0095ce; }

        /* Cột Phải (Gradient) */
        .right-panel { flex: 1; background: linear-gradient(135deg, #00b4db 0%, #ffaf7b 100%); padding: 30px; position: relative; color: white; display: flex; flex-direction: column; justify-content: flex-end; }
        .badge { position: absolute; top: 20px; right: 20px; background: rgba(0,0,0,0.5); padding: 5px 12px; border-radius: 4px; font-size: 12px; }
        .course-name { font-size: 24px; font-weight: bold; margin-bottom: 5px; }
        .price-box { margin-top: 10px; }
        .price-new { font-size: 36px; font-weight: bold; }
        .price-old { text-decoration: line-through; opacity: 0.8; font-size: 16px; margin-left: 10px; }
    </style>
</head>
<body>

    <div class="header">
        <a href="home" class="logo">LearnSphere</a>
        <div class="nav-right">
            <a href="report" class="btn-nav">🛠 Báo cáo sự cố</a>
            <a href="history" class="btn-nav">⏳ Lịch sử</a>
            <span style="margin-left: 10px; border-left: 2px solid #ddd; padding-left: 10px;">
                Chào, <b>${sessionScope.customerName}</b>
            </span>
        </div>
    </div>

    <div class="container">
        <div class="banner-card">
            <div class="left-panel">
                <div class="tag">ƯU ĐÃI ĐẶC BIỆT</div>
                <div class="title-big">Giảm 70% <br> Gói Masterclass <br> <span class="text-blue">Cao cấp!</span></div>
                <div class="desc">
                    Mở khóa các chiến lược nâng cao trong Thiết kế & Phát triển UX. <br>
                    Cơ hội cuối cùng để nâng cấp kỹ năng của bạn.
                </div>
                
                <div class="timer">
                    <div class="time-box"><span class="time-num">02</span><span class="time-label">Ngày</span></div>
                    <div class="time-box"><span class="time-num">14</span><span class="time-label">Giờ</span></div>
                    <div class="time-box"><span class="time-num">35</span><span class="time-label">Phút</span></div>
                    <div class="time-box"><span class="time-num">12</span><span class="time-label">Giây</span></div>
                </div>

                <button class="btn-buy" onclick="alert('Tính năng thanh toán đang bảo trì!')">Mua ngay | VNPAY</button>
            </div>

            <div class="right-panel">
                <div class="badge">Premium Only</div>
                <div class="course-name">Chiến lược UX Nâng cao</div>
                <div style="font-size: 13px; opacity: 0.9;">Bao gồm 40 giờ video + Chứng chỉ quốc tế</div>
                <div class="price-box">
                    <span class="price-new">$59.00</span>
                    <span class="price-old">$199.00</span>
                </div>
            </div>
        </div>
    </div>

    <% 
        // Lấy thông báo từ Session
        String msg = (String) session.getAttribute("notification");
        
        // Nếu có thông báo thì hiện Alert
        if (msg != null && !msg.isEmpty()) { 
    %>
        <script>
            alert("<%= msg %>");
        </script>
    <% 
            // Xóa thông báo ngay lập tức để không hiện lại khi F5
            session.removeAttribute("notification");
        } 
    %>

</body>
</html>