<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gửi phiếu hỗ trợ</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f5f7fa; padding-top: 50px; display: flex; justify-content: center; }
        
        .form-container { background: white; width: 480px; padding: 40px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        
        /* CSS cho Form */
        h2 { margin-top: 0; color: #333; font-size: 22px; }
        .sub-title { color: gray; font-size: 14px; margin-bottom: 25px; display: block; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: #444; font-size: 14px; }
        input[type="text"], textarea { 
            width: 100%; padding: 12px; margin-bottom: 20px; 
            border: 1px solid #ddd; border-radius: 6px; 
            font-family: inherit; font-size: 14px; box-sizing: border-box; 
        }
        input:focus, textarea:focus { border-color: #00aeef; outline: none; }
        
        /* Nút bấm */
        .btn-group { display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px; }
        button { padding: 10px 24px; border-radius: 6px; font-weight: bold; cursor: pointer; border: none; font-size: 14px; }
        .btn-cancel { background: white; border: 1px solid #ccc; color: #666; }
        .btn-submit { background: #00aeef; color: white; }
        .btn-submit:hover { background: #0095ce; }
        
        /* CSS CHO PHẦN THÔNG BÁO THÀNH CÔNG */
        .success-box { text-align: center; padding: 20px; }
        .icon-check { 
            width: 60px; height: 60px; background: #e6f9f0; color: #00c853; 
            border-radius: 50%; font-size: 30px; line-height: 60px; 
            margin: 0 auto 20px; 
        }
        .btn-home { 
            display: inline-block; text-decoration: none; background: #00aeef; color: white; 
            padding: 12px 30px; border-radius: 6px; font-weight: bold; margin-top: 20px; 
        }
        .btn-home:hover { background: #0095ce; }
    </style>
</head>
<body>

    <div class="form-container">
        
        <% 
            // Kiểm tra xem Servlet có gửi tin nhắn thành công sang không
            String successMsg = (String) request.getAttribute("successMessage");
            
            // TRƯỜNG HỢP 1: THÀNH CÔNG -> Hiện thông báo
            if (successMsg != null) { 
        %>
            <div class="success-box">
                <div class="icon-check">✔</div>
                
                <h2 style="color: #00c853;">Gửi thành công!</h2>
                <p style="color: gray;">
                    Cảm ơn bạn đã gửi báo cáo.<br>
                    Đội ngũ kỹ thuật sẽ xử lý vấn đề sớm nhất.
                </p>
                
                <a href="home" class="btn-home">Quay về Trang chủ</a>
            </div>

        <% 
            // TRƯỜNG HỢP 2: BÌNH THƯỜNG -> Hiện Form nhập liệu
            } else { 
        %>
            <h2>Tạo phiếu hỗ trợ mới</h2>
            <span class="sub-title">Nhập thông tin vấn đề bạn đang gặp phải.</span>
            
            <form action="report" method="POST">
                <label>Tiêu đề phiếu *</label>
                <input type="text" name="title" required placeholder="Ví dụ: Lỗi thanh toán...">
                
                <label>Nội dung chi tiết *</label>
                <textarea name="description" rows="6" required placeholder="Mô tả chi tiết..."></textarea>
                
                <div class="btn-group">
                    <a href="home" style="text-decoration:none"><button type="button" class="btn-cancel">Hủy bỏ</button></a>
                    <button type="submit" class="btn-submit">Gửi yêu cầu</button>
                </div>
            </form>
        <% } %>
        
    </div>

</body>
</html>