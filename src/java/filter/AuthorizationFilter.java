package filter;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {
    "/sale/*", "/marketing/*", "/admin/*", "/support/*", "/manager/*"
})
public class AuthorizationFilter implements Filter {

    private static final Map<String, String> PATH_ROLE_MAP = new HashMap<>();

    static {
        PATH_ROLE_MAP.put("/sale/", "SALES");
        PATH_ROLE_MAP.put("/marketing/", "MARKETING");
        PATH_ROLE_MAP.put("/admin/", "ADMIN");
        PATH_ROLE_MAP.put("/support/", "SUPPORT");
        PATH_ROLE_MAP.put("/manager/", "MANAGER");
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Check authentication
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        String path = httpRequest.getServletPath();

        // ADMIN can access everything (Case-insensitive check)
        if (role != null && "ADMIN".equalsIgnoreCase(role)) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user's role matches the URL path
        String requiredRole = getRequiredRole(path);
        if (requiredRole != null && (role == null || !requiredRole.equalsIgnoreCase(role))) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/error/403.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

    private String getRequiredRole(String path) {
        for (Map.Entry<String, String> entry : PATH_ROLE_MAP.entrySet()) {
            if (path.startsWith(entry.getKey())) {
                return entry.getValue();
            }
        }
        return null;
    }

    @Override
    public void destroy() {
    }
}
