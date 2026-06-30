<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("pageTitle", "关于我们"); %>
<jsp:include page="/jsp/common/header.jspf" />

<main class="bg-warm-gradient overflow-x-hidden">
    <!-- Hero 品牌故事 -->
    <section class="px-4 md:px-margin-desktop py-xl max-w-7xl mx-auto flex flex-col md:flex-row items-center gap-xl">
        <div class="flex-1 space-y-md">
            <span class="px-4 py-1.5 rounded-full bg-secondary-container text-on-secondary-container font-label-sm text-label-sm uppercase tracking-wider">品牌起源</span>
            <h1 class="font-display-lg text-display-lg text-on-surface leading-tight">因为爱，所以专业。<br><span class="text-primary">为每一个毛孩子打造温馨港湾。</span></h1>
            <p class="text-on-surface-variant font-body-lg text-body-lg leading-relaxed">
                "萌宠之家"始于2015年一个简单的愿望：让每一只宠物都能享受到家庭般的温暖与医疗级的呵护。
                八年来，我们服务了超过5万名宠物主，用爱心与技术赢得了社区的信任。
            </p>
            <div class="flex gap-md pt-sm">
                <div class="text-center"><div class="text-3xl font-bold text-secondary">50k+</div><div class="font-label-sm text-label-sm text-on-surface-variant">幸福宠物</div></div>
                <div class="w-px h-12 bg-outline-variant"></div>
                <div class="text-center"><div class="text-3xl font-bold text-secondary">15+</div><div class="font-label-sm text-label-sm text-on-surface-variant">资深兽医</div></div>
                <div class="w-px h-12 bg-outline-variant"></div>
                <div class="text-center"><div class="text-3xl font-bold text-secondary">24h</div><div class="font-label-sm text-label-sm text-on-surface-variant">贴心守护</div></div>
            </div>
        </div>
        <div class="flex-1 relative">
            <div class="w-full aspect-square rounded-3xl overflow-hidden shadow-xl bg-surface-container-low">
                <img src="<%=request.getContextPath()%>/static/images/about/1.png" alt="萌宠之家门店" class="w-full h-full object-cover">
            </div>
            <div class="absolute -bottom-6 -left-6 bg-surface p-6 rounded-2xl shadow-lg flex items-center gap-base border border-surface-container">
                <div class="w-12 h-12 rounded-full bg-primary-container flex items-center justify-center">
                    <span class="material-symbols-outlined text-white" style="font-variation-settings:'FILL'1;">favorite</span>
                </div>
                <div><div class="font-bold">100% 正品保障</div><div class="text-sm text-on-surface-variant">全球严选优质口粮</div></div>
            </div>
        </div>
    </section>

    <!-- 线下空间 -->
    <section class="px-4 md:px-margin-desktop py-xl bg-surface-container-low">
        <div class="max-w-7xl mx-auto space-y-lg">
            <div class="text-center space-y-xs">
                <h2 class="font-headline-md text-headline-md">线下空间体验</h2>
                <p class="text-on-surface-variant">极简温馨的北欧风设计，为您的爱宠提供无压力的环境</p>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-4 gap-base md:h-[600px]">
                <div class="md:col-span-2 md:row-span-2 rounded-3xl overflow-hidden bg-surface-container-high"><img src="<%=request.getContextPath()%>/static/images/about/3.png" alt="门店前台" class="w-full h-full object-cover"></div>
                <div class="rounded-3xl overflow-hidden bg-surface-container"><img src="<%=request.getContextPath()%>/static/images/about/5.png" alt="美容区" class="w-full h-full object-cover"></div>
                <div class="rounded-3xl overflow-hidden bg-surface-container"><img src="<%=request.getContextPath()%>/static/images/about/4.png" alt="商品区" class="w-full h-full object-cover"></div>
                <div class="md:col-span-2 rounded-3xl overflow-hidden bg-surface-container-high"><img src="<%=request.getContextPath()%>/static/images/about/2.png" alt="休息区" class="w-full h-full object-cover"></div>
            </div>
        </div>
    </section>

    <!-- 专业团队 -->
    <section class="px-4 md:px-margin-desktop py-xl max-w-7xl mx-auto space-y-xl">
        <div class="flex justify-between items-end">
            <div class="max-w-2xl space-y-xs">
                <h2 class="font-headline-md text-headline-md">专业守护团队</h2>
                <p class="text-on-surface-variant">汇聚行业资深专家，每一位成员都持有国家执业资质。</p>
            </div>
            <button class="bg-secondary text-white px-8 py-3 rounded-full font-medium hover:opacity-90 transition-all flex items-center gap-xs" onclick="alert('更多专家信息即将上线')">
                了解更多专家 <span class="material-symbols-outlined">arrow_forward</span>
            </button>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-lg">
            <div class="group">
                <div class="aspect-[4/5] rounded-3xl overflow-hidden mb-base bg-surface-container-low"><img src="<%=request.getContextPath()%>/static/images/about/8.png" alt="林思远医生" class="w-full h-full object-cover"></div>
                <h3 class="font-headline-md text-headline-md">林思远 医生</h3>
                <p class="text-primary font-medium mb-xs">首席兽医专家 / 12年经验</p>
                <p class="text-on-surface-variant text-body-md">擅长猫内科与骨伤康复，对每一个小生命都有着非同寻常的耐心。</p>
            </div>
            <div class="group">
                <div class="aspect-[4/5] rounded-3xl overflow-hidden mb-base bg-surface-container-low"><img src="<%=request.getContextPath()%>/static/images/about/7.png" alt="张宇轩" class="w-full h-full object-cover"></div>
                <h3 class="font-headline-md text-headline-md">张宇轩</h3>
                <p class="text-primary font-medium mb-xs">高级宠物美容师 / 8年经验</p>
                <p class="text-on-surface-variant text-body-md">WGA全场总冠军，专注于创意剪毛与皮毛护理方案。</p>
            </div>
            <div class="group">
                <div class="aspect-[4/5] rounded-3xl overflow-hidden mb-base bg-surface-container-low"><img src="<%=request.getContextPath()%>/static/images/about/6.png" alt="陈浩然医生" class="w-full h-full object-cover"></div>
                <h3 class="font-headline-md text-headline-md">陈浩然 医生</h3>
                <p class="text-primary font-medium mb-xs">宠物行为分析师 / 6年经验</p>
                <p class="text-on-surface-variant text-body-md">致力于解决宠物焦虑及社交障碍问题。</p>
            </div>
        </div>
    </section>

    <!-- 联系表单 -->
    <section class="px-4 md:px-margin-desktop py-xl bg-surface-container-high">
        <div class="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-2 gap-xl">
            <div class="space-y-lg">
                <div class="space-y-xs">
                    <h2 class="font-headline-md text-headline-md">联系我们</h2>
                    <p class="text-on-surface-variant">期待您的光临，也欢迎通过以下方式预约服务</p>
                </div>
                <div class="space-y-md">
                    <div class="flex gap-base"><div class="w-12 h-12 rounded-xl bg-primary-fixed-dim flex items-center justify-center"><span class="material-symbols-outlined text-primary">location_on</span></div><div><div class="font-bold">门店地址</div><div class="text-on-surface-variant">上海市徐汇区宠物大道88号</div></div></div>
                    <div class="flex gap-base"><div class="w-12 h-12 rounded-xl bg-secondary-fixed flex items-center justify-center"><span class="material-symbols-outlined text-secondary">call</span></div><div><div class="font-bold">联系电话</div><div class="text-on-surface-variant">400-888-PETS (7387)</div></div></div>
                    <div class="flex gap-base"><div class="w-12 h-12 rounded-xl bg-tertiary-fixed flex items-center justify-center"><span class="material-symbols-outlined text-tertiary">schedule</span></div><div><div class="font-bold">营业时间</div><div class="text-on-surface-variant">周一至周日 09:00 - 21:00</div></div></div>
                </div>
            </div>
            <div class="bg-surface rounded-[32px] p-xl shadow-lg border border-surface-container-high">
                <h3 class="font-headline-md text-headline-md mb-md">在线咨询</h3>
                <form class="space-y-md" onsubmit="event.preventDefault(); alert('消息已发送，我们将尽快联系您！')">
                    <div class="grid grid-cols-2 gap-md">
                        <div class="space-y-xs"><label class="font-label-sm text-label-sm text-on-surface-variant px-xs">姓名</label><input class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container transition-all" placeholder="如何称呼您" style="outline:none;"></div>
                        <div class="space-y-xs"><label class="font-label-sm text-label-sm text-on-surface-variant px-xs">手机号码</label><input class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container transition-all" placeholder="方便我们回电" style="outline:none;"></div>
                    </div>
                    <div class="space-y-xs"><label class="font-label-sm text-label-sm text-on-surface-variant px-xs">咨询意向</label>
                        <select class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container transition-all">
                            <option>医疗服务预约</option><option>洗护美容预约</option><option>寄养服务咨询</option><option>商城售后咨询</option><option>其他</option>
                        </select>
                    </div>
                    <div class="space-y-xs"><label class="font-label-sm text-label-sm text-on-surface-variant px-xs">留言内容</label><textarea class="w-full px-base py-3 rounded-xl border-none bg-surface-container-low focus:ring-2 focus:ring-primary-container transition-all" placeholder="请简述您的需求..." rows="4" style="outline:none;"></textarea></div>
                    <button class="w-full bg-primary text-white py-4 rounded-full font-bold text-lg hover:shadow-xl transform hover:-translate-y-1 transition-all active:scale-95" type="submit">提交咨询</button>
                </form>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/jsp/common/footer.jspf" />
