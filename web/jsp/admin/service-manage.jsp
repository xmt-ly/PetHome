<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pethome.model.Service" %>
<%
    com.pethome.model.User user = (com.pethome.model.User) session.getAttribute("user");
    if (user == null || user.getRole() != 1) { response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return; }
    request.setAttribute("pageTitle", "服务管理");
%>
<jsp:include page="/jsp/common/header.jspf" />

<%
    List<Service> serviceList = (List<Service>) request.getAttribute("serviceList");
    if (serviceList == null) serviceList = new java.util.ArrayList<>();
%>

<main class="max-w-7xl mx-auto px-4 md:px-margin-desktop py-xl min-h-screen">
    <div class="flex items-center justify-between mb-xl">
        <div class="flex items-center gap-base">
            <a href="<%=request.getContextPath()%>/admin" class="text-on-surface-variant hover:text-primary" style="text-decoration:none;"><span class="material-symbols-outlined">arrow_back</span></a>
            <h1 class="font-headline-md text-headline-md">服务管理</h1>
        </div>
        <button onclick="openModal('addModal')" class="bg-primary text-white px-6 py-3 rounded-full font-bold hover:opacity-90 transition-all">+ 新增服务</button>
    </div>

    <!-- 服务列表 -->
    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant overflow-hidden">
        <table>
            <thead><tr><th>ID</th><th>名称</th><th>分类</th><th>价格</th><th>状态</th><th>操作</th></tr></thead>
            <tbody>
                <% for (Service s : serviceList) { %>
                <tr>
                    <td><%= s.getId() %></td>
                    <td><%= s.getName() %></td>
                    <td><%= s.getCategory() %></td>
                    <td class="text-primary font-bold">¥<%= s.getPrice() %></td>
                    <td><span class="px-2 py-1 rounded-full text-xs <%= s.getStatus() == 1 ? "bg-secondary-container/30 text-secondary" : "bg-error-container/30 text-error" %>"><%= s.getStatus() == 1 ? "上架" : "下架" %></span></td>
                    <td>
                        <div class="flex gap-2">
                            <button onclick="editService('<%= s.getId() %>','<%= s.getName() %>','<%= s.getDescription() != null ? s.getDescription().replace("'","\\'") : "" %>','<%= s.getPrice() %>','<%= s.getCategory() %>','<%= s.getStatus() %>')" class="px-3 py-1 bg-primary-fixed-dim text-primary rounded-full text-xs">编辑</button>
                            <a href="<%=request.getContextPath()%>/admin?module=service&action=delete&id=<%= s.getId() %>" class="px-3 py-1 bg-error-container/30 text-error rounded-full text-xs" onclick="return confirm('确定删除？')" style="text-decoration:none;">删除</a>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</main>

<!-- 新增服务弹窗 -->
<div id="addModal" class="fixed inset-0 z-50 hidden flex items-center justify-center bg-black/50 backdrop-blur-sm" onclick="if(event.target===this)closeModal('addModal')">
    <div class="bg-surface rounded-2xl shadow-2xl w-full max-w-2xl mx-4 max-h-[90vh] overflow-y-auto">
        <div class="flex items-center justify-between p-lg border-b border-outline-variant">
            <h2 class="font-headline-md text-headline-md">新增服务</h2>
            <button onclick="closeModal('addModal')" class="w-10 h-10 rounded-full flex items-center justify-center hover:bg-surface-container-low transition-colors"><span class="material-symbols-outlined">close</span></button>
        </div>
        <form action="<%=request.getContextPath()%>/admin" method="post" class="p-lg grid grid-cols-1 md:grid-cols-2 gap-md">
            <input type="hidden" name="module" value="service">
            <input type="hidden" name="action" value="add">
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">服务名称</label><input name="name" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" required style="outline:none;"></div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">价格</label><input name="price" type="number" step="0.01" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" required style="outline:none;"></div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">分类</label>
                <select name="category" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;">
                    <option value="grooming">美容 (grooming)</option>
                    <option value="boarding">寄宿 (boarding)</option>
                    <option value="clinic">医疗 (clinic)</option>
                </select>
            </div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">状态</label>
                <select name="status" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;">
                    <option value="1">上架</option><option value="0">下架</option>
                </select>
            </div>
            <div class="md:col-span-2"><label class="font-label-sm text-label-sm text-on-surface-variant">描述</label><textarea name="description" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" rows="2" style="outline:none;"></textarea></div>
            <div class="md:col-span-2 flex justify-end"><button class="bg-primary text-white px-8 py-3 rounded-full font-bold" type="submit">确认新增</button></div>
        </form>
    </div>
</div>

<!-- 编辑服务弹窗 -->
<div id="editModal" class="fixed inset-0 z-50 hidden flex items-center justify-center bg-black/50 backdrop-blur-sm" onclick="if(event.target===this)closeModal('editModal')">
    <div class="bg-surface rounded-2xl shadow-2xl w-full max-w-2xl mx-4 max-h-[90vh] overflow-y-auto">
        <div class="flex items-center justify-between p-lg border-b border-outline-variant">
            <h2 class="font-headline-md text-headline-md">编辑服务</h2>
            <button onclick="closeModal('editModal')" class="w-10 h-10 rounded-full flex items-center justify-center hover:bg-surface-container-low transition-colors"><span class="material-symbols-outlined">close</span></button>
        </div>
        <form action="<%=request.getContextPath()%>/admin" method="post" class="p-lg grid grid-cols-1 md:grid-cols-2 gap-md">
            <input type="hidden" name="module" value="service">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="id" id="editId">
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">名称</label><input name="name" id="editName" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;"></div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">价格</label><input name="price" id="editPrice" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;"></div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">分类</label>
                <select name="category" id="editCategory" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;">
                    <option value="grooming">美容</option><option value="boarding">寄宿</option><option value="clinic">医疗</option>
                </select>
            </div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">状态</label>
                <select name="status" id="editStatus" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;">
                    <option value="1">上架</option><option value="0">下架</option>
                </select>
            </div>
            <div class="md:col-span-2"><label class="font-label-sm text-label-sm text-on-surface-variant">描述</label><textarea name="description" id="editDescription" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" rows="2" style="outline:none;"></textarea></div>
            <div class="md:col-span-2 flex justify-end"><button class="bg-primary text-white px-8 py-3 rounded-full font-bold" type="submit">保存修改</button></div>
        </form>
    </div>
</div>

<script>
function openModal(id) {
    document.getElementById(id).classList.remove('hidden');
    document.body.style.overflow = 'hidden';
}
function closeModal(id) {
    document.getElementById(id).classList.add('hidden');
    document.body.style.overflow = '';
}
function editService(id, name, desc, price, category, status) {
    document.getElementById('editId').value = id;
    document.getElementById('editName').value = name;
    document.getElementById('editDescription').value = desc;
    document.getElementById('editPrice').value = price;
    document.getElementById('editCategory').value = category;
    document.getElementById('editStatus').value = status;
    openModal('editModal');
}
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeModal('addModal');
        closeModal('editModal');
    }
});
</script>

<jsp:include page="/jsp/common/footer.jspf" />
