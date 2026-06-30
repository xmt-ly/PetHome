<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pethome.model.Product" %>
<%
    request.setAttribute("pageTitle", "商品详情");
    Product product = (Product) request.getAttribute("product");
    List<Product> relatedProducts = (List<Product>) request.getAttribute("relatedProducts");
    String catIcon = (String) request.getAttribute("categoryIcon");
    if (catIcon == null) catIcon = "";
%>
<jsp:include page="/jsp/common/header.jspf" />

<main class="min-h-screen">
    <% if (product == null) { %>
    <div class="max-w-6xl mx-auto px-4 md:px-margin-desktop py-20 text-center">
        <span class="material-symbols-outlined text-8xl text-on-surface-variant/20">search</span>
        <p class="text-on-surface-variant mt-4 text-lg">商品不存在或已下架</p>
        <a href="<%=request.getContextPath()%>/product" class="inline-block mt-6 bg-primary text-white px-8 py-3 rounded-full font-bold hover:opacity-90 transition-all" style="text-decoration:none;">去商城逛逛</a>
    </div>
    <% } else { %>

    <!-- ========== 面包屑导航 ========== -->
    <div class="max-w-7xl mx-auto px-4 md:px-margin-desktop pt-md">
        <nav class="flex items-center gap-2 text-sm text-on-surface-variant mb-xl">
            <a href="<%=request.getContextPath()%>/index.jsp" class="hover:text-primary transition-colors" style="text-decoration:none;">首页</a>
            <span class="material-symbols-outlined text-sm">chevron_right</span>
            <a href="<%=request.getContextPath()%>/product" class="hover:text-primary transition-colors" style="text-decoration:none;">商城</a>
            <span class="material-symbols-outlined text-sm">chevron_right</span>
            <a href="<%=request.getContextPath()%>/product?action=category&id=<%=product.getCategoryId()%>" class="hover:text-primary transition-colors" style="text-decoration:none;"><%=catIcon%> <%=product.getCategoryName() != null ? product.getCategoryName() : ""%></a>
            <span class="material-symbols-outlined text-sm">chevron_right</span>
            <span class="text-on-surface font-medium truncate max-w-[200px]"><%=product.getName()%></span>
        </nav>
    </div>

    <div class="max-w-7xl mx-auto px-4 md:px-margin-desktop">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-xl mb-xl">
            <!-- ========== 商品图片区 ========== -->
            <div class="space-y-md">
                <div class="aspect-square rounded-3xl overflow-hidden bg-surface-container-low flex items-center justify-center shadow-lg border border-outline-variant/20 relative">
                    <%
                        String pImg = product.getImageUrl();
                        if (pImg != null && !pImg.isEmpty() && !pImg.startsWith("http")) {
                    %>
                    <img src="<%=request.getContextPath()%>/<%=pImg%>" alt="<%=product.getName()%>" class="w-full h-full object-cover" id="mainImage">
                    <% } else { %>
                    <span class="material-symbols-outlined text-8xl text-primary-fixed-dim">pets</span>
                    <% } %>
                    <% if (product.getTag() != null && !product.getTag().isEmpty()) { %>
                    <span class="absolute top-4 left-4 px-4 py-1.5 bg-error text-white text-sm font-bold rounded-full shadow-lg"><%=product.getTag()%></span>
                    <% } %>
                </div>
            </div>

            <!-- ========== 商品信息区 ========== -->
            <div class="space-y-lg">
                <!-- 品牌与分类 -->
                <div class="flex items-center gap-3 flex-wrap">
                    <span class="px-3 py-1 bg-surface-container-high rounded-full text-label-sm text-on-surface-variant"><%=catIcon%> <%=product.getCategoryName() != null ? product.getCategoryName() : "未分类"%></span>
                    <% if (product.getBrand() != null && !product.getBrand().isEmpty()) { %>
                    <span class="text-label-sm text-outline tracking-wider"><%= product.getBrand() %></span>
                    <% } %>
                </div>

                <!-- 商品名 -->
                <h1 class="font-display-lg text-display-lg md:text-[44px] text-on-surface leading-tight"><%= product.getName() %></h1>

                <!-- 评分 -->
                <div class="flex items-center gap-4 text-sm">
                    <div class="flex items-center gap-0.5 text-tertiary">
                        <span class="material-symbols-outlined text-sm" style="font-variation-settings:'FILL'1;">star</span>
                        <span class="material-symbols-outlined text-sm" style="font-variation-settings:'FILL'1;">star</span>
                        <span class="material-symbols-outlined text-sm" style="font-variation-settings:'FILL'1;">star</span>
                        <span class="material-symbols-outlined text-sm" style="font-variation-settings:'FILL'1;">star</span>
                        <span class="material-symbols-outlined text-sm" style="font-variation-settings:'FILL'1;">star_half</span>
                    </div>
                    <span class="text-on-surface-variant">4.8 分 · 已售 <%=product.getSales()%> 件</span>
                </div>

                <!-- 价格 -->
                <div class="bg-surface-container-low rounded-2xl p-lg">
                    <div class="flex items-baseline gap-3">
                        <span class="font-display-lg text-4xl md:text-5xl text-primary font-bold">¥<%= product.getPrice() %></span>
                        <% if (product.getOriginalPrice() != null) { %>
                        <span class="text-xl text-outline line-through">¥<%= product.getOriginalPrice() %></span>
                        <span class="px-2 py-0.5 bg-error-container/30 text-error text-sm font-bold rounded-full">省¥<%= product.getOriginalPrice().subtract(product.getPrice()) %></span>
                        <% } %>
                    </div>
                </div>

                <!-- 简要描述 -->
                <p class="text-on-surface-variant font-body-md leading-relaxed"><%= product.getDescription() %></p>

                <!-- 数量选择 + 购物车 -->
                <div class="bg-surface-container-lowest rounded-2xl border border-outline-variant/30 p-lg space-y-md">
                    <div class="flex items-center gap-4">
                        <span class="font-label-sm text-on-surface-variant">数量</span>
                        <div class="flex items-center border border-outline-variant rounded-full overflow-hidden">
                            <button onclick="changeQty(-1)" class="w-10 h-10 flex items-center justify-center hover:bg-surface-container-low transition-colors text-lg font-bold">−</button>
                            <span id="qtyDisplay" class="w-12 text-center font-bold text-lg">1</span>
                            <button onclick="changeQty(1)" class="w-10 h-10 flex items-center justify-center hover:bg-surface-container-low transition-colors text-lg font-bold">+</button>
                        </div>
                        <span class="text-sm text-on-surface-variant">库存 <%=product.getStock()%> 件</span>
                    </div>
                    <div class="flex gap-md pt-sm">
                        <a href="javascript:void(0)" onclick="addToCart(<%=product.getId()%>)" class="flex-1 bg-primary text-white py-4 rounded-full font-bold text-center hover:opacity-90 transition-all active:scale-95 shadow-lg shadow-primary/30" style="text-decoration:none;">
                            <span class="material-symbols-outlined align-middle mr-1">shopping_cart</span> 加入购物车
                        </a>
                    </div>
                </div>

                <!-- 服务保障 -->
                <div class="grid grid-cols-3 gap-md text-center">
                    <div class="p-3 rounded-xl bg-surface-container-low">
                        <span class="material-symbols-outlined text-primary">verified</span>
                        <p class="text-xs font-bold mt-1">正品保障</p>
                    </div>
                    <div class="p-3 rounded-xl bg-surface-container-low">
                        <span class="material-symbols-outlined text-secondary">local_shipping</span>
                        <p class="text-xs font-bold mt-1">满299包邮</p>
                    </div>
                    <div class="p-3 rounded-xl bg-surface-container-low">
                        <span class="material-symbols-outlined text-tertiary">assignment_return</span>
                        <p class="text-xs font-bold mt-1">7天退换</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========== 商品详情区 ========== -->
        <div class="mb-xl bg-surface-container-lowest rounded-3xl border border-outline-variant/20 overflow-hidden">
            <div class="px-lg py-md bg-surface-container-low border-b border-outline-variant/20">
                <h2 class="font-headline-md text-headline-md">商品详情</h2>
            </div>
            <div class="p-lg md:p-xl">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-lg">
                    <div class="space-y-md">
                        <h3 class="font-headline-md text-headline-md text-on-surface">产品参数</h3>
                        <table class="w-full text-sm">
                            <tr class="border-b border-outline-variant/20">
                                <td class="py-3 text-on-surface-variant w-24">商品名称</td>
                                <td class="py-3 font-medium"><%=product.getName()%></td>
                            </tr>
                            <tr class="border-b border-outline-variant/20">
                                <td class="py-3 text-on-surface-variant">品牌</td>
                                <td class="py-3 font-medium"><%=product.getBrand() != null ? product.getBrand() : "-"%></td>
                            </tr>
                            <tr class="border-b border-outline-variant/20">
                                <td class="py-3 text-on-surface-variant">分类</td>
                                <td class="py-3 font-medium"><%=catIcon%> <%=product.getCategoryName() != null ? product.getCategoryName() : "-"%></td>
                            </tr>
                            <tr class="border-b border-outline-variant/20">
                                <td class="py-3 text-on-surface-variant">价格</td>
                                <td class="py-3 font-medium text-primary font-bold">¥<%=product.getPrice()%></td>
                            </tr>
                            <tr>
                                <td class="py-3 text-on-surface-variant">库存</td>
                                <td class="py-3 font-medium"><%=product.getStock()%> 件</td>
                            </tr>
                        </table>
                    </div>
                    <div class="space-y-md">
                        <h3 class="font-headline-md text-headline-md text-on-surface">产品描述</h3>
                        <p class="text-on-surface-variant font-body-md leading-relaxed"><%=product.getDescription()%></p>
                        <div class="flex flex-wrap gap-2 pt-sm">
                            <span class="px-3 py-1 rounded-full bg-primary-fixed-dim/40 text-primary text-sm">#宠物用品</span>
                            <span class="px-3 py-1 rounded-full bg-primary-fixed-dim/40 text-primary text-sm">#<%=product.getCategoryName() != null ? product.getCategoryName() : "好物"%></span>
                            <% if (product.getBrand() != null && !product.getBrand().isEmpty()) { %>
                            <span class="px-3 py-1 rounded-full bg-primary-fixed-dim/40 text-primary text-sm">#<%=product.getBrand()%></span>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== 推荐商品 ========== -->
    <% if (relatedProducts != null && !relatedProducts.isEmpty()) { %>
    <section class="max-w-7xl mx-auto px-4 md:px-margin-desktop pb-xl">
        <div class="flex justify-between items-end mb-lg">
            <div>
                <h2 class="font-display-lg text-display-lg text-on-surface">同分类推荐</h2>
                <p class="text-on-surface-variant">更多精选好物等你发现</p>
            </div>
            <a href="<%=request.getContextPath()%>/product?action=category&id=<%=product.getCategoryId()%>" class="hidden md:flex items-center text-primary font-bold hover:underline underline-offset-4" style="text-decoration:none;">
                查看全部 <span class="material-symbols-outlined ml-1">chevron_right</span>
            </a>
        </div>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-md">
            <% for (Product rp : relatedProducts) { %>
            <a href="<%=request.getContextPath()%>/product?action=detail&id=<%=rp.getId()%>" class="group bg-surface-container-lowest rounded-xl overflow-hidden shadow-sm hover:shadow-xl border border-outline-variant/20 hover:border-primary-fixed-dim transition-all active:scale-[0.98]" style="text-decoration:none;">
                <div class="aspect-square overflow-hidden bg-surface-container-low">
                    <% String rImg = rp.getImageUrl(); if (rImg != null && !rImg.isEmpty() && !rImg.startsWith("http")) { %>
                    <img src="<%=request.getContextPath()%>/<%=rImg%>" alt="<%=rp.getName()%>" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                    <% } else { %>
                    <div class="w-full h-full flex items-center justify-center text-on-surface-variant/30"><span class="material-symbols-outlined text-5xl">pets</span></div>
                    <% } %>
                </div>
                <div class="p-3">
                    <p class="text-xs text-outline truncate"><%=rp.getBrand() != null ? rp.getBrand() : ""%></p>
                    <h4 class="font-bold text-sm truncate mt-0.5"><%=rp.getName()%></h4>
                    <div class="flex items-center justify-between mt-2">
                        <span class="text-primary font-bold">¥<%=rp.getPrice()%></span>
                        <span class="text-xs text-on-surface-variant">已售 <%=rp.getSales()%></span>
                    </div>
                </div>
            </a>
            <% } %>
        </div>
    </section>
    <% } %>

    <% } %>
</main>

<script>
let currentQty = 1;
function changeQty(delta) {
    currentQty = Math.max(1, Math.min(currentQty + delta, <%= product != null ? product.getStock() : 99 %>));
    document.getElementById('qtyDisplay').textContent = currentQty;
}
function addToCart(productId) {
    const url = '<%=request.getContextPath()%>/cart?action=add&productId=' + productId + '&quantity=' + currentQty;
    window.location.href = url;
}
</script>

<jsp:include page="/jsp/common/footer.jspf" />
