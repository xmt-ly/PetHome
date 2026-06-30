<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pethome.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() != 1) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    request.setAttribute("pageTitle", "管理后台");
%>
<jsp:include page="/jsp/common/header.jspf" />

<%
    Integer productCount = (Integer) request.getAttribute("productCount");
    Integer orderCount = (Integer) request.getAttribute("orderCount");
    Integer userCount = (Integer) request.getAttribute("userCount");
    if (productCount == null) productCount = 0;
    if (orderCount == null) orderCount = 0;
    if (userCount == null) userCount = 0;
%>

<main class="max-w-7xl mx-auto px-4 md:px-margin-desktop py-xl min-h-screen">
    <div class="flex items-center gap-base mb-xl">
        <span class="material-symbols-outlined text-primary text-4xl">admin_panel_settings</span>
        <h1 class="font-display-lg text-display-lg text-on-surface">管理后台</h1>
    </div>

    <!-- 数据概览卡片 -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-md mb-xl">
        <div class="bg-surface-container-lowest rounded-xl p-md border border-outline-variant flex items-center gap-md">
            <div class="w-14 h-14 rounded-xl bg-primary-fixed-dim flex items-center justify-center"><span class="material-symbols-outlined text-primary text-3xl">inventory_2</span></div>
            <div><p class="text-sm text-on-surface-variant">商品总数</p><p class="font-display-lg text-display-lg text-primary"><%= productCount %></p></div>
        </div>
        <div class="bg-surface-container-lowest rounded-xl p-md border border-outline-variant flex items-center gap-md">
            <div class="w-14 h-14 rounded-xl bg-secondary-fixed flex items-center justify-center"><span class="material-symbols-outlined text-secondary text-3xl">receipt_long</span></div>
            <div><p class="text-sm text-on-surface-variant">订单总数</p><p class="font-display-lg text-display-lg text-secondary"><%= orderCount %></p></div>
        </div>
        <div class="bg-surface-container-lowest rounded-xl p-md border border-outline-variant flex items-center gap-md">
            <div class="w-14 h-14 rounded-xl bg-tertiary-fixed flex items-center justify-center"><span class="material-symbols-outlined text-tertiary text-3xl">people</span></div>
            <div><p class="text-sm text-on-surface-variant">用户总数</p><p class="font-display-lg text-display-lg text-tertiary"><%= userCount %></p></div>
        </div>
    </div>

    <!-- 管理导航 -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-md">
        <a href="<%=request.getContextPath()%>/admin?module=product" class="bg-surface-container-lowest rounded-xl p-lg border border-outline-variant hover:shadow-lg transition-all group" style="text-decoration:none;">
            <span class="material-symbols-outlined text-4xl text-primary group-hover:scale-110 transition-transform">inventory_2</span>
            <h2 class="font-headline-md text-headline-md mt-md">商品管理</h2>
            <p class="text-on-surface-variant">管理商品信息的增删改查</p>
        </a>
        <a href="<%=request.getContextPath()%>/admin?module=service" class="bg-surface-container-lowest rounded-xl p-lg border border-outline-variant hover:shadow-lg transition-all group" style="text-decoration:none;">
            <span class="material-symbols-outlined text-4xl text-secondary group-hover:scale-110 transition-transform">lan</span>
            <h2 class="font-headline-md text-headline-md mt-md">服务管理</h2>
            <p class="text-on-surface-variant">管理服务项目的增删改查</p>
        </a>
        <a href="<%=request.getContextPath()%>/admin?module=order" class="bg-surface-container-lowest rounded-xl p-lg border border-outline-variant hover:shadow-lg transition-all group" style="text-decoration:none;">
            <span class="material-symbols-outlined text-4xl text-tertiary group-hover:scale-110 transition-transform">receipt_long</span>
            <h2 class="font-headline-md text-headline-md mt-md">订单管理</h2>
            <p class="text-on-surface-variant">查看和处理用户订单</p>
        </a>
        <a href="<%=request.getContextPath()%>/admin?module=user" class="bg-surface-container-lowest rounded-xl p-lg border border-outline-variant hover:shadow-lg transition-all group" style="text-decoration:none;">
            <span class="material-symbols-outlined text-4xl text-primary group-hover:scale-110 transition-transform">people</span>
            <h2 class="font-headline-md text-headline-md mt-md">用户管理</h2>
            <p class="text-on-surface-variant">管理注册用户信息</p>
        </a>
    </div>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
