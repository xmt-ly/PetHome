<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pethome.model.Service" %>
<% request.setAttribute("pageTitle", "专业服务"); %>
<jsp:include page="/jsp/common/header.jspf" />

<%
    List<Service> groomingServices = (List<Service>) request.getAttribute("groomingServices");
    List<Service> boardingServices = (List<Service>) request.getAttribute("boardingServices");
    List<Service> clinicServices = (List<Service>) request.getAttribute("clinicServices");
    String ctx = request.getContextPath();
%>

<main>
    <!-- ==================== Hero Banner ==================== -->
    <section class="relative overflow-hidden bg-gradient-to-br from-primary/5 via-surface to-secondary/5 pt-xl pb-xl px-4 md:px-margin-desktop">
        <div class="max-w-7xl mx-auto text-center">
            <div class="inline-flex items-center gap-2 px-4 py-1.5 bg-primary/10 text-primary rounded-full text-sm font-bold mb-md">
                <span class="material-symbols-outlined text-sm">pets</span>
                用心呵护每一个小生命
            </div>
            <h1 class="font-display-lg text-display-lg md:text-[56px] text-on-surface mb-md leading-tight">
                专业宠物服务<span class="text-primary">，<br class="md:hidden">一站式呵护</span>
            </h1>
            <p class="font-body-lg text-body-lg text-on-surface-variant max-w-2xl mx-auto mb-lg">
                从专业美容到健康医疗，我们用"温暖的专业主义"<br class="hidden md:block">
                为您的爱宠提供全方位的呵护
            </p>
            <div class="flex flex-wrap justify-center gap-base">
                <a href="#grooming" class="bg-primary text-white px-xl py-3 rounded-full font-bold hover:opacity-90 transition-all active:scale-95 shadow-lg shadow-primary/30" style="text-decoration:none;">
                    <span class="material-symbols-outlined align-middle text-sm">content_cut</span> 美容护理
                </a>
                <a href="#boarding" class="bg-secondary text-white px-xl py-3 rounded-full font-bold hover:opacity-90 transition-all active:scale-95 shadow-lg shadow-secondary/30" style="text-decoration:none;">
                    <span class="material-symbols-outlined align-middle text-sm">home</span> 温馨寄宿
                </a>
                <a href="#clinic" class="bg-tertiary-container text-on-tertiary-container px-xl py-3 rounded-full font-bold hover:opacity-90 transition-all active:scale-95" style="text-decoration:none;">
                    <span class="material-symbols-outlined align-middle text-sm">medical_services</span> 医疗健康
                </a>
            </div>
        </div>
        <!-- 装饰 -->
        <div class="absolute top-10 left-10 w-32 h-32 bg-primary/5 rounded-full blur-3xl"></div>
        <div class="absolute bottom-10 right-10 w-48 h-48 bg-secondary/5 rounded-full blur-3xl"></div>
    </section>

    <!-- ==================== 为什么选择我们 ==================== -->
    <section class="py-xl px-4 md:px-margin-desktop bg-surface-container-low">
        <div class="max-w-7xl mx-auto">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-md">
                <div class="text-center p-lg bg-surface-container-lowest rounded-2xl border border-outline-variant/20">
                    <span class="material-symbols-outlined text-4xl text-primary" style="font-variation-settings:'FILL'1;">verified</span>
                    <p class="font-headline-md text-headline-md mt-sm">15+</p>
                    <p class="text-sm text-on-surface-variant">专业服务项目</p>
                </div>
                <div class="text-center p-lg bg-surface-container-lowest rounded-2xl border border-outline-variant/20">
                    <span class="material-symbols-outlined text-4xl text-secondary" style="font-variation-settings:'FILL'1;">groups</span>
                    <p class="font-headline-md text-headline-md mt-sm">5000+</p>
                    <p class="text-sm text-on-surface-variant">信赖宠主</p>
                </div>
                <div class="text-center p-lg bg-surface-container-lowest rounded-2xl border border-outline-variant/20">
                    <span class="material-symbols-outlined text-4xl text-tertiary" style="font-variation-settings:'FILL'1;">star</span>
                    <p class="font-headline-md text-headline-md mt-sm">4.9</p>
                    <p class="text-sm text-on-surface-variant">综合评分</p>
                </div>
                <div class="text-center p-lg bg-surface-container-lowest rounded-2xl border border-outline-variant/20">
                    <span class="material-symbols-outlined text-4xl text-primary" style="font-variation-settings:'FILL'1;">check_circle</span>
                    <p class="font-headline-md text-headline-md mt-sm">100%</p>
                    <p class="text-sm text-on-surface-variant">正品保障</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ==================== 美容服务 ==================== -->
    <section class="py-xl px-4 md:px-margin-desktop scroll-mt-24" id="grooming">
        <div class="max-w-7xl mx-auto">
            <div class="flex items-center gap-4 mb-lg">
                <div class="w-12 h-12 rounded-2xl bg-primary-fixed-dim/40 flex items-center justify-center">
                    <span class="material-symbols-outlined text-primary text-3xl" style="font-variation-settings:'FILL'1;">content_cut</span>
                </div>
                <div>
                    <h2 class="font-display-lg text-display-lg text-on-surface">专业美容</h2>
                    <p class="text-on-surface-variant">Grooming — 让爱宠颜值在线</p>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-md">
                <% if (groomingServices != null) {
                    for (Service s : groomingServices) {
                        boolean isPopular = s.getPrice().compareTo(new java.math.BigDecimal("200")) > 0;
                %>
                <div class="group bg-surface-container-lowest rounded-2xl overflow-hidden border border-outline-variant/20 hover:shadow-xl hover:border-primary-fixed-dim transition-all duration-300 flex flex-col">
                    <div class="relative h-48 overflow-hidden bg-surface-container-low">
                        <%
                            String sImg = s.getImageUrl();
                            if (sImg != null && !sImg.isEmpty() && !sImg.startsWith("http")) {
                        %>
                        <img src="<%=ctx%>/<%=sImg%>" alt="<%=s.getName()%>" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <% } else { %>
                        <div class="w-full h-full flex items-center justify-center"><span class="material-symbols-outlined text-6xl text-primary-fixed-dim">content_cut</span></div>
                        <% } %>
                        <div class="absolute inset-x-0 bottom-0 bg-gradient-to-t from-black/40 to-transparent h-20"></div>
                        <div class="absolute bottom-3 left-4 flex items-center gap-2">
                            <% if (isPopular) { %>
                            <span class="px-2.5 py-0.5 bg-error text-white text-xs font-bold rounded-full">人气推荐</span>
                            <% } %>
                        </div>
                    </div>
                    <div class="p-lg flex flex-col flex-grow">
                        <h3 class="font-headline-md text-headline-md mb-xs"><%= s.getName() %></h3>
                        <p class="text-sm text-on-surface-variant mb-md flex-grow leading-relaxed"><%= s.getDescription() %></p>
                        <div class="flex items-center justify-between pt-sm border-t border-outline-variant/20">
                            <div>
                                <span class="text-primary font-bold text-2xl">¥<%= s.getPrice() %></span>
                                <span class="text-xs text-on-surface-variant ml-1">起</span>
                            </div>
                            <a href="<%=ctx%>/service?action=detail&id=<%=s.getId()%>"
                               class="inline-flex items-center px-md py-2.5 bg-primary text-white rounded-full text-sm font-bold hover:opacity-90 transition-all active:scale-95 shadow-md shadow-primary/20"
                               style="text-decoration:none;">
                                了解详情 <span class="material-symbols-outlined text-sm ml-0.5">arrow_forward</span>
                            </a>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <div class="col-span-full text-center py-xl text-on-surface-variant">正在加载服务数据...</div>
                <% } %>
            </div>
        </div>
    </section>

    <!-- ==================== 寄宿服务 ==================== -->
    <section class="py-xl px-4 md:px-margin-desktop bg-surface-container-low scroll-mt-24" id="boarding">
        <div class="max-w-7xl mx-auto">
            <div class="flex items-center gap-4 mb-lg">
                <div class="w-12 h-12 rounded-2xl bg-secondary-fixed/40 flex items-center justify-center">
                    <span class="material-symbols-outlined text-secondary text-3xl" style="font-variation-settings:'FILL'1;">home</span>
                </div>
                <div>
                    <h2 class="font-display-lg text-display-lg text-on-surface">温馨寄宿</h2>
                    <p class="text-on-surface-variant">Boarding — 给宝贝一个临时的家</p>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-md">
                <% if (boardingServices != null) {
                    for (Service s : boardingServices) { %>
                <div class="group bg-surface-container-lowest rounded-2xl overflow-hidden border border-outline-variant/20 hover:shadow-xl hover:border-secondary-fixed-dim transition-all duration-300 flex flex-col">
                    <div class="relative h-48 overflow-hidden bg-surface-container-low">
                        <%
                            String bImg = s.getImageUrl();
                            if (bImg != null && !bImg.isEmpty() && !bImg.startsWith("http")) {
                        %>
                        <img src="<%=ctx%>/<%=bImg%>" alt="<%=s.getName()%>" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <% } else { %>
                        <div class="w-full h-full flex items-center justify-center"><span class="material-symbols-outlined text-6xl text-secondary-fixed-dim">home</span></div>
                        <% } %>
                        <div class="absolute inset-x-0 bottom-0 bg-gradient-to-t from-black/40 to-transparent h-20"></div>
                    </div>
                    <div class="p-lg flex flex-col flex-grow">
                        <h3 class="font-headline-md text-headline-md mb-xs"><%= s.getName() %></h3>
                        <p class="text-sm text-on-surface-variant mb-md flex-grow leading-relaxed"><%= s.getDescription() %></p>
                        <div class="flex items-center justify-between pt-sm border-t border-outline-variant/20">
                            <div>
                                <span class="text-primary font-bold text-2xl">¥<%= s.getPrice() %></span>
                                <span class="text-xs text-on-surface-variant ml-1">/天 起</span>
                            </div>
                            <a href="<%=ctx%>/service?action=detail&id=<%=s.getId()%>"
                               class="inline-flex items-center px-md py-2.5 bg-secondary text-white rounded-full text-sm font-bold hover:opacity-90 transition-all active:scale-95 shadow-md shadow-secondary/20"
                               style="text-decoration:none;">
                                了解详情 <span class="material-symbols-outlined text-sm ml-0.5">arrow_forward</span>
                            </a>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <div class="col-span-full text-center py-xl text-on-surface-variant">正在加载服务数据...</div>
                <% } %>
            </div>
        </div>
    </section>

    <!-- ==================== 医疗服务 ==================== -->
    <section class="py-xl px-4 md:px-margin-desktop scroll-mt-24" id="clinic">
        <div class="max-w-7xl mx-auto">
            <div class="flex items-center gap-4 mb-lg">
                <div class="w-12 h-12 rounded-2xl bg-tertiary-fixed/40 flex items-center justify-center">
                    <span class="material-symbols-outlined text-tertiary text-3xl" style="font-variation-settings:'FILL'1;">medical_services</span>
                </div>
                <div>
                    <h2 class="font-display-lg text-display-lg text-on-surface">医疗健康</h2>
                    <p class="text-on-surface-variant">Clinic — 专业兽医守护健康</p>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-md">
                <% if (clinicServices != null) {
                    for (Service s : clinicServices) { %>
                <div class="group bg-surface-container-lowest rounded-2xl overflow-hidden border border-outline-variant/20 hover:shadow-xl hover:border-tertiary-fixed-dim transition-all duration-300 flex flex-col">
                    <div class="relative h-48 overflow-hidden bg-surface-container-low">
                        <%
                            String cImg = s.getImageUrl();
                            if (cImg != null && !cImg.isEmpty() && !cImg.startsWith("http")) {
                        %>
                        <img src="<%=ctx%>/<%=cImg%>" alt="<%=s.getName()%>" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <% } else { %>
                        <div class="w-full h-full flex items-center justify-center"><span class="material-symbols-outlined text-6xl text-tertiary-fixed-dim">medical_services</span></div>
                        <% } %>
                        <div class="absolute inset-x-0 bottom-0 bg-gradient-to-t from-black/40 to-transparent h-20"></div>
                        <div class="absolute top-3 right-3">
                            <span class="px-2.5 py-0.5 bg-tertiary-container text-on-tertiary-container text-xs font-bold rounded-full">医师坐诊</span>
                        </div>
                    </div>
                    <div class="p-lg flex flex-col flex-grow">
                        <h3 class="font-headline-md text-headline-md mb-xs"><%= s.getName() %></h3>
                        <p class="text-sm text-on-surface-variant mb-md flex-grow leading-relaxed"><%= s.getDescription() %></p>
                        <div class="flex items-center justify-between pt-sm border-t border-outline-variant/20">
                            <div>
                                <span class="text-primary font-bold text-2xl">¥<%= s.getPrice() %></span>
                                <span class="text-xs text-on-surface-variant ml-1">起</span>
                            </div>
                            <a href="<%=ctx%>/service?action=detail&id=<%=s.getId()%>"
                               class="inline-flex items-center px-md py-2.5 bg-tertiary-container text-on-tertiary-container rounded-full text-sm font-bold hover:opacity-90 transition-all active:scale-95"
                               style="text-decoration:none;">
                                了解详情 <span class="material-symbols-outlined text-sm ml-0.5">arrow_forward</span>
                            </a>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <div class="col-span-full text-center py-xl text-on-surface-variant">正在加载服务数据...</div>
                <% } %>
            </div>
        </div>
    </section>

    <!-- ==================== 价目表 ==================== -->
    <section class="px-4 md:px-margin-desktop pb-xl">
        <div class="max-w-7xl mx-auto bg-surface-container-low rounded-3xl p-lg md:p-xl">
            <div class="text-center mb-lg">
                <h2 class="font-display-lg text-display-lg mb-xs">透明价目表</h2>
                <p class="text-on-surface-variant">公开透明，按体型合理计费</p>
            </div>
            <div class="overflow-x-auto rounded-xl border border-outline-variant/20">
                <table>
                    <thead>
                        <tr>
                            <th>服务项目</th>
                            <th class="text-primary">小型 ≤10kg</th>
                            <th class="text-secondary">中型 10-25kg</th>
                            <th class="text-tertiary">大型 ≥25kg</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr><td>基础洗护</td><td>¥88</td><td>¥128</td><td>¥188</td></tr>
                        <tr><td>全套造型</td><td>¥158</td><td>¥228</td><td>¥358</td></tr>
                        <tr><td>SPA护理</td><td>¥258</td><td>¥308</td><td>¥408</td></tr>
                        <tr><td>标准寄宿 <span class="text-xs text-on-surface-variant">/天</span></td><td>¥60</td><td>¥90</td><td>¥120</td></tr>
                        <tr><td>VIP寄宿 <span class="text-xs text-on-surface-variant">/天</span></td><td>¥90</td><td>¥120</td><td>¥150</td></tr>
                        <tr><td>常规体检</td><td colspan="3" class="text-center">¥299 起（统一计费）</td></tr>
                        <tr><td>疫苗接种</td><td colspan="3" class="text-center">¥199 起（统一计费）</td></tr>
                    </tbody>
                </table>
            </div>
            <p class="text-sm text-on-surface-variant text-center mt-md">* 特殊品种或难度护理可能产生额外费用，请咨询门店</p>
        </div>
    </section>

    <!-- ==================== 常见问题 FAQ ==================== -->
    <section class="px-4 md:px-margin-desktop pb-xl">
        <div class="max-w-3xl mx-auto">
            <div class="text-center mb-lg">
                <h2 class="font-display-lg text-display-lg mb-xs">常见问题</h2>
                <p class="text-on-surface-variant">FAQ — 您关心的问题，这里都有答案</p>
            </div>
            <div class="space-y-base">
                <details class="group bg-surface-container-lowest rounded-xl border border-outline-variant overflow-hidden cursor-pointer" open>
                    <summary class="flex items-center justify-between p-lg list-none font-headline-md text-body-lg hover:bg-surface-container-low transition-colors">
                        <span class="flex items-center gap-3">
                            <span class="material-symbols-outlined text-primary">description</span>
                            寄宿需要提供什么证明？
                        </span>
                        <span class="material-symbols-outlined group-open:rotate-180 transition-transform text-on-surface-variant">expand_more</span>
                    </summary>
                    <div class="px-lg pb-lg text-on-surface-variant font-body-md leading-relaxed">
                        需要出示有效期内的疫苗接种证明（三联/五联及狂犬疫苗），以及近期体内外驱虫记录。首次入住建议携带宠物熟悉的玩具或毯子帮助适应。
                    </div>
                </details>
                <details class="group bg-surface-container-lowest rounded-xl border border-outline-variant overflow-hidden cursor-pointer">
                    <summary class="flex items-center justify-between p-lg list-none font-headline-md text-body-lg hover:bg-surface-container-low transition-colors">
                        <span class="flex items-center gap-3">
                            <span class="material-symbols-outlined text-secondary">calendar_month</span>
                            洗护美容需要提前多久预约？
                        </span>
                        <span class="material-symbols-outlined group-open:rotate-180 transition-transform text-on-surface-variant">expand_more</span>
                    </summary>
                    <div class="px-lg pb-lg text-on-surface-variant font-body-md leading-relaxed">
                        建议提前1-2天预约，周末及节假日建议提前3-5天。全套造型和SPA护理耗时较长，建议上午到店。
                    </div>
                </details>
                <details class="group bg-surface-container-lowest rounded-xl border border-outline-variant overflow-hidden cursor-pointer">
                    <summary class="flex items-center justify-between p-lg list-none font-headline-md text-body-lg hover:bg-surface-container-low transition-colors">
                        <span class="flex items-center gap-3">
                            <span class="material-symbols-outlined text-tertiary">videocam</span>
                            寄宿期间可以查看宠物状态吗？
                        </span>
                        <span class="material-symbols-outlined group-open:rotate-180 transition-transform text-on-surface-variant">expand_more</span>
                    </summary>
                    <div class="px-lg pb-lg text-on-surface-variant font-body-md leading-relaxed">
                        所有寄宿房间均配备高清摄像头，可通过萌宠之家APP 24小时在线查看。看护师每日发送图文/视频报告，紧急情况会第一时间电话联系。
                    </div>
                </details>
                <details class="group bg-surface-container-lowest rounded-xl border border-outline-variant overflow-hidden cursor-pointer">
                    <summary class="flex items-center justify-between p-lg list-none font-headline-md text-body-lg hover:bg-surface-container-low transition-colors">
                        <span class="flex items-center gap-3">
                            <span class="material-symbols-outlined text-primary">payments</span>
                            医疗套餐可以医保报销吗？
                        </span>
                        <span class="material-symbols-outlined group-open:rotate-180 transition-transform text-on-surface-variant">expand_more</span>
                    </summary>
                    <div class="px-lg pb-lg text-on-surface-variant font-body-md leading-relaxed">
                        目前宠物医疗尚未纳入医保体系，但我们与多家宠物保险合作，持指定保险到店就诊可享受直赔服务。详情请咨询前台。
                    </div>
                </details>
            </div>
        </div>
    </section>

</main>

<jsp:include page="/jsp/common/footer.jspf" />
