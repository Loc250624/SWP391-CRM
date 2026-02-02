<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hệ thống CSKH - Customer Success</title>
    <style>
        /* CSS Layout */
        body { margin: 0; font-family: 'Segoe UI', sans-serif; height: 100vh; display: flex; flex-direction: column; overflow: hidden; background: #f0f2f5; }
        
        .header { background: #001529; color: white; padding: 0 20px; height: 50px; display: flex; align-items: center; justify-content: space-between; }
        .brand { font-weight: bold; font-size: 16px; display: flex; align-items: center; gap: 10px; }
        
        .main-box { display: flex; flex: 1; overflow: hidden; }
        
        /* CỘT TRÁI */
        .sidebar { width: 320px; background: white; border-right: 1px solid #ddd; overflow-y: auto; display: flex; flex-direction: column; }
        
        .ticket-item { padding: 15px; border-bottom: 1px solid #eee; text-decoration: none; color: #333; display: block; transition: 0.2s; position: relative; }
        .ticket-item:hover { background-color: #f5f5f5; }
        .ticket-item.active { background-color: #e6f7ff; border-left: 4px solid #1890ff; }
        
        .t-meta { font-size: 11px; color: #888; margin-bottom: 4px; display: flex; justify-content: space-between; }
        .t-title { font-weight: 600; font-size: 14px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: #262626; }
        .t-desc { font-size: 12px; color: #595959; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-top: 2px; }
        
        /* CỘT PHẢI */
        .content { flex: 1; display: flex; flex-direction: column; background: #fff; }
        .chat-area { flex: 1; padding: 20px 30px; overflow-y: auto; background: #f0f2f5; display: flex; flex-direction: column; gap: 15px; }
        
        .message-box { padding: 12px 18px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); max-width: 75%; position: relative; }
        .msg-customer { background: white; align-self: flex-start; border-top-left-radius: 0; }
        .msg-customer .sender-name { color: #ff4d4f; }
        .msg-staff { background: #e6f7ff; align-self: flex-end; border: 1px solid #bae7ff; border-top-right-radius: 0; }
        .msg-staff .sender-name { color: #1890ff; }
        
        .sender-name { font-weight: bold; font-size: 11px; margin-bottom: 4px; text-transform: uppercase; letter-spacing: 0.5px; }
        .msg-content { line-height: 1.5; font-size: 14px; }
        .msg-time { font-size: 10px; color: #8c8c8c; text-align: right; margin-top: 5px; }

        .reply-area { padding: 20px; background: white; border-top: 1px solid #e8e8e8; }
        .reply-form { display: flex; flex-direction: column; gap: 10px; }
        textarea { width: 100%; border: 1px solid #d9d9d9; border-radius: 4px; padding: 12px; box-sizing: border-box; resize: none; font-family: inherit; font-size: 14px; outline: none; transition: 0.3s; }
        textarea:focus { border-color: #40a9ff; box-shadow: 0 0 0 2px rgba(24,144,255,0.2); }
        .btn-send { align-self: flex-end; background: #1890ff; color: white; border: none; padding: 8px 25px; border-radius: 4px; cursor: pointer; font-weight: 600; transition: 0.3s; }
        .btn-send:hover { background: #40a9ff; }
        
        .empty-state { display: flex; flex-direction: column; justify-content: center; align-items: center; height: 100%; color: #8c8c8c; }
        .empty-icon { font-size: 48px; margin-bottom: 10px; opacity: 0.3; }

        /* Style cho thanh Tab */
        .tab-bar { padding: 10px; border-bottom: 1px solid #ddd; display: flex; gap: 8px; background: #f9f9f9; }
        .tab-btn { flex: 1; text-align: center; padding: 8px; text-decoration: none; border-radius: 4px; font-size: 12px; font-weight: 600; transition: 0.2s; border: 1px solid transparent; }
        .tab-btn.active { background: #1890ff; color: white; border-color: #1890ff; }
        .tab-btn.inactive { background: white; color: #555; border-color: #ddd; }
        .tab-btn:hover { opacity: 0.9; }
    </style>
</head>
<body>

    <div class="header">
        <div class="brand"><span>🛡️</span> Customer Success Dashboard</div>
        <div style="font-size: 13px;">Nhân viên: <b>${sessionScope.userId != null ? 'ID ' += sessionScope.userId : 'Guest'}</b></div>
    </div>

    <div class="main-box">
        
        <div class="sidebar">
            <div class="tab-bar">
                <a href="customer-success?view=pending" class="tab-btn ${currentView == 'pending' ? 'active' : 'inactive'}">
                    ⏳ Cần xử lý
                </a>
                <a href="customer-success?view=history" class="tab-btn ${currentView == 'history' ? 'active' : 'inactive'}">
                    📜 Lịch sử
                </a>
            </div>

            <div style="flex: 1; overflow-y: auto;">
                <c:if test="${empty ticketList}">
                    <div style="text-align: center; padding: 30px; color: #999; font-size: 13px;">
                        <i>Chưa có dữ liệu</i>
                    </div>
                </c:if>

                <c:forEach items="${ticketList}" var="t">
                    <a href="customer-success?view=${currentView}&id=${t.id}" class="ticket-item ${t.id == selectedTicket.id ? 'active' : ''}">
                        <div class="t-meta">
                            <span>#${t.id}</span>
                            <span>${t.createdAt}</span>
                        </div>
                        <div class="t-title">${t.title}</div>
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 5px;">
                            <span class="t-desc">${t.description}</span>
                            <c:if test="${t.statusId == 1}">
                                <span style="font-size:10px; background:#fff1f0; color:#ff4d4f; padding:2px 6px; border-radius:4px; border:1px solid #ffa39e;">Chờ xử lý</span>
                            </c:if>
                            <c:if test="${t.statusId == 2}">
                                <span style="font-size:10px; background:#f6ffed; color:#52c41a; padding:2px 6px; border-radius:4px; border:1px solid #b7eb8f;">Đã đóng</span>
                            </c:if>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </div>

        <div class="content">
            <c:if test="${selectedTicket != null}">
                
                <div class="chat-area">
                    <div class="message-box msg-customer">
                        <div class="sender-name">Khách hàng (ID: ${selectedTicket.customerId})</div>
                        <div class="msg-content">
                            <div style="font-weight: 700; margin-bottom: 5px;">${selectedTicket.title}</div>
                            ${selectedTicket.description}
                        </div>
                        <div class="msg-time">${selectedTicket.createdAt}</div>
                    </div>
                    
                    <div style="text-align: center; font-size: 11px; color: #bfbfbf; margin: 10px 0;">── Lịch sử trao đổi ──</div>

                    <c:forEach items="${chatHistory}" var="chat">
                        <c:set var="currentStaffId" value="${sessionScope.userId != null ? sessionScope.userId : 1}"/>
                        <div class="message-box ${chat.senderId == currentStaffId ? 'msg-staff' : 'msg-customer'}">
                            <div class="sender-name">
                                <c:if test="${chat.senderId == currentStaffId}">Bạn (Staff)</c:if>
                                <c:if test="${chat.senderId != currentStaffId}">Người dùng khác</c:if>
                            </div>
                            <div class="msg-content">${chat.content}</div>
                            <div class="msg-time">${chat.createdAt}</div>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${currentView == 'pending'}">
                    <div class="reply-area">
                        <form action="customer-success" method="POST" class="reply-form">
                            <input type="hidden" name="ticketId" value="${selectedTicket.id}">
                            <textarea name="message" rows="3" placeholder="Nhập câu trả lời... (Gửi xong phiếu sẽ đóng lại)" required></textarea>
                            <button type="submit" class="btn-send">Gửi & Đóng phiếu</button>
                        </form>
                    </div>
                </c:if>
                
                <c:if test="${currentView == 'history'}">
                    <div class="reply-area" style="text-align: center; color: #888; background: #fafafa;">
                        🔒 Phiếu này đã được giải quyết.
                    </div>
                </c:if>

            </c:if>

            <c:if test="${selectedTicket == null}">
                <div class="empty-state">
                    <div class="empty-icon">💬</div>
                    <h3>Chào mừng đến với Dashboard CSKH</h3>
                    <p>Chọn phiếu từ danh sách <b>"${currentView == 'pending' ? 'Cần xử lý' : 'Lịch sử'}"</b> để xem.</p>
                </div>
            </c:if>
        </div>
    </div>

</body>
</html>