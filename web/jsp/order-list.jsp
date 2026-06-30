<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pethome.model.Order" %>
<% request.setAttribute("pageTitle", "我的订单"); %>
<jsp:include page="/jsp/common/header.jspf" />

<%
    List<Order> orderList = (List<Order>) request.getAttribute("orderList");
    if (orderList == null) orderList = new java.util.ArrayList<>();
%>

<main class="max-w-4xl mx-auto px-4 md:px-margin-desktop py-xl min-h-screen">
    <h1 class="font-display-lg text-display-lg text-on-surface mb-xl">我的订单</h1>

    <% if (orderList.isEmpty()) { %>
    <div class="text-center py-xl">
        <span class="material-symbols-outlined text-8xl text-on-surface-variant/20">receipt_long</span>
        <p class="text-on-surface-variant mt-4">暂无订单</p>
        <a href="<%=request.getContextPath()%>/product" class="inline-block bg-primary text-white px-xl py-3 rounded-full mt-md" style="text-decoration:none;">去购物</a>
    </div>
    <% } else {
        for (Order order : orderList) { %>
    <div class="bg-surface-container-lowest rounded-xl p-md border border-outline-variant mb-md hover:shadow-md transition-all">
        <div class="flex justify-between items-start mb-md">
            <div>
                <p class="text-sm text-on-surface-variant">订单编号：<%= order.getOrderNo() %></p>
                <p class="text-sm text-on-surface-variant">下单时间：<%= order.getCreatedAt() != null ? order.getCreatedAt().toString().replace("T", " ") : "" %></p>
            </div>
            <div class="text-right">
                <span class="inline-block px-3 py-1 rounded-full text-sm font-bold
                    <%= order.getStatus() == 0 ? "bg-warning/20 text-warning" :
                       order.getStatus() == 3 ? "bg-secondary-container/20 text-secondary" :
                       order.getStatus() == 4 ? "bg-error-container/20 text-error" :
                       "bg-primary-fixed-dim/20 text-primary" %>">
                    <%= order.getStatusText() %>
                </span>
            </div>
        </div>

        <div class="space-y-xs mb-md">
            <% if (order.getItems() != null) {
                for (com.pethome.model.OrderItem item : order.getItems()) { %>
            <div class="flex justify-between text-sm">
                <span><%= item.getProductName() %> × <%= item.getQuantity() %></span>
                <span>¥<%= item.getSubtotal() %></span>
            </div>
            <% } } %>
        </div>

        <div class="flex justify-between items-center pt-md border-t border-outline-variant">
            <span class="font-bold">合计：¥<%= order.getTotalAmount() %></span>
            <div class="flex gap-base">
                <a href="<%=request.getContextPath()%>/order?action=detail&id=<%= order.getId() %>" class="px-4 py-2 border border-primary text-primary rounded-full text-sm hover:bg-primary-fixed transition-colors" style="text-decoration:none;">查看详情</a>
                <% if (order.getStatus() == 0) { %>
                <a href="<%=request.getContextPath()%>/order?action=updateStatus&id=<%= order.getId() %>&status=1" class="px-4 py-2 bg-primary text-white rounded-full text-sm hover:opacity-90" style="text-decoration:none;">确认付款</a>
                <a href="<%=request.getContextPath()%>/order?action=cancel&id=<%= order.getId() %>" class="px-4 py-2 border border-error text-error rounded-full text-sm hover:bg-error-container transition-colors" style="text-decoration:none;">取消订单</a>
                <% } %>
                <% if (order.getStatus() == 2) { %>
                <a href="<%=request.getContextPath()%>/order?action=updateStatus&id=<%= order.getId() %>&status=3" class="px-4 py-2 bg-primary text-white rounded-full text-sm hover:opacity-90" style="text-decoration:none;">确认收货</a>
                <% } %>
            </div>
        </div>
    </div>
    <% }
    } %>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
