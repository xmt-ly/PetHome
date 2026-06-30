<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pethome.model.Product, com.pethome.model.Category" %>
<%
    com.pethome.model.User user = (com.pethome.model.User) session.getAttribute("user");
    if (user == null || user.getRole() != 1) { response.sendRedirect(request.getContextPath() + "/jsp/login.jsp"); return; }
    request.setAttribute("pageTitle", "商品管理");
%>
<jsp:include page="/jsp/common/header.jspf" />

<%
    List<Product> productList = (List<Product>) request.getAttribute("productList");
    if (productList == null) productList = new java.util.ArrayList<>();
    List<Category> catList = (List<Category>) request.getAttribute("categories");
    if (catList == null) catList = new java.util.ArrayList<>();
%>

<main class="max-w-7xl mx-auto px-4 md:px-margin-desktop py-xl min-h-screen">
    <div class="flex items-center justify-between mb-xl">
        <div class="flex items-center gap-base">
            <a href="<%=request.getContextPath()%>/admin" class="text-on-surface-variant hover:text-primary" style="text-decoration:none;"><span class="material-symbols-outlined">arrow_back</span></a>
            <h1 class="font-headline-md text-headline-md">商品管理</h1>
        </div>
        <button onclick="openModal('addModal')" class="bg-primary text-white px-6 py-3 rounded-full font-bold hover:opacity-90 transition-all">+ 新增商品</button>
    </div>

    <!-- 商品列表 -->
    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant overflow-hidden">
        <table>
            <thead><tr><th>ID</th><th>图片</th><th>名称</th><th>价格</th><th>品牌</th><th>库存</th><th>标签</th><th>状态</th><th>操作</th></tr></thead>
            <tbody>
                <% for (Product p : productList) { %>
                <tr>
                    <td><%= p.getId() %></td>
                    <td>
                        <% if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) { %>
                        <img src="<%=request.getContextPath()%>/<%=p.getImageUrl()%>" alt="" class="w-12 h-12 rounded-lg object-cover bg-surface-container-low">
                        <% } else { %>
                        <div class="w-12 h-12 rounded-lg bg-surface-container-low flex items-center justify-center"><span class="material-symbols-outlined text-on-surface-variant text-sm">image</span></div>
                        <% } %>
                    </td>
                    <td class="max-w-xs truncate"><%= p.getName() %></td>
                    <td class="text-primary font-bold">¥<%= p.getPrice() %></td>
                    <td><%= p.getBrand() != null ? p.getBrand() : "-" %></td>
                    <td><%= p.getStock() %></td>
                    <td><%= p.getTag() != null && !p.getTag().isEmpty() ? p.getTag() : "-" %></td>
                    <td><span class="px-2 py-1 rounded-full text-xs <%= p.getStatus() == 1 ? "bg-secondary-container/30 text-secondary" : "bg-error-container/30 text-error" %>"><%= p.getStatus() == 1 ? "上架" : "下架" %></span></td>
                    <td>
                        <div class="flex gap-2">
                            <button onclick="editProduct('<%= p.getId() %>','<%= p.getName() %>','<%= p.getPrice() %>','<%= p.getCategoryId() %>','<%= p.getBrand() != null ? p.getBrand() : "" %>','<%= p.getStock() %>','<%= p.getTag() != null ? p.getTag() : "" %>','<%= p.getStatus() %>','<%= p.getImageUrl() != null ? p.getImageUrl() : "" %>')" class="px-3 py-1 bg-primary-fixed-dim text-primary rounded-full text-xs hover:opacity-80">编辑</button>
                            <a href="<%=request.getContextPath()%>/admin?module=product&action=delete&id=<%= p.getId() %>" class="px-3 py-1 bg-error-container/30 text-error rounded-full text-xs hover:opacity-80" onclick="return confirm('确定删除此商品？')" style="text-decoration:none;">删除</a>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</main>

