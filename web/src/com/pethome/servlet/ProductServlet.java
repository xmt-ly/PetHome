package com.pethome.servlet;

import com.pethome.dao.ProductDao;
import com.pethome.dao.CategoryDao;
import com.pethome.model.Category;
import com.pethome.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 商品模块 Servlet
 *
 * URL: /product
 * 参数 action: list / detail / search / category
 *
 * 体现知识点：
 * - Servlet 数据查询
 * - request.setAttribute() 传递数据到 JSP
 * - 请求转发 forward
 * - JDBC 分页查询与模糊查询
 * - JavaBean 封装商品数据
 */
@WebServlet("/product")
public class ProductServlet extends HttpServlet {

    private ProductDao productDao = new ProductDao();
    private CategoryDao categoryDao = new CategoryDao();

    @Override
    public void init() throws ServletException {
        System.out.println("[ProductServlet] 商品模块 Servlet 已初始化");
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
            case "detail":
                handleDetail(req, resp);
                break;
            case "search":
                handleSearch(req, resp);
                break;
            case "category":
                handleCategory(req, resp);
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

    // ==================== 商品列表 ====================

    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 获取分页参数
        int page = 1;
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException ignored) {}
        }
        int pageSize = 24;

        // 查询商品列表和分类信息
        List<Product> productList = productDao.findPage(page, pageSize);
        int totalCount = productDao.countAll();
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // 查询所有商品（首页展示用）和分类列表
        List<Product> allProducts = productDao.findAll();
        List<Category> categories = categoryDao.findAll();

        req.setAttribute("productList", productList);
        req.setAttribute("allProducts", allProducts);
        req.setAttribute("categories", categories);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("activePage", "shop");

        req.getRequestDispatcher("/jsp/shop.jsp").forward(req, resp);
    }

    // ==================== 商品详情 ====================

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/product");
            return;
        }

        int id = Integer.parseInt(idStr);
        Product product = productDao.findById(id);

        if (product == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "商品不存在");
            return;
        }

        // 查询分类图标
        String catIcon = "";
        if (product.getCategoryName() != null) {
            Category cat = categoryDao.findByName(product.getCategoryName());
            if (cat != null && cat.getIcon() != null) catIcon = cat.getIcon();
        }

        // 查询同分类推荐商品
        List<Product> relatedProducts = productDao.findRelated(id, product.getCategoryId(), 4);

        req.setAttribute("product", product);
        req.setAttribute("relatedProducts", relatedProducts);
        req.setAttribute("categoryIcon", catIcon);
        req.getRequestDispatcher("/jsp/product-detail.jsp").forward(req, resp);
    }

    // ==================== 搜索商品（模糊查询） ====================

    private void handleSearch(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        if (keyword == null) keyword = "";

        List<Product> resultList = productDao.search(keyword.trim());

        req.setAttribute("productList", resultList);
        req.setAttribute("keyword", keyword.trim());
        req.setAttribute("searchResult", true);
        req.setAttribute("activePage", "shop");

        req.getRequestDispatcher("/jsp/shop.jsp").forward(req, resp);
    }

    // ==================== 按分类查询 ====================

    private void handleCategory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String categoryIdStr = req.getParameter("id");
        if (categoryIdStr == null || categoryIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/product");
            return;
        }

        int categoryId = Integer.parseInt(categoryIdStr);
        List<Product> productList = productDao.findByCategoryId(categoryId);
        List<Category> categories = categoryDao.findAll();

        req.setAttribute("productList", productList);
        req.setAttribute("categories", categories);
        req.setAttribute("categoryId", categoryId);
        req.setAttribute("activePage", "shop");

        req.getRequestDispatcher("/jsp/shop.jsp").forward(req, resp);
    }

    @Override
    public void destroy() {
        System.out.println("[ProductServlet] 商品模块 Servlet 已销毁");
    }
}
