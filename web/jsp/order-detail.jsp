<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pethome.model.Order, com.pethome.model.OrderItem, java.util.List" %>
<% request.setAttribute("pageTitle", "订单详情"); %>
<jsp:include page="/jsp/common/header.jspf" />

<%
    Order order = (Order) request.getAttribute("order");
%>

<main class="max-w-4xl mx-auto px-4 md:px-margin-desktop py-xl min-h-screen">
    <% if (order == null) { %>
    <div class="text-center py-xl"><p class="text-on-surface-variant">订单不存在</p></div>
    <% } else { %>

    <div class="flex items-center justify-between mb-xl">
        <h1 class="font-display-lg text-display-lg text-on-surface">订单详情</h1>
        <span class="inline-block px-4 py-2 rounded-full font-bold <%=order.getStatus()==0?"bg-warning/20":order.getStatus()==3?"bg-secondary-container/20":"bg-primary-fixed-dim/20"%>">
            <%= order.getStatusText() %>
        </span>
    </div>

    <div class="bg-surface-container-lowest rounded-xl p-md border border-outline-variant space-y-md mb-lg">
        <div class="grid grid-cols-2 gap-md">
            <div><p class="text-sm text-on-surface-variant">订单编号</p><p class="font-bold"><%= order.getOrderNo() %></p></div>
            <div><p class="text-sm text-on-surface-variant">下单时间</p><p class="font-bold"><%= order.getCreatedAt() != null ? order.getCreatedAt().toString().replace("T", " ") : "" %></p></div>
            <div><p class="text-sm text-on-surface-variant">收货人</p><p class="font-bold"><%= order.getReceiver() != null ? order.getReceiver() : "" %></p></div>
            <div><p class="text-sm text-on-surface-variant">联系电话</p><p class="font-bold"><%= order.getPhone() %></p></div>
            <div class="col-span-2"><p class="text-sm text-on-surface-variant">收货地址</p><p class="font-bold"><%= order.getAddress() %></p></div>
        </div>
    </div>

    <div class="bg-surface-container-lowest rounded-xl p-md border border-outline-variant mb-lg">
        <h2 class="font-headline-md text-headline-md mb-md">商品明细</h2>
        <% if (order.getItems() != null) {
            for (OrderItem item : order.getItems()) { %>
        <div class="flex justify-between items-center py-base border-b border-outline-variant/50 last:border-0">
            <div><p class="font-bold"><%= item.getProductName() %></p><p class="text-sm text-on-surface-variant">¥<%= item.getPrice() %> × <%= item.getQuantity() %></p></div>
            <span class="font-bold">¥<%= item.getSubtotal() %></span>
        </div>
        <% } } %>
        <div class="flex justify-between items-center pt-md">
            <span class="font-headline-md text-headline-md">合计</span>
            <span class="font-display-lg text-display-lg text-primary">¥<%= order.getTotalAmount() %></span>
        </div>
    </div>

    <% if (order.getRemark() != null && !order.getRemark().isEmpty()) { %>
    <div class="bg-surface-container-lowest rounded-xl p-md border border-outline-variant">
        <p class="text-sm text-on-surface-variant">订单备注</p>
        <p><%= order.getRemark() %></p>
    </div>
    <% } %>

    <div class="flex justify-center gap-md mt-lg">
        <a href="<%=request.getContextPath()%>/order?action=list" class="px-xl py-3 border border-primary text-primary rounded-full font-bold hover:bg-primary-fixed transition-colors" style="text-decoration:none;">返回订单列表</a>
        <% if (order.getStatus() == 0) { %>
        <a href="<%=request.getContextPath()%>/order?action=updateStatus&id=<%=order.getId()%>&status=1" class="px-xl py-3 bg-primary text-white rounded-full font-bold hover:opacity-90 transition-all" style="text-decoration:none;">确认付款</a>
        <a href="<%=request.getContextPath()%>/order?action=cancel&id=<%=order.getId()%>" class="px-xl py-3 border border-error text-error rounded-full font-bold hover:bg-error-container transition-colors" style="text-decoration:none;">取消订单</a>
        <% } %>
        <% if (order.getStatus() == 2) { %>
        <a href="<%=request.getContextPath()%>/order?action=updateStatus&id=<%=order.getId()%>&status=3" class="px-xl py-3 bg-primary text-white rounded-full font-bold hover:opacity-90 transition-all" style="text-decoration:none;">确认收货</a>
        <% } %>
    </div>
    <% } %>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