<!-- 新增商品弹窗 -->
<div id="addModal" class="fixed inset-0 z-50 hidden flex items-center justify-center bg-black/50 backdrop-blur-sm" onclick="if(event.target===this)closeModal('addModal')">
    <div class="bg-surface rounded-2xl shadow-2xl w-full max-w-3xl mx-4 max-h-[90vh] overflow-y-auto">
        <div class="flex items-center justify-between p-lg border-b border-outline-variant">
            <h2 class="font-headline-md text-headline-md">新增商品</h2>
            <button onclick="closeModal('addModal')" class="w-10 h-10 rounded-full flex items-center justify-center hover:bg-surface-container-low transition-colors"><span class="material-symbols-outlined">close</span></button>
        </div>
        <form action="<%=request.getContextPath()%>/admin?module=product&action=add" method="post" enctype="multipart/form-data" class="p-lg grid grid-cols-1 md:grid-cols-3 gap-md">
            <div class="md:col-span-3">
                <label class="font-label-sm text-label-sm text-on-surface-variant mb-xs block">商品图片</label>
                <div id="addDropZone" class="drop-zone" ondragover="handleDragOver(event)" ondragleave="handleDragLeave(event)" ondrop="handleDrop(event, 'addFileInput', 'addPreview')" onclick="document.getElementById('addFileInput').click()">
                    <div class="drop-zone-content">
                        <span class="material-symbols-outlined text-4xl text-on-surface-variant mb-sm">cloud_upload</span>
                        <p class="text-on-surface-variant font-medium">拖拽图片到此处，或点击选择</p>
                        <p class="text-xs text-on-surface-variant mt-1">支持 JPG / PNG / GIF，最大 10MB</p>
                    </div>
                    <img id="addPreview" class="drop-zone-preview hidden">
                </div>
                <input type="file" name="imageFile" id="addFileInput" accept="image/*" class="hidden" onchange="previewImage(this, 'addPreview')">
            </div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">商品名称</label><input name="name" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" required style="outline:none;"></div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">价格</label><input name="price" type="number" step="0.01" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" required style="outline:none;"></div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">分类</label>
                <select name="categoryId" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;">
                    <% for (Category c : catList) { %>
                    <option value="<%=c.getId()%>"><%=c.getIcon() != null ? c.getIcon() + " " : ""%><%=c.getName()%></option>
                    <% } %>
                </select>
            </div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">品牌</label><input name="brand" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;"></div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">库存</label><input name="stock" type="number" value="100" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;"></div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">标签</label><input name="tag" placeholder="热销/新品/限时折" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;"></div>
            <div class="md:col-span-3"><label class="font-label-sm text-label-sm text-on-surface-variant">描述</label><textarea name="description" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" rows="2" style="outline:none;"></textarea></div>
            <div class="md:col-span-3 flex justify-end"><button class="bg-primary text-white px-8 py-3 rounded-full font-bold" type="submit">确认新增</button></div>
        </form>
    </div>
</div>

<!-- 编辑商品弹窗 -->
<div id="editModal" class="fixed inset-0 z-50 hidden flex items-center justify-center bg-black/50 backdrop-blur-sm" onclick="if(event.target===this)closeModal('editModal')">
    <div class="bg-surface rounded-2xl shadow-2xl w-full max-w-3xl mx-4 max-h-[90vh] overflow-y-auto">
        <div class="flex items-center justify-between p-lg border-b border-outline-variant">
            <h2 class="font-headline-md text-headline-md">编辑商品</h2>
            <button onclick="closeModal('editModal')" class="w-10 h-10 rounded-full flex items-center justify-center hover:bg-surface-container-low transition-colors"><span class="material-symbols-outlined">close</span></button>
        </div>
        <form action="<%=request.getContextPath()%>/admin?module=product&action=edit" method="post" enctype="multipart/form-data" class="p-lg grid grid-cols-1 md:grid-cols-3 gap-md">
            <input type="hidden" name="id" id="editId">
            <input type="hidden" name="existingImageUrl" id="editExistingImageUrl">
            <div class="md:col-span-3">
                <label class="font-label-sm text-label-sm text-on-surface-variant mb-xs block">商品图片</label>
                <div id="editDropZone" class="drop-zone" ondragover="handleDragOver(event)" ondragleave="handleDragLeave(event)" ondrop="handleDrop(event, 'editFileInput', 'editPreview')" onclick="document.getElementById('editFileInput').click()">
                    <div class="drop-zone-content">
                        <span class="material-symbols-outlined text-4xl text-on-surface-variant mb-sm">cloud_upload</span>
                        <p class="text-on-surface-variant font-medium">拖拽图片到此处，或点击选择</p>
                        <p class="text-xs text-on-surface-variant mt-1">不上传则保留原图</p>
                    </div>
                    <img id="editPreview" class="drop-zone-preview hidden">
                </div>
                <input type="file" name="imageFile" id="editFileInput" accept="image/*" class="hidden" onchange="previewImage(this, 'editPreview')">
            </div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">名称</label><input name="name" id="editName" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;"></div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">价格</label><input name="price" id="editPrice" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;"></div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">分类</label>
                <select name="categoryId" id="editCategoryId" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;">
                    <% for (Category c : catList) { %>
                    <option value="<%=c.getId()%>"><%=c.getIcon() != null ? c.getIcon() + " " : ""%><%=c.getName()%></option>
                    <% } %>
                </select>
            </div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">品牌</label><input name="brand" id="editBrand" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;"></div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">库存</label><input name="stock" id="editStock" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;"></div>
            <div><label class="font-label-sm text-label-sm text-on-surface-variant">状态</label>
                <select name="status" id="editStatus" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;">
                    <option value="1">上架</option><option value="0">下架</option>
                </select>
            </div>
            <div class="md:col-span-3"><label class="font-label-sm text-label-sm text-on-surface-variant">标签</label><input name="tag" id="editTag" class="w-full px-4 py-2 rounded-xl border border-outline-variant bg-surface-container-low" style="outline:none;"></div>
            <div class="md:col-span-3 flex justify-end"><button class="bg-primary text-white px-8 py-3 rounded-full font-bold" type="submit">保存修改</button></div>
        </form>
    </div>
