<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<% request.setAttribute("pageTitle", "404 - 页面未找到"); %>
<jsp:include page="/jsp/common/header.jspf" />

<main class="min-h-screen flex items-center justify-center px-4">
    <div class="text-center">
        <span class="material-symbols-outlined text-8xl text-primary-fixed-dim">pets</span>
        <h1 class="font-display-lg text-display-lg text-on-surface mt-4">404</h1>
        <p class="font-headline-md text-headline-md text-on-surface-variant">页面未找到</p>
        <p class="text-on-surface-variant mt-2 mb-lg">您访问的页面不存在或已被移除</p>
        <a href="<%=request.getContextPath()%>/index.jsp" class="inline-block bg-primary text-white px-xl py-4 rounded-full font-bold hover:opacity-90 transition-all" style="text-decoration:none;">返回首页</a>
    </div>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
