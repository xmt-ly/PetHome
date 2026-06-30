<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pethome.model.Product, com.pethome.model.Category" %>
<% request.setAttribute("pageTitle", "萌宠商城"); %>
<jsp:include page="/jsp/common/header.jspf" />

<%
    List<Product> productList = (List<Product>) request.getAttribute("productList");
    Boolean searchResult = (Boolean) request.getAttribute("searchResult");
    String keyword = (String) request.getAttribute("keyword");
    if (searchResult == null) searchResult = false;
    if (keyword == null) keyword = "";
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 1;
    if (totalCount == null) totalCount = 0;
%>

<main class="max-w-7xl mx-auto px-4 md:px-margin-desktop py-lg min-h-screen">
    <!-- 促销横幅 -->
    <section class="mb-xl relative overflow-hidden rounded-xl bg-primary-container h-64 flex items-center shadow-md">
        <div class="relative z-10 px-xl w-full md:w-2/3">
            <h2 class="font-display-lg text-display-lg text-on-primary-container mb-base">限时特惠：高端犬粮系列</h2>
            <p class="font-body-lg text-body-lg text-on-primary-fixed-variant mb-md opacity-90">为您的爱犬提供全面营养，指定品牌满 299 减 50。</p>
            <button class="bg-primary text-on-primary px-lg py-base rounded-full font-label-sm flex items-center gap-xs hover:shadow-lg transition-all active:scale-95">
                立即抢购 <span class="material-symbols-outlined">arrow_forward</span>
            </button>
        </div>
    </section>

    <!-- 搜索框 -->
    <div class="mb-lg">
        <form action="<%=request.getContextPath()%>/product" method="get" class="flex gap-base max-w-xl">
            <input type="hidden" name="action" value="search">
            <input name="keyword" value="<%=keyword %>" class="flex-1 px-6 py-3 rounded-full border border-outline-variant bg-surface-container-lowest focus:ring-2 focus:ring-primary-container transition-all" placeholder="搜索宠物好物..." style="outline:none;">
            <button type="submit" class="px-6 py-3 bg-primary text-white rounded-full hover:opacity-90 transition-opacity">搜索</button>
        </form>
    </div>

    <div class="flex flex-col lg:flex-row gap-lg">
        <!-- 侧边栏筛选 -->
        <aside class="w-full lg:w-64 space-y-lg shrink-0">
            <h3 class="font-headline-md text-on-surface mb-md">商品筛选</h3>
            <div>
                <span class="font-label-sm text-outline uppercase tracking-wider mb-sm block">商品分类</span>
                <div class="space-y-sm">
                    <a href="<%=request.getContextPath()%>/product" class="block px-base py-2 rounded-lg hover:bg-surface-container-low transition-colors" style="text-decoration:none;">全部分类</a>
                    <%
                        List<Category> cats = (List<Category>) request.getAttribute("categories");
                        Integer currentCategoryId = (Integer) request.getAttribute("categoryId");
                        if (cats != null) {
                            for (Category cat : cats) {
                                String activeClass = (currentCategoryId != null && cat.getId() == currentCategoryId) ? "bg-primary-fixed-dim text-primary font-medium" : "";
                    %>
                    <a href="<%=request.getContextPath()%>/product?action=category&id=<%=cat.getId()%>"
                       class="block px-base py-2 rounded-lg hover:bg-surface-container-low transition-colors <%=activeClass%>"
                       style="text-decoration:none;">
                        <%=cat.getIcon() != null ? cat.getIcon() : ""%> <%=cat.getName()%>
                    </a>
                    <%      }
                        } %>
                </div>
            </div>
        </aside>

        <!-- 商品列表 -->
        <div class="flex-1">
            <div class="flex justify-between items-center mb-md">
                <p class="text-body-md text-on-surface-variant">
                    <% if (searchResult) { %>
                        搜索 "<%=keyword %>" 找到 <span class="font-bold text-primary"><%=totalCount %></span> 件相关商品
                    <% } else { %>
                        为您找到 <span class="font-bold text-primary"><%=totalCount %></span> 件商品
                    <% } %>
                </p>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-md">
                <% if (productList != null && !productList.isEmpty()) {
                    for (Product p : productList) { %>
                <div class="bento-card group bg-surface-container-lowest rounded-xl overflow-hidden shadow-sm hover:shadow-xl border border-transparent hover:border-primary-fixed-dim transition-all cursor-pointer" onclick="location.href='<%=request.getContextPath()%>/product?action=detail&id=<%=p.getId()%>'">
                    <div class="relative h-48 overflow-hidden bg-surface-container-low flex items-center justify-center">
                        <%
                            String imgUrl = p.getImageUrl();
                            if (imgUrl != null && !imgUrl.isEmpty() && !imgUrl.startsWith("http")) {
                        %>
                        <img src="<%=request.getContextPath()%>/<%=imgUrl%>" alt="<%=p.getName()%>" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <% } else { %>
                        <span class="material-symbols-outlined text-5xl text-primary-fixed-dim">pets</span>
                        <% } %>
                        <% if (p.getTag() != null && !p.getTag().isEmpty()) { %>
                        <span class="absolute top-base left-base bg-error text-on-error text-label-sm px-sm py-xs rounded-full"><%=p.getTag() %></span>
                        <% } %>
                    </div>
                    <div class="p-md">
                        <p class="text-label-sm text-outline mb-xs"><%=p.getBrand() != null ? p.getBrand() : "" %></p>
                        <h4 class="font-headline-md text-on-surface text-body-lg mb-base line-clamp-2"><%=p.getName() %></h4>
                        <p class="text-sm text-on-surface-variant mb-base truncate"><%=p.getDescription() != null && p.getDescription().length() > 60 ? p.getDescription().substring(0,60)+"..." : p.getDescription() %></p>
                        <div class="flex items-center justify-between mt-auto">
                            <div>
                                <span class="text-primary font-bold text-headline-md">¥<%=p.getPrice() %></span>
                                <% if (p.getOriginalPrice() != null) { %>
                                <span class="text-label-sm text-outline line-through ml-1">¥<%=p.getOriginalPrice() %></span>
                                <% } %>
                            </div>
                            <a href="<%=request.getContextPath()%>/cart?action=add&productId=<%=p.getId() %>" class="p-base bg-secondary text-on-secondary rounded-full hover:opacity-90 transition-colors active:scale-90" style="text-decoration:none;">
                                <span class="material-symbols-outlined">add_shopping_cart</span>
                            </a>
                        </div>
                    </div>
                </div>
                <% }
                } else { %>
                <div class="col-span-full text-center py-xl">
                    <span class="material-symbols-outlined text-6xl text-on-surface-variant/30">search</span>
                    <p class="text-on-surface-variant mt-2">暂无商品</p>
                </div>
                <% } %>
            </div>

            <!-- 分页 -->
            <% if (!searchResult && totalPages > 1) { %>
            <nav class="flex justify-center items-center gap-base mt-xl">
                <a href="<%=request.getContextPath()%>/product?page=<%=currentPage-1%>" class="p-base rounded-full hover:bg-surface-container transition-colors <%=currentPage<=1?"disabled":"" %>" style="pointer-events:<%=currentPage<=1?"none":"auto"%>;opacity:<%=currentPage<=1?"0.3":"1"%>;">
                    <span class="material-symbols-outlined">chevron_left</span>
                </a>
                <% for (int i = 1; i <= totalPages; i++) { %>
                <a href="<%=request.getContextPath()%>/product?page=<%=i%>" class="w-10 h-10 rounded-full <%=i==currentPage?"bg-primary text-on-primary":"hover:bg-surface-container"%> font-label-sm flex items-center justify-center" style="text-decoration:none;"><%=i%></a>
                <% } %>
                <a href="<%=request.getContextPath()%>/product?page=<%=currentPage+1%>" class="p-base rounded-full hover:bg-surface-container transition-colors <%=currentPage>=totalPages?"disabled":"" %>" style="pointer-events:<%=currentPage>=totalPages?"none":"auto"%>;opacity:<%=currentPage>=totalPages?"0.3":"1"%>;">
                    <span class="material-symbols-outlined">chevron_right</span>
                </a>
            </nav>
            <% } %>
        </div>
    </div>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
