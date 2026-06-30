<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("pageTitle", "注册"); %>
<jsp:include page="/jsp/common/header.jspf" />

<main class="min-h-screen flex items-center justify-center px-4 py-xl bg-surface-container-low">
    <div class="w-full max-w-md bg-surface-container-lowest rounded-3xl shadow-lg p-xl">
        <div class="text-center mb-lg">
            <span class="material-symbols-outlined text-primary text-6xl">pets</span>
            <h1 class="font-display-lg text-display-lg text-on-surface mt-2">注册账号</h1>
            <p class="text-on-surface-variant">加入萌宠之家，享受专属服务</p>
        </div>

        <%
            String errorMsg = (String) request.getAttribute("errorMsg");
            if (errorMsg != null && !errorMsg.isEmpty()) {
        %>
        <div class="error-message"><%= errorMsg %></div>
        <% } %>

        <!-- 注册表单 -->
        <form action="<%=request.getContextPath()%>/user" method="post" class="space-y-md">
            <input type="hidden" name="action" value="register">

            <div class="space-y-xs">
                <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">用户名 <span class="text-error">*</span></label>
                <input name="username" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container transition-all" placeholder="请输入用户名（可用于登录）" required>
            </div>

            <div class="space-y-xs">
                <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">昵称</label>
                <input name="nickname" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container transition-all" placeholder="您希望我们怎么称呼您">
            </div>

            <div class="grid grid-cols-2 gap-md">
                <div class="space-y-xs">
                    <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">密码 <span class="text-error">*</span></label>
                    <input name="password" type="password" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container transition-all" placeholder="设置密码" required>
                </div>
                <div class="space-y-xs">
                    <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">确认密码 <span class="text-error">*</span></label>
                    <input name="confirmPassword" type="password" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container transition-all" placeholder="再次输入密码" required>
                </div>
            </div>

            <div class="grid grid-cols-2 gap-md">
                <div class="space-y-xs">
                    <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">邮箱</label>
                    <input name="email" type="email" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container transition-all" placeholder="用于接收订单通知">
                </div>
                <div class="space-y-xs">
                    <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">手机号</label>
                    <input name="phone" type="tel" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container transition-all" placeholder="方便我们联系您">
                </div>
            </div>

            <!-- 验证码 -->
            <div class="space-y-xs">
                <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">验证码 <span class="text-error">*</span></label>
                <div class="flex items-center gap-md">
                    <input name="captcha" class="flex-1 px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container transition-all" placeholder="请输入验证码" required>
                    <img id="captchaImg"
                         src="<%=request.getContextPath()%>/captcha"
                         alt="验证码"
                         title="点击刷新验证码"
                         class="h-11 rounded-lg cursor-pointer border border-outline/20 hover:border-primary transition-colors"
                         onclick="this.src='<%=request.getContextPath()%>/captcha?'+Math.random()">
                </div>
                <p class="text-xs text-on-surface-variant/60 px-xs mt-1">点击图片可刷新验证码</p>
            </div>

            <button class="w-full bg-primary text-white py-4 rounded-full font-bold text-lg hover:shadow-xl transform hover:-translate-y-1 transition-all active:scale-95" type="submit">
                注册
            </button>

            <p class="text-center text-on-surface-variant">
                已有账号？<a href="<%=request.getContextPath()%>/jsp/login.jsp" class="text-primary font-bold hover:underline" style="text-decoration:none;">立即登录</a>
            </p>

            <p class="text-center text-xs text-on-surface-variant">
                注册即表示同意我们的《服务协议》和《隐私政策》
            </p>
        </form>
    </div>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
