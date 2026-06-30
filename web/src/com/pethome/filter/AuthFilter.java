package com.pethome.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 登录验证过滤器 AuthFilter
 *
 * 功能：拦截未登录用户对受保护资源的访问
 * 作用范围在 web.xml 中配置：
 *   - /jsp/cart.jsp
 *   - /jsp/checkout.jsp
 *   - /jsp/order-list.jsp
 *   - /jsp/user-profile.jsp
 *   - /jsp/admin/*
 *   - /cart
 *   - /order
 *   - /admin/*
 */
public class AuthFilter extends HttpFilter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("[AuthFilter] 登录验证过滤器已初始化");
    }

    @Override
    protected void doFilter(HttpServletRequest request,
                            HttpServletResponse response,
                            FilterChain chain)
            throws IOException, ServletException {

        // 设置请求和响应编码（双重保障）
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 获取当前会话
        HttpSession session = request.getSession(false);
        Object userObj = null;
        if (session != null) {
            userObj = session.getAttribute("user");
        }

        // 检查用户是否已登录
        if (userObj == null) {
            // 未登录：将请求的 URL 存入 session（登录后跳回）
            String requestURI = request.getRequestURI();
            String queryString = request.getQueryString();
            if (queryString != null) {
                requestURI += "?" + queryString;
            }
            if (session != null) {
                session.setAttribute("redirectURL", requestURI);
            }

            // 设置错误信息并重定向到登录页
            request.setAttribute("errorMsg", "请先登录后再访问此页面");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
            return;
        }

        // 检查是否为管理员路径但用户不是管理员
        String path = request.getRequestURI();
        if (path.contains("/admin/") || path.startsWith(request.getContextPath() + "/admin")) {
            com.pethome.model.User user = (com.pethome.model.User) userObj;
            if (user.getRole() != 1) {
                request.setAttribute("errorMsg", "您没有管理员权限");
                request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
                return;
            }
        }

        // 已登录且权限足够，放行
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("[AuthFilter] 登录验证过滤器已销毁");
    }
}
