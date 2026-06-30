package com.pethome.servlet;

import com.pethome.dao.OrderDao;
import com.pethome.dao.ProductDao;
import com.pethome.dao.CategoryDao;
import com.pethome.dao.ServiceDao;
import com.pethome.dao.UserDao;
import com.pethome.model.Category;
import com.pethome.model.Order;
import com.pethome.model.OrderItem;
import com.pethome.model.Product;
import com.pethome.model.Service;
import com.pethome.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.File;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

/**
 * 后台管理 Servlet
 *
 * URL: /admin
 * 参数 action 及模块分发
 *
 * 体现完整的 CRUD 操作流程：
 * - 商品管理：list / add / edit / delete
 * - 服务管理：list / add / edit / delete
 * - 订单管理：list / updateStatus
 * - 用户管理：list / delete
 */
@WebServlet("/admin")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1MB 内存缓冲
    maxFileSize = 1024 * 1024 * 10,     // 单文件最大 10MB
    maxRequestSize = 1024 * 1024 * 50   // 请求最大 50MB
)
public class AdminServlet extends HttpServlet {

    private ProductDao productDao = new ProductDao();
    private CategoryDao categoryDao = new CategoryDao();
    private ServiceDao serviceDao = new ServiceDao();
    private OrderDao orderDao = new OrderDao();
    private UserDao userDao = new UserDao();

    @Override
    public void init() throws ServletException {
        System.out.println("[AdminServlet] 后台管理 Servlet 已初始化");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        // 验证管理员权限
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String module = req.getParameter("module");
        String action = req.getParameter("action");
        if (module == null) module = "dashboard";
        if (action == null) action = "list";

        switch (module) {
            case "product":
                handleProductModule(req, resp, action);
                break;
            case "service":
                handleServiceModule(req, resp, action);
                break;
            case "order":
                handleOrderModule(req, resp, action);
                break;
            case "user":
                handleUserModule(req, resp, action);
                break;
            default:
                handleDashboard(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }

    // ==================== 控制台首页 ====================

    private void handleDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 统计数据
        int productCount = productDao.countAll();
        int orderCount = orderDao.countAll();
        int userCount = userDao.countAll();

        req.setAttribute("productCount", productCount);
        req.setAttribute("orderCount", orderCount);
        req.setAttribute("userCount", userCount);

        req.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(req, resp);
    }

    // ==================== 商品管理 (CRUD) ====================

    private void handleProductModule(HttpServletRequest req, HttpServletResponse resp,
                                     String action) throws ServletException, IOException {
        switch (action) {
            case "add":
                handleProductAdd(req, resp);
                break;
            case "edit":
                handleProductEdit(req, resp);
                break;
            case "delete":
                handleProductDelete(req, resp);
                break;
            default:
                handleProductList(req, resp);
        }
    }

    private void handleProductList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Product> productList = productDao.findAll();
        List<Category> categories = categoryDao.findAll();
        req.setAttribute("productList", productList);
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/jsp/admin/product-manage.jsp").forward(req, resp);
    }

