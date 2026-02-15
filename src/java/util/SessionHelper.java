package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.Users;

public class SessionHelper {

    // Lấy Users từ session, trả null nếu chưa đăng nhập
    public static Users getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object obj = session.getAttribute("user");
        if (obj instanceof Users) {
            return (Users) obj;
        }
        return null;
    }

    // Lấy userId, trả null nếu chưa đăng nhập
    public static Integer getLoggedInUserId(HttpServletRequest request) {
        Users user = getLoggedInUser(request);
        return user != null ? user.getUserId() : null;
    }

    // Kiểm tra đã đăng nhập chưa
    public static boolean isLoggedIn(HttpServletRequest request) {
        return getLoggedInUser(request) != null;
    }
}
