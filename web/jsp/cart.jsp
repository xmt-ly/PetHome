<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pethome.model.CartItem, java.math.BigDecimal" %>
<% request.setAttribute("pageTitle", "购物车"); %>
<jsp:include page="/jsp/common/header.jspf" />

<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    BigDecimal cartTotal = (BigDecimal) request.getAttribute("cartTotal");
    Integer cartCount = (Integer) request.getAttribute("cartCount");
    if (cartItems == null) cartItems = new java.util.ArrayList<>();
    if (cartTotal == null) cartTotal = BigDecimal.ZERO;
    if (cartCount == null) cartCount = 0;
%>

<main class="max-w-4xl mx-auto px-4 md:px-margin-desktop py-xl min-h-screen">
    <h1 class="font-display-lg text-display-lg text-on-surface mb-xl">我的购物车</h1>

    <% if (cartItems.isEmpty()) { %>
    <!-- 空购物车 -->
    <div class="text-center py-xl">
        <span class="material-symbols-outlined text-8xl text-on-surface-variant/20">shopping_cart</span>
        <h2 class="font-headline-md text-headline-md text-on-surface-variant mt-4">购物车是空的</h2>
        <p class="text-on-surface-variant mb-lg">快去商城挑选心仪的宠物用品吧！</p>
        <a href="<%=request.getContextPath()%>/product" class="inline-block bg-primary text-white px-xl py-4 rounded-full font-bold hover:opacity-90 transition-all" style="text-decoration:none;">去逛逛</a>
    </div>
    <% } else { %>
    <!-- 购物车列表 -->
    <div class="space-y-md mb-lg">
        <% for (CartItem item : cartItems) { %>
        <div class="bg-surface-container-lowest rounded-xl p-md border border-outline-variant flex items-center gap-md">
            <div class="w-20 h-20 rounded-xl bg-surface-container-low flex items-center justify-center flex-shrink-0">
                <span class="material-symbols-outlined text-3xl text-primary-fixed-dim">pets</span>
            </div>
            <div class="flex-1 min-w-0">
                <h3 class="font-headline-md text-body-lg truncate"><%= item.getProductName() %></h3>
                <p class="text-primary font-bold">¥<%= item.getPrice() %></p>
            </div>
            <!-- 数量调整 -->
            <div class="flex items-center gap-base">
                <a href="<%=request.getContextPath()%>/cart?action=update&productId=<%=item.getProductId()%>&quantity=<%=item.getQuantity()-1%>" class="w-8 h-8 rounded-full bg-surface-container-low flex items-center justify-center hover:bg-surface-container transition-colors" style="text-decoration:none;">-</a>
                <span class="font-bold w-8 text-center"><%= item.getQuantity() %></span>
                <a href="<%=request.getContextPath()%>/cart?action=update&productId=<%=item.getProductId()%>&quantity=<%=item.getQuantity()+1%>" class="w-8 h-8 rounded-full bg-surface-container-low flex items-center justify-center hover:bg-surface-container transition-colors" style="text-decoration:none;">+</a>
            </div>
            <div class="text-right">
                <p class="font-bold text-on-surface">¥<%= item.getSubtotal() %></p>
                <a href="<%=request.getContextPath()%>/cart?action=remove&productId=<%=item.getProductId()%>" class="text-xs text-error hover:underline" style="text-decoration:none;">删除</a>
            </div>
        </div>
        <% } %>
    </div>

    <!-- 购物车底部 -->
    <div class="bg-surface-container-lowest rounded-xl p-md border border-outline-variant flex flex-col sm:flex-row justify-between items-center gap-md">
        <div>
            <a href="<%=request.getContextPath()%>/cart?action=clear" class="text-on-surface-variant hover:text-error transition-colors" style="text-decoration:none;">清空购物车</a>
        </div>
        <div class="text-right">
            <p class="text-on-surface-variant">共 <span class="font-bold"><%= cartCount %></span> 件商品</p>
            <p class="font-display-lg text-display-lg text-primary">¥<%= cartTotal %></p>
            <a href="<%=request.getContextPath()%>/jsp/checkout.jsp" class="inline-block bg-primary text-white px-xl py-3 rounded-full font-bold hover:opacity-90 transition-all mt-sm" style="text-decoration:none;">去结算</a>
        </div>
    </div>
    <% } %>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