</div>

<style>
.drop-zone {
    border: 2px dashed #ddc1b3;
    border-radius: 16px;
    padding: 32px;
    text-align: center;
    cursor: pointer;
    transition: all 0.2s ease;
    background: #f6f3f2;
    position: relative;
    min-height: 160px;
    display: flex;
    align-items: center;
    justify-content: center;
}
.drop-zone:hover, .drop-zone.drag-over {
    border-color: #9b4500;
    background: rgba(155, 69, 0, 0.04);
}
.drop-zone-content {
    display: flex;
    flex-direction: column;
    align-items: center;
}
.drop-zone-preview {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    object-fit: contain;
    border-radius: 14px;
    padding: 8px;
}
</style>

<script>
function openModal(id) {
    document.getElementById(id).classList.remove('hidden');
    document.body.style.overflow = 'hidden';
}
function closeModal(id) {
    document.getElementById(id).classList.add('hidden');
    document.body.style.overflow = '';
}

// 图片预览
function previewImage(input, previewId) {
    var preview = document.getElementById(previewId);
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.classList.remove('hidden');
            preview.parentElement.querySelector('.drop-zone-content').classList.add('hidden');
        };
        reader.readAsDataURL(input.files[0]);
    }
}

// 拖拽处理
function handleDragOver(e) {
    e.preventDefault();
    e.currentTarget.classList.add('drag-over');
}
function handleDragLeave(e) {
    e.currentTarget.classList.remove('drag-over');
}
function handleDrop(e, inputId, previewId) {
    e.preventDefault();
    e.currentTarget.classList.remove('drag-over');
    var files = e.dataTransfer.files;
    if (files.length > 0 && files[0].type.startsWith('image/')) {
        var input = document.getElementById(inputId);
        input.files = files;
        previewImage(input, previewId);
    }
}

function editProduct(id, name, price, categoryId, brand, stock, tag, status, imageUrl) {
    document.getElementById('editId').value = id;
    document.getElementById('editName').value = name;
    document.getElementById('editPrice').value = price;
    document.getElementById('editCategoryId').value = categoryId;
    document.getElementById('editBrand').value = brand;
    document.getElementById('editStock').value = stock;
    document.getElementById('editTag').value = tag;
    document.getElementById('editStatus').value = status;
    document.getElementById('editExistingImageUrl').value = imageUrl;

    // 显示现有图片预览
    var preview = document.getElementById('editPreview');
    var content = document.getElementById('editDropZone').querySelector('.drop-zone-content');
    document.getElementById('editFileInput').value = '';
    if (imageUrl && imageUrl.length > 0) {
        preview.src = '<%=request.getContextPath()%>/' + imageUrl;
        preview.classList.remove('hidden');
        content.classList.add('hidden');
    } else {
        preview.classList.add('hidden');
        content.classList.remove('hidden');
    }

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
