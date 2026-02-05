<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch sử hỗ trợ</title>
    <style>
        body { margin: 0; font-family: 'Segoe UI', sans-serif; height: 100vh; display: flex; flex-direction: column; background: #f5f7fa; }
        
        /* Header */
        .header { background: white; padding: 0 30px; height: 60px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #ddd; }
        .logo { font-weight: bold; font-size: 20px; color: #333; text-decoration: none; }
        .nav a { text-decoration: none; color: #555; margin-left: 20px; font-size: 14px; }
        
        .container { display: flex; flex: 1; margin: 20px; background: white; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; }
        
        /* CỘT TRÁI: DANH SÁCH */
        .sidebar { width: 320px; border-right: 1px solid #eee; overflow-y: auto; display: flex; flex-direction: column; }
        .ticket-item { padding: 15px; border-bottom: 1px solid #f5f5f5; text-decoration: none; color: #333; display: block; transition: 0.2s; }
        .ticket-item:hover { background: #fafafa; }
        .ticket-item.active { background: #e6f7ff; border-left: 4px solid #00aeef; }
        
        .t-id { font-size: 11px; color: #888; margin-bottom: 5px; }
        .t-title { font-weight: 600; font-size: 14px; margin-bottom: 4px; }
        .status-badge { font-size: 10px; padding: 2px 8px; border-radius: 10px; display: inline-block; border: 1px solid transparent; }
        
        /* CỘT PHẢI: NỘI DUNG */
        .content { flex: 1; display: flex; flex-direction: column; background: white; }
        .chat-area { flex: 1; padding: 30px; overflow-y: auto; display: flex; flex-direction: column; gap: 20px; }
        
        /* Bong bóng chat */
        .msg { max-width: 70%; padding: 12px 18px; border-radius: 12px; line-height: 1.5; font-size: 14px; position: relative; }
        .msg-time { font-size: 10px; margin-top: 5px; opacity: 0.7; text-align: right; }
        
        /* Tin của KHÁCH (Mình) -> Bên Phải, Màu Xanh */
        .msg-me { align-self: flex-end; background: #00aeef; color: white; border-bottom-right-radius: 2px; }
        
        /* Tin của STAFF (Họ) -> Bên Trái, Màu Xám */
        .msg-staff { align-self: flex-start; background: #f0f2f5; color: #333; border-bottom-left-radius: 2px; }
        .staff-name { font-weight: bold; font-size: 11px; margin-bottom: 4px; color: #555; }

        .empty-state { margin: auto; text-align: center; color: #999; }
    </style>
</head>
<body>

    <div class="header">
        <a href="home" class="logo">LearnSphere</a>
        <div class="nav">
            <a href="home">Trang chủ</a>
            <a href="report">Gửi yêu cầu</a>
            <span style="color:#00aeef; font-weight:bold; margin-left:20px;">Hi, ${sessionScope.customerName}</span>
        </div>
    </div>

    <div class="container">
        <div class="sidebar">
            <div style="padding:15px; font-weight:bold; border-bottom:1px solid #eee; background:#fafafa;">
                Lịch sử yêu cầu
            </div>
            
            <c:forEach items="${ticketList}" var="t">
                <a href="history?id=${t.id}" class="ticket-item ${t.id == selectedTicket.id ? 'active' : ''}">
                    <div class="t-id">#${t.id} • ${t.createdAt}</div>
                    <div class="t-title">${t.title}</div>
                    
                    <c:choose>
                        <c:when test="${t.statusId == 1}">
                            <span class="status-badge" style="background:#e6f7ff; color:#1890ff;">Mới gửi</span>
                        </c:when>
                        <c:when test="${t.statusId == 2}">
                            <span class="status-badge" style="background:#fff7e6; color:#fa8c16;">Đang xử lý</span>
                        </c:when>
                        <c:when test="${t.statusId == 3}">
                            <span class="status-badge" style="background:#f6ffed; color:#52c41a;">Đã đóng</span>
                        </c:when>
                    </c:choose>
                </a>
            </c:forEach>
        </div>

        <div class="content">
            <c:if test="${selectedTicket != null}">
                <div class="chat-area">
                    
                    <div class="msg msg-me">
                        <div style="font-weight:bold; margin-bottom:5px; border-bottom:1px solid rgba(255,255,255,0.3); padding-bottom:5px;">
                            ${selectedTicket.title}
                        </div>
                        <div>${selectedTicket.description}</div>
                        <div class="msg-time">${selectedTicket.createdAt}</div>
                    </div>
                    
                    <div style="text-align:center; font-size:11px; color:#ccc; margin: 10px 0;">--- Phản hồi từ hệ thống ---</div>

                    <c:forEach items="${chatHistory}" var="chat">
                        <div class="msg msg-staff">
                            <div class="staff-name">👨‍💻 Chăm sóc khách hàng</div>
                            <div>${chat.content}</div>
                            <div class="msg-time">${chat.createdAt}</div>
                        </div>
                    </c:forEach>

                    <c:if test="${selectedTicket.statusId == 3}">
                        <div style="text-align:center; color:#999; font-size:12px; margin-top:20px;">
                            Phiếu này đã được giải quyết xong.
                        </div>
                    </c:if>

                </div>
            </c:if>

            <c:if test="${selectedTicket == null}">
                <div class="empty-state">
                    <h3>Chào mừng trở lại!</h3>
                    <p>Chọn một phiếu bên trái để xem chi tiết phản hồi.</p>
                </div>
            </c:if>
        </div>
    </div>

</body>
</html>