    private void handleProductAdd(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String name = req.getParameter("name");
        String price = req.getParameter("price");
        String categoryId = req.getParameter("categoryId");
        String brand = req.getParameter("brand");
        String stock = req.getParameter("stock");
        String description = req.getParameter("description");
        String tag = req.getParameter("tag");

        // 参数校验
        if (name == null || name.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "商品名称不能为空");
            return;
        }
        if (price == null || price.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "商品价格不能为空");
            return;
        }
        if (categoryId == null || categoryId.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "商品分类不能为空");
            return;
        }
        if (stock == null || stock.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "库存不能为空");
            return;
        }

        BigDecimal productPrice;
        int productCategoryId;
        int productStock;
        try {
            productPrice = new BigDecimal(price);
            productCategoryId = Integer.parseInt(categoryId);
            productStock = Integer.parseInt(stock);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "参数格式错误");
            return;
        }

        // 处理图片上传
        String imageUrl = saveUploadedImage(req);

        Product p = new Product();
        p.setName(name);
        p.setPrice(productPrice);
        p.setCategoryId(productCategoryId);
        p.setBrand(brand);
        p.setStock(productStock);
        p.setDescription(description);
        p.setImageUrl(imageUrl);
        p.setTag(tag != null ? tag : "");
        p.setStatus(1);

        productDao.insert(p);
        System.out.println("[AdminServlet] 新增商品: " + name);
        resp.sendRedirect(req.getContextPath() + "/admin?module=product");
    }

    private void handleProductEdit(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String idStr = req.getParameter("id");
        String name = req.getParameter("name");
        String price = req.getParameter("price");
        String categoryId = req.getParameter("categoryId");
        String brand = req.getParameter("brand");
        String stock = req.getParameter("stock");
        String description = req.getParameter("description");
        String statusStr = req.getParameter("status");
        String tag = req.getParameter("tag");

        // 参数校验
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "商品ID不能为空");
            return;
        }
        if (name == null || name.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "商品名称不能为空");
            return;
        }
        if (price == null || price.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "商品价格不能为空");
            return;
        }
        if (categoryId == null || categoryId.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "商品分类不能为空");
            return;
        }
        if (stock == null || stock.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "库存不能为空");
            return;
        }

        int productId;
        BigDecimal productPrice;
        int productCategoryId;
        int productStock;
        try {
            productId = Integer.parseInt(idStr);
            productPrice = new BigDecimal(price);
            productCategoryId = Integer.parseInt(categoryId);
            productStock = Integer.parseInt(stock);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "参数格式错误");
            return;
        }

        // 处理图片：有新上传则替换，否则保留原值
        String imageUrl = saveUploadedImage(req);
        if (imageUrl == null || imageUrl.isEmpty()) {
            imageUrl = req.getParameter("existingImageUrl");
        }

        int productStatus = 1;
        if (statusStr != null && !statusStr.isEmpty()) {
            try {
                productStatus = Integer.parseInt(statusStr);
            } catch (NumberFormatException e) {
                // 保持默认值 1
            }
        }

        Product p = new Product();
        p.setId(productId);
        p.setName(name);
        p.setPrice(productPrice);
        p.setCategoryId(productCategoryId);
        p.setBrand(brand);
        p.setStock(productStock);
        p.setDescription(description);
        p.setImageUrl(imageUrl != null ? imageUrl : "");
        p.setTag(tag != null ? tag : "");
        p.setStatus(productStatus);

        productDao.update(p);
        System.out.println("[AdminServlet] 更新商品: " + name);
        resp.sendRedirect(req.getContextPath() + "/admin?module=product");
    }

    /**
     * 保存上传的图片文件，返回相对路径；无上传则返回 null
     */
    private String saveUploadedImage(HttpServletRequest req) throws IOException, ServletException {
        Part filePart = req.getPart("imageFile");
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String submittedFileName = filePart.getSubmittedFileName();
        if (submittedFileName == null || submittedFileName.isEmpty()) {
            return null;
        }

        // 生成唯一文件名
        String ext = "";
        int dotIdx = submittedFileName.lastIndexOf('.');
        if (dotIdx > 0) {
            ext = submittedFileName.substring(dotIdx);
        }
        String fileName = UUID.randomUUID().toString().replace("-", "") + ext;

        // 保存到 web/static/uploads/
        String uploadDir = req.getServletContext().getRealPath("/static/uploads");
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        filePart.write(uploadDir + File.separator + fileName);

        return "static/uploads/" + fileName;
    }

    private void handleProductDelete(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String id = req.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin?module=product");
            return;
        }
        try {
            int productId = Integer.parseInt(id);
            productDao.deleteById(productId);
            System.out.println("[AdminServlet] 删除商品 ID: " + id);
        } catch (NumberFormatException e) {
            // 忽略无效 ID
        }
        resp.sendRedirect(req.getContextPath() + "/admin?module=product");
    }

    // ==================== 服务管理 (CRUD) ====================

    private void handleServiceModule(HttpServletRequest req, HttpServletResponse resp,
                                     String action) throws ServletException, IOException {
        switch (action) {
            case "add":
                handleServiceAdd(req, resp);
                break;
            case "edit":
                handleServiceEdit(req, resp);
                break;
            case "delete":
                handleServiceDelete(req, resp);
                break;
            default:
                handleServiceList(req, resp);
        }
    }

    private void handleServiceList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Service> serviceList = serviceDao.findAll();
        req.setAttribute("serviceList", serviceList);
        req.getRequestDispatcher("/jsp/admin/service-manage.jsp").forward(req, resp);
    }

    private void handleServiceAdd(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        String price = req.getParameter("price");
        String category = req.getParameter("category");

        // 参数校验
        if (name == null || name.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "服务名称不能为空");
            return;
        }
        if (price == null || price.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "服务价格不能为空");
            return;
        }

        BigDecimal servicePrice;
        try {
            servicePrice = new BigDecimal(price);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "价格格式错误");
            return;
        }

        Service s = new Service();
        s.setName(name);
        s.setDescription(description);
        s.setPrice(servicePrice);
        s.setCategory(category);
        s.setStatus(1);

        serviceDao.insert(s);
        resp.sendRedirect(req.getContextPath() + "/admin?module=service");
    }

    private void handleServiceEdit(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idStr = req.getParameter("id");
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        String price = req.getParameter("price");
        String category = req.getParameter("category");
        String statusStr = req.getParameter("status");

        // 参数校验
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "服务ID不能为空");
            return;
        }
        if (name == null || name.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "服务名称不能为空");
            return;
        }
        if (price == null || price.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "服务价格不能为空");
            return;
        }

        int serviceId;
        BigDecimal servicePrice;
        try {
            serviceId = Integer.parseInt(idStr);
            servicePrice = new BigDecimal(price);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "参数格式错误");
            return;
        }

        int serviceStatus = 1;
        if (statusStr != null && !statusStr.isEmpty()) {
            try {
                serviceStatus = Integer.parseInt(statusStr);
            } catch (NumberFormatException e) {
                // 保持默认值 1
            }
        }

        Service s = new Service();
        s.setId(serviceId);
        s.setName(name);
        s.setDescription(description);
        s.setPrice(servicePrice);
        s.setCategory(category);
        s.setStatus(serviceStatus);

        serviceDao.update(s);
        resp.sendRedirect(req.getContextPath() + "/admin?module=service");
    }

    private void handleServiceDelete(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String id = req.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin?module=service");
            return;
        }
        try {
            int serviceId = Integer.parseInt(id);
            serviceDao.deleteById(serviceId);
        } catch (NumberFormatException e) {
            // 忽略无效 ID
        }
        resp.sendRedirect(req.getContextPath() + "/admin?module=service");
    }

    // ==================== 订单管理 ====================

    private void handleOrderModule(HttpServletRequest req, HttpServletResponse resp,
                                   String action) throws ServletException, IOException {
        if ("updateStatus".equals(action)) {
            String id = req.getParameter("id");
            String status = req.getParameter("status");
            if (id != null && status != null) {
                try {
                    orderDao.updateStatus(Integer.parseInt(id), Integer.parseInt(status));
                } catch (NumberFormatException e) {
                    // 忽略无效参数
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin?module=order");
        } else {
            List<Order> orderList = orderDao.findAll();
            req.setAttribute("orderList", orderList);
            req.getRequestDispatcher("/jsp/admin/order-manage.jsp").forward(req, resp);
        }
    }

    // ==================== 用户管理 ====================

    private void handleUserModule(HttpServletRequest req, HttpServletResponse resp,
                                  String action) throws ServletException, IOException {
        if ("delete".equals(action)) {
            String id = req.getParameter("id");
            if (id != null) {
                try {
                    userDao.deleteById(Integer.parseInt(id));
                } catch (NumberFormatException e) {
                    // 忽略无效 ID
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin?module=user");
        } else {
            List<User> userList = userDao.findAll();
            req.setAttribute("userList", userList);
            req.getRequestDispatcher("/jsp/admin/user-manage.jsp").forward(req, resp);
        }
    }

    @Override
    public void destroy() {
        System.out.println("[AdminServlet] 后台管理 Servlet 已销毁");
    }
}
