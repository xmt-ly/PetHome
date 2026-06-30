package com.pethome.servlet;

import com.pethome.dao.ServiceDao;
import com.pethome.model.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 服务模块 Servlet
 *
 * URL: /service
 *
 * 查询所有服务并按分类返回给 JSP 页面
 * 使用 Map 对服务进行分类，体现集合框架的应用
 */
@WebServlet("/service")
public class ServiceServlet extends HttpServlet {

    private ServiceDao serviceDao = new ServiceDao();

    @Override
    public void init() throws ServletException {
        System.out.println("[ServiceServlet] 服务模块 Servlet 已初始化");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if ("detail".equals(action)) {
            handleDetail(req, resp);
        } else {
            handleList(req, resp);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 查询所有服务
        List<Service> allServices = serviceDao.findAll();

        // 按分类查询
        List<Service> groomingServices = serviceDao.findByCategory("grooming");
        List<Service> boardingServices = serviceDao.findByCategory("boarding");
        List<Service> clinicServices = serviceDao.findByCategory("clinic");

        req.setAttribute("groomingServices", groomingServices);
        req.setAttribute("boardingServices", boardingServices);
        req.setAttribute("clinicServices", clinicServices);
        req.setAttribute("activePage", "services");

        req.getRequestDispatcher("/jsp/services.jsp").forward(req, resp);
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/service");
            return;
        }

        int id = Integer.parseInt(idStr);
        Service service = serviceDao.findById(id);

        if (service == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "服务不存在");
            return;
        }

        // 查询同分类热门推荐（排除自身）
        List<Service> related = serviceDao.findRelated(service.getCategory(), id, 3);

        req.setAttribute("service", service);
        req.setAttribute("relatedServices", related);
        req.getRequestDispatcher("/jsp/service-detail.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    public void destroy() {
        System.out.println("[ServiceServlet] 服务模块 Servlet 已销毁");
    }
}
