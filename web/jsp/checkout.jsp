<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pethome.model.CartItem, java.math.BigDecimal, com.pethome.model.User" %>
<% request.setAttribute("pageTitle", "结算"); %>
<jsp:include page="/jsp/common/header.jspf" />

<%
    User user = (User) session.getAttribute("user");
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if (cart == null) cart = new java.util.ArrayList<>();

    BigDecimal total = BigDecimal.ZERO;
    for (CartItem item : cart) {
        total = total.add(item.getSubtotal());
    }

    String errorMsg = (String) request.getAttribute("errorMsg");
%>

<main class="max-w-4xl mx-auto px-4 md:px-margin-desktop py-xl min-h-screen">
    <h1 class="font-display-lg text-display-lg text-on-surface mb-xl">确认订单</h1>

    <% if (cart.isEmpty()) { %>
    <div class="text-center py-xl">
        <span class="material-symbols-outlined text-8xl text-on-surface-variant/20">shopping_cart</span>
        <p class="text-on-surface-variant mt-4">购物车为空，请先添加商品</p>
        <a href="<%=request.getContextPath()%>/product" class="inline-block bg-primary text-white px-xl py-3 rounded-full mt-md" style="text-decoration:none;">去购物</a>
    </div>
    <% } else { %>

    <% if (errorMsg != null) { %><div class="error-message"><%= errorMsg %></div><% } %>

    <!-- 商品清单 -->
    <div class="bg-surface-container-lowest rounded-xl p-md border border-outline-variant mb-lg">
        <h2 class="font-headline-md text-headline-md mb-md">商品清单</h2>
        <% for (CartItem item : cart) { %>
        <div class="flex justify-between items-center py-base border-b border-outline-variant/50 last:border-0">
            <div>
                <p class="font-bold"><%= item.getProductName() %></p>
                <p class="text-sm text-on-surface-variant">¥<%= item.getPrice() %> × <%= item.getQuantity() %></p>
            </div>
            <span class="font-bold">¥<%= item.getSubtotal() %></span>
        </div>
        <% } %>
        <div class="flex justify-between items-center pt-md">
            <span class="font-headline-md text-headline-md">合计</span>
            <span class="font-display-lg text-display-lg text-primary">¥<%= total %></span>
        </div>
    </div>

    <!-- 收货信息表单 -->
    <div class="bg-surface-container-lowest rounded-xl p-md border border-outline-variant">
        <h2 class="font-headline-md text-headline-md mb-md">收货信息</h2>
        <form action="<%=request.getContextPath()%>/order" method="post" class="space-y-md">
            <input type="hidden" name="action" value="create">

            <div class="grid grid-cols-1 md:grid-cols-3 gap-md">
                <div class="space-y-xs">
                    <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">收货人 <span class="text-error">*</span></label>
                    <input name="receiver" value="<%=user != null ? user.getNickname() : "" %>" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container" placeholder="收货人姓名" required style="outline:none;">
                </div>
                <div class="space-y-xs">
                    <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">手机号 <span class="text-error">*</span></label>
                    <input name="phone" value="<%=user != null ? user.getPhone() : "" %>" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container" placeholder="收货人手机号" required style="outline:none;">
                </div>
                <div class="space-y-xs">
                    <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">收货地址 <span class="text-error">*</span></label>
                    <input name="address" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container" placeholder="请填写完整地址" required style="outline:none;">
                </div>
            </div>

            <div class="space-y-xs">
                <label class="font-label-sm text-label-sm text-on-surface-variant px-xs">订单备注</label>
                <textarea name="remark" class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container" placeholder="有什么特殊要求吗？" rows="2" style="outline:none;"></textarea>
            </div>

            <button class="w-full bg-primary text-white py-4 rounded-full font-bold text-lg hover:shadow-xl transform hover:-translate-y-1 transition-all active:scale-95" type="submit">
                提交订单（¥<%= total %>）
            </button>
        </form>
    </div>
    <% } %>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
