<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pethome.model.User" %>
<% request.setAttribute("pageTitle", "个人中心"); %>
<jsp:include page="/jsp/common/header.jspf" />

<%
    User user = (User) session.getAttribute("user");
    String successMsg = (String) request.getAttribute("successMsg");
    String errorMsg = (String) request.getAttribute("errorMsg");
%>

<main class="max-w-4xl mx-auto px-4 md:px-margin-desktop py-xl min-h-screen">
    <h1 class="font-display-lg text-display-lg text-on-surface mb-xl">个人中心</h1>

    <% if (successMsg != null) { %><div class="success-message"><%= successMsg %></div><% } %>
    <% if (errorMsg != null) { %><div class="error-message"><%= errorMsg %></div><% } %>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-lg">
        <!-- 左侧：用户信息卡片 -->
        <div class="bg-surface-container-lowest rounded-xl p-md border border-outline-variant text-center">
            <div class="w-20 h-20 rounded-full bg-primary-fixed-dim flex items-center justify-center mx-auto mb-md">
                <span class="material-symbols-outlined text-primary text-5xl">account_circle</span>
            </div>
            <h2 class="font-headline-md text-headline-md"><%= user != null ? user.getNickname() : "" %></h2>
            <p class="text-on-surface-variant">@<%= user != null ? user.getUsername() : "" %></p>
            <% if (user != null && user.getRole() == 1) { %>
            <span class="inline-block px-3 py-1 bg-primary-fixed-dim text-primary-fixed-variant rounded-full text-sm mt-2">管理员</span>
            <% } %>
            <div class="mt-md pt-md border-t border-outline-variant">
                <a href="<%=request.getContextPath()%>/order?action=list" class="flex items-center gap-2 text-on-surface-variant hover:text-primary transition-colors py-2" style="text-decoration:none;">
                    <span class="material-symbols-outlined">receipt_long</span> 我的订单
                </a>
                <% if (user != null && user.getRole() == 1) { %>
                <a href="<%=request.getContextPath()%>/admin" class="flex items-center gap-2 text-primary hover:text-primary transition-colors py-2" style="text-decoration:none;">
                    <span class="material-symbols-outlined">admin_panel_settings</span> 后台管理
                </a>
                <% } %>
            </div>
        </div>

        <!-- 右侧：信息编辑 -->
        <div class="md:col-span-2 space-y-lg">
            <!-- 个人信息表单 -->
            <div class="bg-surface-container-lowest rounded-xl p-md border border-outline-variant">
                <h2 class="font-headline-md text-headline-md mb-md">编辑个人信息</h2>
                <form action="<%=request.getContextPath()%>/user" method="post" class="space-y-md">
                    <input type="hidden" name="action" value="update">

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-md">
                        <div class="space-y-xs">
                            <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">用户名</label>
                            <input value="<%= user != null ? user.getUsername() : "" %>" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low" disabled style="outline:none;opacity:0.6;">
                        </div>
                        <div class="space-y-xs">
                            <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">昵称</label>
                            <input name="nickname" value="<%= user != null ? user.getNickname() : "" %>" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container" style="outline:none;">
                        </div>
                        <div class="space-y-xs">
                            <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">邮箱</label>
                            <input name="email" value="<%= user != null ? user.getEmail() : "" %>" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container" style="outline:none;">
                        </div>
                        <div class="space-y-xs">
                            <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">手机号</label>
                            <input name="phone" value="<%= user != null ? user.getPhone() : "" %>" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container" style="outline:none;">
                        </div>
                    </div>

                    <button class="bg-primary text-white px-xl py-3 rounded-full font-bold hover:opacity-90 transition-all" type="submit">保存修改</button>
                </form>
            </div>

            <!-- 修改密码 -->
            <div class="bg-surface-container-lowest rounded-xl p-md border border-outline-variant">
                <h2 class="font-headline-md text-headline-md mb-md">修改密码</h2>
                <form action="<%=request.getContextPath()%>/user" method="post" class="space-y-md">
                    <input type="hidden" name="action" value="updatePassword">

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-md">
                        <div class="space-y-xs">
                            <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">原密码</label>
                            <input name="oldPassword" type="password" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container" required style="outline:none;">
                        </div>
                        <div class="space-y-xs">
                            <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">新密码</label>
                            <input name="newPassword" type="password" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container" required style="outline:none;">
                        </div>
                        <div class="space-y-xs">
                            <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">确认新密码</label>
                            <input name="confirmPassword" type="password" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container" required style="outline:none;">
                        </div>
                    </div>

                    <button class="bg-secondary text-white px-xl py-3 rounded-full font-bold hover:opacity-90 transition-all" type="submit">修改密码</button>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
