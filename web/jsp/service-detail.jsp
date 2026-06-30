<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pethome.model.Service, com.pethome.model.Product, com.pethome.dao.ProductDao, java.math.BigDecimal" %>
<%
    request.setAttribute("pageTitle", "服务详情");
    Service service = (Service) request.getAttribute("service");
    List<Service> relatedServices = (List<Service>) request.getAttribute("relatedServices");
    String ctx = request.getContextPath();

    // 分类映射
    String catName = "", catColor = "", catIcon = "";
    if (service != null) {
        switch (service.getCategory()) {
            case "grooming": catName = "专业美容"; catColor = "primary"; catIcon = "content_cut"; break;
            case "boarding": catName = "温馨寄宿"; catColor = "secondary"; catIcon = "home"; break;
            case "clinic":   catName = "医疗健康"; catColor = "tertiary"; catIcon = "medical_services"; break;
        }
    }

    // 推荐商品
    ProductDao productDao = new ProductDao();
    java.util.List<Product> recProducts = productDao.findAll();
    if (recProducts != null && recProducts.size() > 4) recProducts = recProducts.subList(0, 4);
%>
<jsp:include page="/jsp/common/header.jspf" />

<main class="min-h-screen">
    <% if (service == null) { %>
    <div class="max-w-6xl mx-auto px-4 md:px-margin-desktop py-20 text-center">
        <span class="material-symbols-outlined text-8xl text-on-surface-variant/20">search</span>
        <p class="text-on-surface-variant mt-4 text-lg">服务不存在或已下架</p>
        <a href="<%=ctx%>/service" class="inline-block mt-6 bg-primary text-white px-8 py-3 rounded-full font-bold hover:opacity-90 transition-all" style="text-decoration:none;">查看全部服务</a>
    </div>
    <% } else { %>

    <!-- ========== 面包屑 ========== -->
    <div class="max-w-7xl mx-auto px-4 md:px-margin-desktop pt-md">
        <nav class="flex items-center gap-2 text-sm text-on-surface-variant mb-xl">
            <a href="<%=ctx%>/index.jsp" class="hover:text-primary transition-colors" style="text-decoration:none;">首页</a>
            <span class="material-symbols-outlined text-sm">chevron_right</span>
            <a href="<%=ctx%>/service" class="hover:text-primary transition-colors" style="text-decoration:none;">专业服务</a>
            <span class="material-symbols-outlined text-sm">chevron_right</span>
            <a href="<%=ctx%>/service#<%=service.getCategory()%>" class="hover:text-primary transition-colors" style="text-decoration:none;"><%=catName%></a>
            <span class="material-symbols-outlined text-sm">chevron_right</span>
            <span class="text-on-surface font-medium truncate max-w-[200px]"><%=service.getName()%></span>
        </nav>
    </div>

    <!-- ========== 主体内容 ========== -->
    <div class="max-w-7xl mx-auto px-4 md:px-margin-desktop pb-xl">
        <div class="grid grid-cols-1 md:grid-cols-5 gap-xl">
            <!-- ===== 左：图片 ===== -->
            <div class="md:col-span-3">
                <div class="aspect-[4/3] rounded-3xl overflow-hidden bg-surface-container-low shadow-lg border border-outline-variant/20 relative">
                    <%
                        String sImg = service.getImageUrl();
                        if (sImg != null && !sImg.isEmpty() && !sImg.startsWith("http")) {
                    %>
                    <img src="<%=ctx%>/<%=sImg%>" alt="<%=service.getName()%>" class="w-full h-full object-cover">
                    <% } else { %>
                    <div class="w-full h-full flex items-center justify-center">
                        <span class="material-symbols-outlined text-8xl text-primary-fixed-dim"><%=catIcon%></span>
                    </div>
                    <% }
                        boolean isPopular = service.getPrice().compareTo(new BigDecimal("200")) > 0;
                        if (service.getCategory().equals("grooming") && isPopular) {
                    %>
                    <span class="absolute top-4 left-4 px-4 py-1.5 bg-error text-white text-sm font-bold rounded-full shadow-lg">人气推荐</span>
                    <% } else if (service.getCategory().equals("clinic")) { %>
                    <span class="absolute top-4 left-4 px-4 py-1.5 bg-tertiary-container text-on-tertiary-container text-sm font-bold rounded-full shadow-lg">医师坐诊</span>
                    <% } %>
                </div>
            </div>

            <!-- ===== 右：信息 ===== -->
            <div class="md:col-span-2 space-y-lg">
                <!-- 分类标签 -->
                <div>
                    <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-<%=catColor%>-fixed-dim/40 text-<%=catColor%> rounded-full text-sm font-bold">
                        <span class="material-symbols-outlined text-sm"><%=catIcon%></span>
                        <%=catName%>
                    </span>
                </div>

                <h1 class="font-display-lg text-display-lg md:text-[40px] text-on-surface leading-tight"><%=service.getName()%></h1>

                <!-- 价格区 -->
                <div class="bg-surface-container-low rounded-2xl p-lg">
                    <div class="flex items-baseline gap-2">
                        <span class="font-display-lg text-4xl md:text-5xl text-primary font-bold">¥<%=service.getPrice()%></span>
                        <% if (service.getCategory().equals("boarding")) { %>
                        <span class="text-on-surface-variant">/天起</span>
                        <% } else { %>
                        <span class="text-on-surface-variant">起</span>
                        <% } %>
                    </div>
                </div>

                <!-- 描述 -->
                <div>
                    <h3 class="font-headline-md text-headline-md mb-sm">服务介绍</h3>
                    <p class="text-on-surface-variant font-body-md leading-relaxed"><%=service.getDescription()%></p>
                </div>

                <!-- 服务特色 -->
                <div class="bg-surface-container-lowest rounded-2xl border border-outline-variant/20 p-lg">
                    <h3 class="font-headline-md text-headline-md mb-md">服务特色</h3>
                    <div class="space-y-3">
                        <div class="flex items-start gap-3">
                            <span class="material-symbols-outlined text-primary text-sm mt-0.5" style="font-variation-settings:'FILL'1;">check_circle</span>
                            <span class="text-sm text-on-surface-variant">专业团队，持证上岗</span>
                        </div>
                        <div class="flex items-start gap-3">
                            <span class="material-symbols-outlined text-secondary text-sm mt-0.5" style="font-variation-settings:'FILL'1;">check_circle</span>
                            <span class="text-sm text-on-surface-variant">进口设备，安全舒适</span>
                        </div>
                        <div class="flex items-start gap-3">
                            <span class="material-symbols-outlined text-tertiary text-sm mt-0.5" style="font-variation-settings:'FILL'1;">check_circle</span>
                            <span class="text-sm text-on-surface-variant">不满意可申请重做或退款</span>
                        </div>
                        <% if (service.getCategory().equals("boarding")) { %>
                        <div class="flex items-start gap-3">
                            <span class="material-symbols-outlined text-primary text-sm mt-0.5" style="font-variation-settings:'FILL'1;">check_circle</span>
                            <span class="text-sm text-on-surface-variant">24小时监控 + 每日视频报告</span>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- 按钮区 -->
                <div class="space-y-3 pt-sm">
                    <button onclick="openBooking('<%=service.getName()%>', '<%=service.getPrice()%>')"
                            class="w-full bg-primary text-white py-4 rounded-full font-bold text-lg hover:opacity-90 transition-all active:scale-95 shadow-lg shadow-primary/30">
                        <span class="material-symbols-outlined align-middle text-sm">calendar_month</span> 立即预约
                    </button>
                    <a href="<%=ctx%>/service" class="block w-full text-center py-3 rounded-full border border-outline-variant font-bold text-on-surface-variant hover:bg-surface-container-low transition-all active:scale-95" style="text-decoration:none;">
                        <span class="material-symbols-outlined align-middle text-sm">arrow_back</span> 返回服务列表
                    </a>
                </div>
            </div>
        </div>

        <!-- ========== 同类推荐 ========== -->
        <% if (relatedServices != null && !relatedServices.isEmpty()) { %>
        <section class="mt-xl pt-xl border-t border-outline-variant/20">
            <div class="flex justify-between items-end mb-lg">
                <div>
                    <h2 class="font-display-lg text-display-lg text-on-surface">更多<%=catName%>服务</h2>
                    <p class="text-on-surface-variant">总有一款适合您的爱宠</p>
                </div>
                <a href="<%=ctx%>/service#<%=service.getCategory()%>" class="hidden md:flex items-center text-primary font-bold hover:underline underline-offset-4" style="text-decoration:none;">
                    查看全部 <span class="material-symbols-outlined ml-1">chevron_right</span>
                </a>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-md">
                <% for (Service rs : relatedServices) { %>
                <a href="<%=ctx%>/service?action=detail&id=<%=rs.getId()%>" class="group bg-surface-container-lowest rounded-2xl overflow-hidden border border-outline-variant/20 hover:shadow-xl hover:border-primary-fixed-dim transition-all" style="text-decoration:none;">
                    <div class="h-40 overflow-hidden bg-surface-container-low">
                        <% String rImg = rs.getImageUrl(); if (rImg != null && !rImg.isEmpty() && !rImg.startsWith("http")) { %>
                        <img src="<%=ctx%>/<%=rImg%>" alt="<%=rs.getName()%>" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <% } else { %>
                        <div class="w-full h-full flex items-center justify-center"><span class="material-symbols-outlined text-5xl text-primary-fixed-dim"><%=catIcon%></span></div>
                        <% } %>
                    </div>
                    <div class="p-4">
                        <h4 class="font-bold"><%=rs.getName()%></h4>
                        <div class="flex items-center justify-between mt-2">
                            <span class="text-primary font-bold text-lg">¥<%=rs.getPrice()%></span>
                            <span class="text-xs text-on-surface-variant">了解详情 →</span>
                        </div>
                    </div>
                </a>
                <% } %>
            </div>
        </section>
        <% } %>

        <!-- ========== 推荐商品 ========== -->
        <section class="mt-xl pt-xl border-t border-outline-variant/20">
            <div class="flex justify-between items-end mb-lg">
                <div>
                    <h2 class="font-display-lg text-display-lg text-on-surface">搭配好物推荐</h2>
                    <p class="text-on-surface-variant">与服务搭配使用，效果更佳</p>
                </div>
                <a href="<%=ctx%>/product" class="hidden md:flex items-center text-primary font-bold hover:underline underline-offset-4" style="text-decoration:none;">
                    去商城逛逛 <span class="material-symbols-outlined ml-1">chevron_right</span>
                </a>
            </div>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-md">
                <% if (recProducts != null) { for (Product rp : recProducts) { %>
                <a href="<%=ctx%>/product?action=detail&id=<%=rp.getId()%>" class="group bg-surface-container-lowest rounded-xl overflow-hidden border border-outline-variant/20 hover:shadow-xl transition-all" style="text-decoration:none;">
                    <div class="aspect-square overflow-hidden bg-surface-container-low">
                        <% String rpImg = rp.getImageUrl(); if (rpImg != null && !rpImg.isEmpty() && !rpImg.startsWith("http")) { %>
                        <img src="<%=ctx%>/<%=rpImg%>" alt="<%=rp.getName()%>" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <% } else { %>
                        <div class="w-full h-full flex items-center justify-center"><span class="material-symbols-outlined text-5xl text-on-surface-variant/30">pets</span></div>
                        <% } %>
                    </div>
                    <div class="p-3">
                        <p class="text-xs text-outline truncate"><%=rp.getBrand() != null ? rp.getBrand() : ""%></p>
                        <h4 class="font-bold text-sm truncate mt-0.5"><%=rp.getName()%></h4>
                        <span class="text-primary font-bold text-sm">¥<%=rp.getPrice()%></span>
                    </div>
                </a>
                <% } } %>
            </div>
        </section>
    </div>

    <!-- ========== 预约弹窗 ========== -->
    <div id="bookingModal" class="fixed inset-0 z-[100] flex items-center justify-center bg-black/40 backdrop-blur-sm hidden" onclick="closeBooking(event)">
        <div class="bg-surface-container-lowest rounded-3xl p-xl max-w-md w-full mx-4 shadow-2xl border border-outline-variant/20" onclick="event.stopPropagation()">
            <div class="flex justify-between items-center mb-lg">
                <h3 class="font-headline-md text-headline-md">预约服务</h3>
                <button onclick="closeBooking()" class="w-10 h-10 rounded-full hover:bg-surface-container-low flex items-center justify-center transition-colors">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>
            <form id="bookingForm" onsubmit="submitBooking(event)" class="space-y-md">
                <div>
                    <label class="font-label-sm text-label-sm text-on-surface-variant mb-xs block">服务项目</label>
                    <input id="bookService" readonly class="w-full px-4 py-3 rounded-xl bg-surface-container-low border border-outline-variant font-medium" style="outline:none;">
                </div>
                <div>
                    <label class="font-label-sm text-label-sm text-on-surface-variant mb-xs block">预估费用</label>
                    <input id="bookPrice" readonly class="w-full px-4 py-3 rounded-xl bg-surface-container-low border border-outline-variant text-primary font-bold text-lg" style="outline:none;">
                </div>
                <div>
                    <label class="font-label-sm text-label-sm text-on-surface-variant mb-xs block">您的姓名 <span class="text-error">*</span></label>
                    <input required class="w-full px-4 py-3 rounded-xl border border-outline-variant bg-surface-container-lowest focus:border-primary transition-colors" placeholder="请输入姓名" style="outline:none;">
                </div>
                <div>
                    <label class="font-label-sm text-label-sm text-on-surface-variant mb-xs block">联系方式 <span class="text-error">*</span></label>
                    <input required type="tel" class="w-full px-4 py-3 rounded-xl border border-outline-variant bg-surface-container-lowest focus:border-primary transition-colors" placeholder="手机号" style="outline:none;">
                </div>
                <div>
                    <label class="font-label-sm text-label-sm text-on-surface-variant mb-xs block">预约日期 <span class="text-error">*</span></label>
                    <input required type="date" class="w-full px-4 py-3 rounded-xl border border-outline-variant bg-surface-container-lowest focus:border-primary transition-colors" style="outline:none;">
                </div>
                <div>
                    <label class="font-label-sm text-label-sm text-on-surface-variant mb-xs block">备注</label>
                    <textarea rows="2" class="w-full px-4 py-3 rounded-xl border border-outline-variant bg-surface-container-lowest focus:border-primary transition-colors" placeholder="宠物品种、特殊需求等" style="outline:none;"></textarea>
                </div>
                <button type="submit" class="w-full bg-primary text-white py-4 rounded-full font-bold text-lg hover:opacity-90 transition-all active:scale-95 shadow-lg shadow-primary/30">
                    提交预约
                </button>
            </form>
        </div>
    </div>

    <% } %>
</main>

<script>
function openBooking(name, price) {
    document.getElementById('bookService').value = name;
    document.getElementById('bookPrice').value = '¥' + price;
    document.getElementById('bookingModal').classList.remove('hidden');
    document.body.style.overflow = 'hidden';
}
function closeBooking(e) {
    if (e && e.target !== e.currentTarget) return;
    document.getElementById('bookingModal').classList.add('hidden');
    document.body.style.overflow = '';
}
function submitBooking(e) {
    e.preventDefault();
    const name = document.getElementById('bookService').value;
    alert('感谢您的预约！\n服务项目：' + name + '\n\n我们的客服将在30分钟内与您联系确认。');
    closeBooking();
}
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeBooking();
});
</script>

<jsp:include page="/jsp/common/footer.jspf" />