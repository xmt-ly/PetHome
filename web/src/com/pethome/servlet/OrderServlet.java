package com.pethome.servlet;

import com.pethome.dao.OrderDao;
import com.pethome.model.CartItem;
import com.pethome.model.Order;
import com.pethome.model.OrderItem;
import com.pethome.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * 订单模块 Servlet
 *
 * URL: /order
 * 参数 action: create / list / detail / cancel / updateStatus
 *
 * 体现知识点：
 * - DAO 层事务管理（下单时同时操作订单表和订单明细表）
 * - JDBC 事务（commit / rollback）
 * - session 获取当前用户
 * - 请求转发与重定向
 */
@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    private OrderDao orderDao = new OrderDao();

    @Override
    public void init() throws ServletException {
        System.out.println("[OrderServlet] 订单模块 Servlet 已初始化");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create":
                handleCreate(req, resp);
                break;
            case "detail":
                handleDetail(req, resp);
                break;
            case "cancel":
                handleCancel(req, resp);
                break;
            case "updateStatus":
                handleUpdateStatus(req, resp);
                break;
            default:
                handleList(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }

    // ==================== 创建订单（体现事务处理） ====================

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        // 从 Session 获取购物车数据
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart?action=list");
            return;
        }

        // 获取收货信息
        String address = req.getParameter("address");
        String phone = req.getParameter("phone");
        String receiver = req.getParameter("receiver");
        String remark = req.getParameter("remark");

        // 参数校验
        if (address == null || address.trim().isEmpty()) {
            req.setAttribute("errorMsg", "请填写收货地址");
            req.getRequestDispatcher("/jsp/checkout.jsp").forward(req, resp);
            return;
        }

        // 生成订单编号（体现日期格式化）
        String orderNo = "PH" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))
                + String.format("%04d", user.getId());

        // 计算总价
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart) {
            total = total.add(item.getSubtotal());
        }

        // 创建订单 JavaBean
        Order order = new Order();
        order.setOrderNo(orderNo);
        order.setUserId(user.getId());
        order.setTotalAmount(total);
        order.setAddress(address.trim());
        order.setPhone(phone != null ? phone.trim() : "");
        order.setReceiver(receiver != null ? receiver.trim() : "");
        order.setRemark(remark != null ? remark.trim() : "");

        // 创建订单明细列表
        List<OrderItem> items = new ArrayList<>();
        for (CartItem cartItem : cart) {
            items.add(new OrderItem(
                    cartItem.getProductId(),
                    cartItem.getProductName(),
                    cartItem.getPrice(),
                    cartItem.getQuantity()
            ));
        }

        // 调用 DAO 创建订单（事务管理）
        int orderId = orderDao.createOrder(order, items);

        if (orderId > 0) {
            // 下单成功：清空购物车
            cart.clear();
            session.setAttribute("cart", cart);

            System.out.println("[OrderServlet] 订单 " + orderNo + " 创建成功");
            resp.sendRedirect(req.getContextPath() + "/order?action=detail&id=" + orderId);
        } else {
            req.setAttribute("errorMsg", "创建订单失败，可能存在库存不足");
            req.getRequestDispatcher("/jsp/checkout.jsp").forward(req, resp);
        }
    }

    // ==================== 我的订单列表 ====================

    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        List<Order> orderList = orderDao.findByUserId(user.getId());

        // 为每个订单加载明细
        for (Order order : orderList) {
            List<OrderItem> items = orderDao.findItemsByOrderId(order.getId());
            order.setItems(items);
        }

        req.setAttribute("orderList", orderList);
        req.getRequestDispatcher("/jsp/order-list.jsp").forward(req, resp);
    }

    // ==================== 订单详情 ====================

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/order?action=list");
            return;
        }

        int id = Integer.parseInt(idStr);
        Order order = orderDao.findById(id);

        if (order == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "订单不存在");
            return;
        }

        // 加载订单明细
        List<OrderItem> items = orderDao.findItemsByOrderId(id);
        order.setItems(items);

        req.setAttribute("order", order);
        req.getRequestDispatcher("/jsp/order-detail.jsp").forward(req, resp);
    }

    // ==================== 取消订单 ====================

    private void handleCancel(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/order?action=list");
            return;
        }

        int id = Integer.parseInt(idStr);
        int result = orderDao.cancelOrder(id);

        if (result > 0) {
            System.out.println("[OrderServlet] 订单 " + id + " 已取消");
        }

        resp.sendRedirect(req.getContextPath() + "/order?action=detail&id=" + id);
    }

    // ==================== 更新订单状态（用户确认付款/确认收货） ====================

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String idStr = req.getParameter("id");
        String statusStr = req.getParameter("status");

        if (idStr == null || statusStr == null) {
            resp.sendRedirect(req.getContextPath() + "/order?action=list");
            return;
        }

        int id = Integer.parseInt(idStr);
        int newStatus = Integer.parseInt(statusStr);

        // 验证订单属于当前用户
        Order order = orderDao.findById(id);
        if (order == null || order.getUserId() != user.getId()) {
            resp.sendRedirect(req.getContextPath() + "/order?action=list");
            return;
        }

        // 只允许合法的状态流转：0→1（确认付款），2→3（确认收货）
        if ((order.getStatus() == 0 && newStatus == 1)
                || (order.getStatus() == 2 && newStatus == 3)) {
            orderDao.updateStatus(id, newStatus);
            System.out.println("[OrderServlet] 用户 " + user.getUsername() + " 订单 " + id + " 状态更新为 " + newStatus);
        }

        resp.sendRedirect(req.getContextPath() + "/order?action=detail&id=" + id);
    }

    @Override
    public void destroy() {
        System.out.println("[OrderServlet] 订单模块 Servlet 已销毁");
    }
}
