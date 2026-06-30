<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.*, java.util.List, com.pethome.model.Category, com.pethome.dao.CategoryDao, com.pethome.model.Product, com.pethome.dao.ProductDao" %>
<%
    request.setAttribute("pageTitle", "首页");
    request.setAttribute("activePage", "home");

    // 加载全部分类（八大品类体系）
    CategoryDao categoryDao = new CategoryDao();
    List<Category> categories = categoryDao.findAll();
    request.setAttribute("categories", categories);

    // 加载销量最高的 4 件商品（精品推荐）
    ProductDao productDao = new ProductDao();
    List<Product> topProducts = productDao.findTopBySales(4);
    request.setAttribute("allProducts", topProducts);
%>
<jsp:include page="/jsp/common/header.jspf" />

<main>
    <!-- ==================== Hero Banner ==================== -->
    <section class="relative overflow-hidden hero-gradient pt-10 pb-20 px-4 md:px-margin-desktop">
        <div class="max-w-7xl mx-auto flex flex-col md:flex-row items-center gap-xl">
            <!-- 左侧文本 -->
            <div class="flex-1 space-y-md animate-fade-in text-center md:text-left">
                <div class="inline-block px-4 py-1 rounded-full bg-primary-container/20 text-primary-fixed-variant font-label-sm text-label-sm">
                    专业宠物护理 15 年
                </div>
                <h1 class="font-display-lg text-display-lg md:text-[56px] text-on-surface leading-tight">
                    给它一个<span class="text-primary italic">温暖</span>的家<br>让爱时刻相伴
                </h1>
                <p class="font-body-lg text-body-lg text-on-surface-variant max-w-lg">
                    萌宠之家致力于为您的宠物提供全方位的高品质生活解决方案。从精细美容到专业诊疗，每一份关怀都倾注了我们的热爱。
                </p>
                <div class="pt-sm flex flex-col sm:flex-row items-center gap-md justify-center md:justify-start">
                    <a href="<%=request.getContextPath()%>/service" class="px-xl py-4 bg-primary text-white font-bold rounded-full hover:opacity-90 transition-all active:scale-95 shadow-lg" style="background-color:#9b4500;color:white;text-decoration:none;">立即预约服务</a>
                    <a href="<%=request.getContextPath()%>/jsp/about.jsp" class="px-xl py-4 bg-white text-primary font-bold border-2 border-primary rounded-full hover:bg-surface-container-low transition-all active:scale-95" style="text-decoration:none;">了解更多</a>
                </div>
                <div class="flex items-center gap-4 pt-base justify-center md:justify-start">
                    <div class="flex -space-x-3">
                        <div class="w-10 h-10 rounded-full border-2 border-white bg-surface-container overflow-hidden"><img src="<%=request.getContextPath()%>/static/images/home/2.png" alt="用户头像" class="w-full h-full object-cover"></div>
                        <div class="w-10 h-10 rounded-full border-2 border-white bg-surface-container overflow-hidden"><img src="<%=request.getContextPath()%>/static/images/home/3.png" alt="用户头像" class="w-full h-full object-cover"></div>
                        <div class="w-10 h-10 rounded-full border-2 border-white bg-surface-container overflow-hidden"><img src="<%=request.getContextPath()%>/static/images/home/4.png" alt="用户头像" class="w-full h-full object-cover"></div>
                    </div>
                    <span class="text-on-surface-variant font-label-sm text-label-sm">5000+ 宠物主人的共同信赖</span>
                </div>
            </div>
            <!-- 右侧图片 -->
            <div class="flex-1 relative">
                <div class="relative z-10 w-full aspect-[4/5] md:aspect-square rounded-3xl overflow-hidden shadow-2xl border-4 border-white transform rotate-2 bg-surface-container-low">
                    <img src="<%=request.getContextPath()%>/static/images/home/1.png" alt="宠物与主人" class="w-full h-full object-cover">
                </div>
                <div class="absolute -top-10 -right-10 w-40 h-40 bg-secondary/10 rounded-full blur-3xl"></div>
                <div class="absolute -bottom-10 -left-10 w-64 h-64 bg-primary/10 rounded-full blur-3xl"></div>
            </div>
        </div>
    </section>

    <!-- ==================== 服务预览 ==================== -->
    <section class="py-xl px-4 md:px-margin-desktop bg-white">
        <div class="max-w-7xl mx-auto">
            <div class="text-center mb-xl">
                <h2 class="font-display-lg text-display-lg text-on-surface mb-sm">专业的一站式服务</h2>
                <p class="text-on-surface-variant max-w-2xl mx-auto">我们不仅仅是一个宠物店，更是宠物健康的守护者。</p>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-md">
                <!-- 美容 -->
                <div class="group p-xl bg-surface-container-low rounded-3xl transition-all duration-300 hover:bg-primary-container hover:-translate-y-2 cursor-pointer" onclick="location.href='<%=request.getContextPath()%>/service'">
                    <div class="w-16 h-16 bg-white rounded-2xl flex items-center justify-center mb-md shadow-sm group-hover:scale-110 transition-transform">
                        <span class="material-symbols-outlined text-primary text-4xl">content_cut</span>
                    </div>
                    <h3 class="font-headline-md text-headline-md mb-sm">精细美容 (Grooming)</h3>
                    <p class="text-on-surface-variant group-hover:text-on-primary-container/80 transition-colors">专业美容师团队，提供SPA洗浴、造型修剪等全套护理。</p>
                    <div class="mt-base flex items-center text-primary group-hover:text-white font-bold">
                        <span>了解详情</span>
                        <span class="material-symbols-outlined ml-2">arrow_forward</span>
                    </div>
                </div>
                <!-- 寄养 -->
                <div class="group p-xl bg-surface-container-low rounded-3xl transition-all duration-300 hover:bg-secondary-container hover:-translate-y-2 cursor-pointer" onclick="location.href='<%=request.getContextPath()%>/service'">
                    <div class="w-16 h-16 bg-white rounded-2xl flex items-center justify-center mb-md shadow-sm group-hover:scale-110 transition-transform">
                        <span class="material-symbols-outlined text-secondary text-4xl">home</span>
                    </div>
                    <h3 class="font-headline-md text-headline-md mb-sm">高端寄养 (Boarding)</h3>
                    <p class="text-on-surface-variant group-hover:text-on-secondary-container/80 transition-colors">24小时监控恒温寄养间，专人陪玩遛狗服务。</p>
                    <div class="mt-base flex items-center text-secondary group-hover:text-on-secondary-container font-bold">
                        <span>了解详情</span>
                        <span class="material-symbols-outlined ml-2">arrow_forward</span>
                    </div>
                </div>
                <!-- 医疗 -->
                <div class="group p-xl bg-surface-container-low rounded-3xl transition-all duration-300 hover:bg-tertiary-container hover:-translate-y-2 cursor-pointer" onclick="location.href='<%=request.getContextPath()%>/service'">
                    <div class="w-16 h-16 bg-white rounded-2xl flex items-center justify-center mb-md shadow-sm group-hover:scale-110 transition-transform">
                        <span class="material-symbols-outlined text-tertiary text-4xl">medical_services</span>
                    </div>
                    <h3 class="font-headline-md text-headline-md mb-sm">宠物医疗 (Clinic)</h3>
                    <p class="text-on-surface-variant group-hover:text-on-tertiary-container/80 transition-colors">配备先进设备的医疗中心，专业兽医全程在线。</p>
                    <div class="mt-base flex items-center text-tertiary group-hover:text-white font-bold">
                        <span>了解详情</span>
                        <span class="material-symbols-outlined ml-2">arrow_forward</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ==================== 全品类产品体系（八大品类） ==================== -->
    <section class="py-xl px-4 md:px-margin-desktop bg-surface-container-low">
        <div class="max-w-7xl mx-auto">
            <div class="flex justify-between items-end mb-xl">
                <div>
                    <p class="text-label-sm text-outline uppercase tracking-wider mb-xs">CATEGORIES · 品类</p>
                    <h2 class="font-display-lg text-display-lg text-on-surface">全品类产品体系</h2>
                    <p class="text-on-surface-variant">覆盖养宠生活的每一个角落</p>
                </div>
                <a href="<%=request.getContextPath()%>/product" class="hidden md:flex items-center text-primary font-bold hover:underline underline-offset-4" style="text-decoration:none;">
                    查看全部商品 <span class="material-symbols-outlined ml-1">chevron_right</span>
                </a>
            </div>

            <div class="grid grid-cols-2 sm:grid-cols-4 gap-md">
            <%
                List<Category> cats = (List<Category>) request.getAttribute("categories");
                if (cats != null) {
                    for (Category cat : cats) {
                        String icon = cat.getIcon();
                        if (icon == null) icon = "";
            %>
                <a href="<%=request.getContextPath()%>/product?action=category&id=<%=cat.getId()%>"
                   class="group bg-surface-container-lowest rounded-2xl p-lg border border-outline-variant/30 hover:border-primary-fixed-dim hover:shadow-lg transition-all duration-300 active:scale-[0.97]"
                   style="text-decoration:none;">
                    <div class="text-5xl mb-sm group-hover:scale-110 transition-transform duration-300"><%=icon%></div>
                    <h3 class="font-headline-md text-headline-md text-on-surface mb-xs"><%=cat.getName()%></h3>
                    <p class="text-label-sm text-on-surface-variant"><%=cat.getSubcategories() != null ? cat.getSubcategories() : ""%></p>
                </a>
            <%
                    }
                }
            %>
            </div>

            <div class="text-center mt-xl md:hidden">
                <a href="<%=request.getContextPath()%>/product" class="inline-flex items-center text-primary font-bold hover:underline underline-offset-4" style="text-decoration:none;">
                    查看全部商品 <span class="material-symbols-outlined ml-1">chevron_right</span>
                </a>
            </div>
        </div>
    </section>

    <!-- ==================== 精品推荐 ==================== -->
    <section class="py-xl px-4 md:px-margin-desktop">
        <div class="max-w-7xl mx-auto">
            <div class="flex justify-between items-end mb-xl">
                <div>
                    <h2 class="font-display-lg text-display-lg text-on-surface">精品推荐</h2>
                    <p class="text-on-surface-variant">为您甄选全球顶尖宠物用品</p>
                </div>
                <a href="<%=request.getContextPath()%>/product" class="hidden md:flex items-center text-primary font-bold hover:underline underline-offset-4" style="text-decoration:none;">
                    查看全部商品 <span class="material-symbols-outlined ml-1">chevron_right</span>
                </a>
            </div>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-md">
                <%
                    java.util.List<com.pethome.model.Product> products =
                        (java.util.List<com.pethome.model.Product>) request.getAttribute("allProducts");
                    if (products == null || products.isEmpty()) {
                        // 首页直接显示示例
                %>
                <div class="bg-white p-4 rounded-2xl shadow-sm text-center py-xl">
                    <span class="material-symbols-outlined text-6xl text-primary-fixed-dim">pets</span>
                    <p class="text-on-surface-variant mt-2">商品加载中...</p>
                </div>
                <% } else {
                    int count = 0;
                    for (com.pethome.model.Product p : products) {
                        if (count >= 8) break;
                %>
                <div class="group bg-white p-4 rounded-2xl shadow-sm hover:shadow-xl transition-all duration-300">
                    <div class="relative aspect-square rounded-xl overflow-hidden mb-sm bg-surface-container-low">
                        <%
                            String prodImg = p.getImageUrl();
                            if (prodImg != null && !prodImg.isEmpty() && !prodImg.startsWith("http")) {
                        %>
                        <img src="<%=request.getContextPath()%>/<%=prodImg%>" alt="<%=p.getName()%>" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <% } else { %>
                        <div class="w-full h-full flex items-center justify-center text-on-surface-variant text-sm bg-surface-container-low"><%=p.getName().length() > 10 ? p.getName().substring(0,10)+"..." : p.getName() %></div>
                        <% } %>
                        <% if (p.getTag() != null && !p.getTag().isEmpty()) { %>
                        <div class="absolute top-2 left-2 px-3 py-1 bg-primary text-white text-xs font-bold rounded-full"><%=p.getTag() %></div>
                        <% } %>
                    </div>
                    <h4 class="font-headline-md text-on-surface truncate"><%=p.getName() %></h4>
                    <p class="text-sm text-on-surface-variant mb-base"><%=p.getBrand() %></p>
                    <div class="flex justify-between items-center">
                        <span class="text-xl font-bold text-primary">¥<%=p.getPrice() %></span>
                        <a href="<%=request.getContextPath()%>/cart?action=add&productId=<%=p.getId() %>" class="w-10 h-10 rounded-full bg-surface-container-low flex items-center justify-center text-primary hover:bg-primary hover:text-white transition-colors" style="text-decoration:none;">
                            <span class="material-symbols-outlined">add_shopping_cart</span>
                        </a>
                    </div>
                </div>
                <% count++; } } %>
            </div>
        </div>
    </section>

    <!-- ==================== 关于我们预览 ==================== -->
    <section class="py-xl px-4 md:px-margin-desktop bg-surface-container-low overflow-hidden">
        <div class="max-w-7xl mx-auto">
            <div class="grid grid-cols-1 md:grid-cols-12 gap-md items-stretch">
                <div class="md:col-span-7 space-y-md flex flex-col justify-center">
                    <div class="inline-flex items-center gap-2 text-primary font-bold">
                        <div class="w-8 h-[2px] bg-primary"></div>
                        <span>关于我们</span>
                    </div>
                    <h2 class="font-display-lg text-display-lg">"用专业呵护生命，用爱传递温暖"</h2>
                    <p class="font-body-lg text-body-lg text-on-surface-variant max-w-2xl">
                        萌宠之家始于一个简单的愿望：让每一个宠物都能在繁杂的城市生活中享受到最纯粹的关爱。
                    </p>
                    <div class="grid grid-cols-2 gap-md pt-base">
                        <div class="flex items-start gap-sm">
                            <span class="material-symbols-outlined text-secondary text-3xl">verified</span>
                            <div>
                                <h4 class="font-bold text-lg">专家团队</h4>
                                <p class="text-sm text-on-surface-variant">10年以上经验的专业人士</p>
                            </div>
                        </div>
                        <div class="flex items-start gap-sm">
                            <span class="material-symbols-outlined text-primary text-3xl">favorite</span>
                            <div>
                                <h4 class="font-bold text-lg">人性化关怀</h4>
                                <p class="text-sm text-on-surface-variant">拒绝笼养，科学互动式护理</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="md:col-span-5">
                    <div class="grid grid-cols-2 gap-3 h-80">
                        <div class="rounded-2xl overflow-hidden shadow-lg"><img src="<%=request.getContextPath()%>/static/images/home/5.png" alt="宠物美容" class="w-full h-full object-cover"></div>
                        <div class="rounded-2xl overflow-hidden shadow-lg"><img src="<%=request.getContextPath()%>/static/images/home/6.png" alt="宠物玩水" class="w-full h-full object-cover"></div>
                        <div class="rounded-2xl overflow-hidden shadow-lg"><img src="<%=request.getContextPath()%>/static/images/home/7.png" alt="遛狗时光" class="w-full h-full object-cover"></div>
                        <div class="rounded-2xl overflow-hidden shadow-lg"><img src="<%=request.getContextPath()%>/static/images/home/8.png" alt="温馨陪伴" class="w-full h-full object-cover"></div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ==================== 用户评价 ==================== -->
    <section class="py-xl px-4 md:px-margin-desktop overflow-hidden">
        <div class="max-w-7xl mx-auto">
            <div class="text-center mb-xl">
                <h2 class="font-display-lg text-display-lg mb-sm">看看铲屎官们怎么说</h2>
                <div class="flex justify-center gap-1 text-tertiary">
                    <% for(int i=0;i<5;i++){ %><span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1;">star</span><% } %>
                    <span class="ml-2 text-on-surface-variant font-bold">4.9/5 综合评分</span>
                </div>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-lg">
                <!-- 评价 1 -->
                <div class="bg-white p-xl rounded-3xl shadow-sm border border-surface-container relative">
                    <span class="material-symbols-outlined absolute top-6 right-8 text-primary/10 text-6xl">format_quote</span>
                    <p class="font-body-md text-on-surface-variant mb-xl relative z-10 italic">"带我家糯米来这里剪过几次毛了，美容师特别有耐心，造型非常洋气，强推！"</p>
                    <div class="flex items-center gap-md">
                        <div class="w-14 h-14 rounded-full bg-surface-container overflow-hidden aspect-square shrink-0"><img src="<%=request.getContextPath()%>/static/images/home/9.png" alt="王小姐" class="w-full h-full object-cover rounded-full"></div>
                        <div><h5 class="font-bold">王小姐</h5><p class="text-xs text-on-surface-variant">比熊犬"糯米"的主人</p></div>
                    </div>
                </div>
                <!-- 评价 2 -->
                <div class="bg-white p-xl rounded-3xl shadow-sm border border-surface-container relative">
                    <span class="material-symbols-outlined absolute top-6 right-8 text-secondary/10 text-6xl">format_quote</span>
                    <p class="font-body-md text-on-surface-variant mb-xl relative z-10 italic">"出差把猫咪寄养了一周，每天都能收到视频报告，房间很干净没有异味。"</p>
                    <div class="flex items-center gap-md">
                        <div class="w-14 h-14 rounded-full bg-surface-container overflow-hidden aspect-square shrink-0"><img src="<%=request.getContextPath()%>/static/images/home/10.png" alt="张先生" class="w-full h-full object-cover rounded-full"></div>
                        <div><h5 class="font-bold">张先生</h5><p class="text-xs text-on-surface-variant">英短猫"大福"的主人</p></div>
                    </div>
                </div>
                <!-- 评价 3 -->
                <div class="bg-white p-xl rounded-3xl shadow-sm border border-surface-container relative">
                    <span class="material-symbols-outlined absolute top-6 right-8 text-tertiary/10 text-6xl">format_quote</span>
                    <p class="font-body-md text-on-surface-variant mb-xl relative z-10 italic">"体检非常细致，医生会详细解释每一个指标，没有过度推销药品。"</p>
                    <div class="flex items-center gap-md">
                        <div class="w-14 h-14 rounded-full bg-surface-container overflow-hidden aspect-square shrink-0"><img src="<%=request.getContextPath()%>/static/images/home/11.png" alt="李小姐" class="w-full h-full object-cover rounded-full"></div>
                        <div><h5 class="font-bold">李小姐</h5><p class="text-xs text-on-surface-variant">拉布拉多"卡卡"的主人</p></div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ==================== 订阅 ==================== -->
    <section class="px-4 md:px-margin-desktop mb-xl">
        <div class="max-w-7xl mx-auto bg-primary rounded-[40px] p-xl md:p-20 text-center relative overflow-hidden">
            <div class="relative z-10 space-y-md">
                <h2 class="font-display-lg text-display-lg text-white">加入萌宠俱乐部</h2>
                <p class="text-white/80 max-w-xl mx-auto">订阅我们的邮件，获取最新的宠物护理知识及会员专属折扣信息。</p>
                <form class="flex flex-col sm:flex-row gap-base max-w-md mx-auto pt-base" action="#" method="post">
                    <input class="flex-1 px-6 py-4 rounded-full border-none focus:ring-4 focus:ring-primary-container/30" placeholder="输入您的邮箱地址" type="email" style="outline:none;">
                    <button class="px-xl py-4 bg-white text-primary font-bold rounded-full hover:bg-surface-container-low transition-all active:scale-95" type="submit">立即订阅</button>
                </form>
            </div>
            <div class="absolute -top-10 -right-10 w-64 h-64 bg-white/10 rounded-full blur-3xl"></div>
            <div class="absolute -bottom-10 -left-10 w-48 h-48 bg-black/5 rounded-full blur-2xl"></div>
        </div>
    </section>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
