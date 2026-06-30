package com.pethome.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 自定义编码过滤器 EncodingFilter
 *
 * 作用：确保所有请求和响应都使用 UTF-8 编码
 * 这是处理中文数据正确的第一层保障
 *
 * 注意：web.xml 中配置了 Tomcat 自带的 SetCharacterEncodingFilter，
 * 此自定义 Filter 作为额外保障（也可二选一，推荐使用 Tomcat 自带的）
 */
public class EncodingFilter extends HttpFilter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("[EncodingFilter] 编码过滤器已初始化");
    }

    @Override
    protected void doFilter(HttpServletRequest request,
                            HttpServletResponse response,
                            FilterChain chain)
            throws IOException, ServletException {

        // 设置请求编码（处理 POST 请求中的中文参数）
        request.setCharacterEncoding("UTF-8");

        // 设置响应编码
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 放行
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("[EncodingFilter] 编码过滤器已销毁");
    }
}
