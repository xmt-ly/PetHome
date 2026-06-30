<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<% request.setAttribute("pageTitle", "500 - 服务器错误"); %>
<jsp:include page="/jsp/common/header.jspf" />

<main class="min-h-screen flex items-center justify-center px-4">
    <div class="text-center">
        <span class="material-symbols-outlined text-8xl text-error-container">error</span>
        <h1 class="font-display-lg text-display-lg text-on-surface mt-4">500</h1>
        <p class="font-headline-md text-headline-md text-on-surface-variant">服务器内部错误</p>
        <p class="text-on-surface-variant mt-2 mb-lg">抱歉，服务器遇到了问题，请稍后重试</p>
        <a href="<%=request.getContextPath()%>/index.jsp" class="inline-block bg-primary text-white px-xl py-4 rounded-full font-bold hover:opacity-90 transition-all" style="text-decoration:none;">返回首页</a>
    </div>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
