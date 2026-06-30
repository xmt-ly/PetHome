<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("pageTitle", "登录"); %>
<jsp:include page="/jsp/common/header.jspf" />

<main class="min-h-screen flex items-center justify-center px-4 py-xl bg-surface-container-low">
    <div class="w-full max-w-md bg-surface-container-lowest rounded-3xl shadow-lg p-xl">
        <!-- 品牌标识 -->
        <div class="text-center mb-lg">
            <span class="material-symbols-outlined text-primary text-6xl">pets</span>
            <h1 class="font-display-lg text-display-lg text-on-surface mt-2">欢迎回来</h1>
            <p class="text-on-surface-variant">登录您的萌宠之家账号</p>
        </div>

        <!-- 错误消息 -->
        <%
            String errorMsg = (String) request.getAttribute("errorMsg");
            if (errorMsg != null && !errorMsg.isEmpty()) {
        %>
        <div class="error-message"><%= errorMsg %></div>
        <% } %>

        <!-- 登录表单 -->
        <form action="<%=request.getContextPath()%>/user" method="post" class="space-y-md">
            <input type="hidden" name="action" value="login">

            <div class="space-y-xs">
                <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">用户名</label>
                <input name="username" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container transition-all" placeholder="请输入用户名" required>
            </div>

            <div class="space-y-xs">
                <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">密码</label>
                <input name="password" type="password" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container transition-all" placeholder="请输入密码" required>
            </div>

            <div class="flex items-center justify-between">
                <label class="flex items-center gap-xs cursor-pointer">
                    <input type="checkbox" class="rounded border-outline-variant text-primary focus:ring-primary-container">
                    <span class="text-sm text-on-surface-variant">记住我</span>
                </label>
            </div>

            <button class="w-full bg-primary text-white py-4 rounded-full font-bold text-lg hover:shadow-xl transform hover:-translate-y-1 transition-all active:scale-95" type="submit">
                登录
            </button>

            <p class="text-center text-on-surface-variant">
                还没有账号？<a href="<%=request.getContextPath()%>/jsp/register.jsp" class="text-primary font-bold hover:underline" style="text-decoration:none;">立即注册</a>
            </p>

            <div class="border-t border-outline-variant pt-md text-center">
                <p class="text-xs text-on-surface-variant">测试账号：admin / admin123</p>
            </div>
        </form>
    </div>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
