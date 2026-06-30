package com.pethome.servlet;

import com.pethome.dao.ProductDao;
import com.pethome.model.CartItem;
import com.pethome.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * 购物车模块 Servlet
 *
 * 购物车数据存储在 HttpSession 中（体现 session 内置对象的使用）
 *
 * URL: /cart
 * 参数 action: list / add / remove / update / clear
 *
 * 体现知识点：
 * - session 内置对象存储购物车数据
 * - 集合框架（List、迭代器）操作购物车
 * - JavaBean 封装购物车项
 * - 重定向
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private ProductDao productDao = new ProductDao();

    @Override
    public void init() throws ServletException {
        System.out.println("[CartServlet] 购物车模块 Servlet 已初始化");
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
            case "add":
                handleAdd(req, resp);
                break;
            case "remove":
                handleRemove(req, resp);
                break;
            case "update":
                handleUpdate(req, resp);
                break;
            case "clear":
                handleClear(req, resp);
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

    // ==================== 查看购物车 ====================

    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 获取购物车数据（在 session 中）
        HttpSession session = req.getSession();
        List<CartItem> cart = getCartFromSession(session);

        // 计算总价
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart) {
            total = total.add(item.getSubtotal());
        }

        req.setAttribute("cartItems", cart);
        req.setAttribute("cartTotal", total);
        req.setAttribute("cartCount", cart.size());

        req.getRequestDispatcher("/jsp/cart.jsp").forward(req, resp);
    }

    // ==================== 添加到购物车 ====================

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String productIdStr = req.getParameter("productId");
        if (productIdStr == null || productIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/product");
            return;
        }

        int productId = Integer.parseInt(productIdStr);
        int quantity = 1;
        String qtyStr = req.getParameter("quantity");
        if (qtyStr != null && !qtyStr.isEmpty()) {
            try {
                quantity = Integer.parseInt(qtyStr);
            } catch (NumberFormatException ignored) {}
        }

        // 查询商品信息
        Product product = productDao.findById(productId);
        if (product == null) {
            resp.sendRedirect(req.getContextPath() + "/product");
            return;
        }

        // 添加到购物车
        HttpSession session = req.getSession();
        List<CartItem> cart = getCartFromSession(session);

        // 检查是否已存在相同商品
        boolean found = false;
        for (CartItem item : cart) {
            if (item.getProductId() == productId) {
                item.setQuantity(item.getQuantity() + quantity);
                found = true;
                break;
            }
        }

        if (!found) {
            CartItem newItem = new CartItem(
                    product.getId(),
                    product.getName(),
                    product.getPrice(),
                    product.getImageUrl(),
                    quantity
            );
            cart.add(newItem);
        }

        // 更新 session
        session.setAttribute("cart", cart);
        System.out.println("[CartServlet] 商品 " + product.getName() + " 已添加到购物车");

        // 重定向到购物车页面
        resp.sendRedirect(req.getContextPath() + "/cart?action=list");
    }

    // ==================== 从购物车移除 ====================

    private void handleRemove(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String productIdStr = req.getParameter("productId");
        if (productIdStr == null || productIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart?action=list");
            return;
        }

        int productId = Integer.parseInt(productIdStr);
        HttpSession session = req.getSession();
        List<CartItem> cart = getCartFromSession(session);

        // 使用迭代器遍历并删除（体现 Iterator 的使用）
        Iterator<CartItem> iterator = cart.iterator();
        while (iterator.hasNext()) {
            CartItem item = iterator.next();
            if (item.getProductId() == productId) {
                iterator.remove();
                break;
            }
        }

        session.setAttribute("cart", cart);
        resp.sendRedirect(req.getContextPath() + "/cart?action=list");
    }

    // ==================== 更新购物车商品数量 ====================

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String productIdStr = req.getParameter("productId");
        String quantityStr = req.getParameter("quantity");

        if (productIdStr == null || quantityStr == null) {
            resp.sendRedirect(req.getContextPath() + "/cart?action=list");
            return;
        }

        int productId = Integer.parseInt(productIdStr);
        int quantity = Integer.parseInt(quantityStr);

        HttpSession session = req.getSession();
        List<CartItem> cart = getCartFromSession(session);

        if (quantity <= 0) {
            // 数量为 0 则移除
            cart.removeIf(item -> item.getProductId() == productId);
        } else {
            for (CartItem item : cart) {
                if (item.getProductId() == productId) {
                    item.setQuantity(quantity);
                    break;
                }
            }
        }

        session.setAttribute("cart", cart);
        resp.sendRedirect(req.getContextPath() + "/cart?action=list");
    }

    // ==================== 清空购物车 ====================

    private void handleClear(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession();
        List<CartItem> cart = getCartFromSession(session);
        cart.clear();
        session.setAttribute("cart", cart);
        resp.sendRedirect(req.getContextPath() + "/cart?action=list");
    }

    // ==================== 辅助方法 ====================

    /**
     * 从 Session 中获取购物车列表
     * 如果不存在则创建一个新的空购物车
     */
    @SuppressWarnings("unchecked")
    private List<CartItem> getCartFromSession(HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    @Override
    public void destroy() {
        System.out.println("[CartServlet] 购物车模块 Servlet 已销毁");
    }
}
