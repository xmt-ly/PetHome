<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pethome.model.User" %>
<%
    com.pethome.model.User currentUser = (com.pethome.model.User) session.getAttribute("user");
    if (currentUser == null || currentUser.getRole() != 1) { response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return; }
    request.setAttribute("pageTitle", "用户管理");
%>
<jsp:include page="/jsp/common/header.jspf" />

<%
    List<User> userList = (List<User>) request.getAttribute("userList");
    if (userList == null) userList = new java.util.ArrayList<>();
%>

<main class="max-w-7xl mx-auto px-4 md:px-margin-desktop py-xl min-h-screen">
    <div class="flex items-center gap-base mb-xl">
        <a href="<%=request.getContextPath()%>/admin" class="text-on-surface-variant hover:text-primary" style="text-decoration:none;"><span class="material-symbols-outlined">arrow_back</span></a>
        <h1 class="font-headline-md text-headline-md">用户管理</h1>
    </div>

    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant overflow-hidden">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>昵称</th>
                    <th>邮箱</th>
                    <th>手机</th>
                    <th>角色</th>
                    <th>注册时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <% for (User u : userList) { %>
                <tr>
                    <td><%= u.getId() %></td>
                    <td><%= u.getUsername() %></td>
                    <td><%= u.getNickname() != null && !u.getNickname().isEmpty() ? u.getNickname() : "-" %></td>
                    <td><%= u.getEmail() != null && !u.getEmail().isEmpty() ? u.getEmail() : "-" %></td>
                    <td><%= u.getPhone() != null && !u.getPhone().isEmpty() ? u.getPhone() : "-" %></td>
                    <td><span class="px-2 py-1 rounded-full text-xs <%= u.getRole() == 1 ? "bg-primary-fixed-dim text-primary" : "bg-surface-container-low text-on-surface-variant" %>"><%= u.getRole() == 1 ? "管理员" : "用户" %></span></td>
                    <td class="text-sm"><%= u.getCreatedAt() != null ? u.getCreatedAt().toString().replace("T", " ").substring(0, 16) : "" %></td>
                    <td>
                        <% if (u.getRole() != 1) { %>
                        <a href="<%=request.getContextPath()%>/admin?module=user&action=delete&id=<%= u.getId() %>" class="px-3 py-1 bg-error-container/30 text-error rounded-full text-xs" onclick="return confirm('确定删除此用户？')" style="text-decoration:none;">删除</a>
                        <% } else { %>
                        <span class="text-xs text-on-surface-variant">-</span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
