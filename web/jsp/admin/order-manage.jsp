<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pethome.model.Order" %>
<%
    com.pethome.model.User user = (com.pethome.model.User) session.getAttribute("user");
    if (user == null || user.getRole() != 1) { response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return; }
    request.setAttribute("pageTitle", "订单管理");
%>
<jsp:include page="/jsp/common/header.jspf" />

<%
    List<Order> orderList = (List<Order>) request.getAttribute("orderList");
    if (orderList == null) orderList = new java.util.ArrayList<>();
%>

<main class="max-w-7xl mx-auto px-4 md:px-margin-desktop py-xl min-h-screen">
    <div class="flex items-center gap-base mb-xl">
        <a href="<%=request.getContextPath()%>/admin" class="text-on-surface-variant hover:text-primary" style="text-decoration:none;"><span class="material-symbols-outlined">arrow_back</span></a>
        <h1 class="font-headline-md text-headline-md">订单管理</h1>
    </div>

    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant overflow-hidden">
        <table>
            <thead>
                <tr>
                    <th>订单号</th>
                    <th>用户</th>
                    <th>金额</th>
                    <th>状态</th>
                    <th>时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <% for (Order o : orderList) { %>
                <tr>
                    <td class="text-sm"><%= o.getOrderNo() %></td>
                    <td><%= o.getUsername() != null ? o.getUsername() : "" %></td>
                    <td class="text-primary font-bold">¥<%= o.getTotalAmount() %></td>
                    <td>
                        <span class="px-2 py-1 rounded-full text-xs font-bold
                            <%= o.getStatus() == 0 ? "bg-warning text-warning-content" :
                               o.getStatus() == 1 ? "bg-info text-info-content" :
                               o.getStatus() == 2 ? "bg-info text-info-content" :
                               o.getStatus() == 3 ? "bg-secondary-container/30 text-secondary" :
                               "bg-error-container/30 text-error" %>">
                            <%= o.getStatusText() %>
                        </span>
                    </td>
                    <td class="text-sm"><%= o.getCreatedAt() != null ? o.getCreatedAt().toString().replace("T", " ").substring(0, 16) : "" %></td>
                    <td>
                        <div class="flex gap-2">
                            <a href="<%=request.getContextPath()%>/order?action=detail&id=<%= o.getId() %>" class="px-3 py-1 bg-primary-fixed-dim text-primary rounded-full text-xs" style="text-decoration:none;">详情</a>
                            <% if (o.getStatus() == 1) { %>
                            <a href="<%=request.getContextPath()%>/admin?module=order&action=updateStatus&id=<%= o.getId() %>&status=2" class="px-3 py-1 bg-secondary-container/30 text-secondary rounded-full text-xs" style="text-decoration:none;">确认发货</a>
                            <% } %>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
