package com.pethome.servlet;

import com.pethome.dao.UserDao;
import com.pethome.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 用户模块 Servlet
 *
 * URL: /user
 * 参数 action: login / register / logout / update / updatePassword
 *
 * 体现知识点：
 * - Servlet doGet/doPost 方法
 * - request.getParameter() 获取表单数据
 * - session 内置对象管理登录态
 * - 请求转发（forward）与重定向（sendRedirect）
 * - JavaBean 封装用户数据
 * - DAO 层 JDBC 数据访问
 */
@WebServlet("/user")
public class UserServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    @Override
    public void init() throws ServletException {
        System.out.println("[UserServlet] 用户模块 Servlet 已初始化");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // GET 请求也由 doPost 处理
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 设置编码（Filter 已处理，但双重保障）
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if (action == null) action = "";

        System.out.println("[UserServlet] action = " + action);

        switch (action) {
            case "login":
                handleLogin(req, resp);
                break;
            case "register":
                handleRegister(req, resp);
                break;
            case "logout":
                handleLogout(req, resp);
                break;
            case "update":
                handleUpdate(req, resp);
                break;
            case "updatePassword":
                handleUpdatePassword(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
        }
    }

    // ==================== 登录处理 ====================

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // 参数校验
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("errorMsg", "用户名和密码不能为空");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            return;
        }

        // 调用 DAO 验证登录
        User user = userDao.login(username.trim(), password.trim());

        if (user != null) {
            // 登录成功：将用户对象存入 session
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            System.out.println("[UserServlet] 用户 " + username + " 登录成功");

            // 检查是否有重定向 URL
            String redirectURL = (String) session.getAttribute("redirectURL");
            if (redirectURL != null) {
                session.removeAttribute("redirectURL");
                resp.sendRedirect(redirectURL);
            } else {
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
            }
        } else {
            // 登录失败：返回错误信息
            req.setAttribute("errorMsg", "用户名或密码错误");
            System.out.println("[UserServlet] 用户 " + username + " 登录失败");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
        }
    }

    // ==================== 注册处理 ====================

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String nickname = req.getParameter("nickname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        // 验证码校验
        String captcha = req.getParameter("captcha");
        HttpSession session = req.getSession();
        String captchaCode = (String) session.getAttribute("captchaCode");
        // 校验后立即失效（一次性使用）
        session.removeAttribute("captchaCode");

        if (captchaCode == null || captcha == null || captcha.trim().isEmpty()
                || !captchaCode.equalsIgnoreCase(captcha.trim())) {
            req.setAttribute("errorMsg", "验证码错误，请重新输入");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }

        // 参数校验
        if (username == null || username.trim().isEmpty()) {
            req.setAttribute("errorMsg", "用户名不能为空");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMsg", "密码不能为空");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }
        if (!password.equals(confirmPassword)) {
            req.setAttribute("errorMsg", "两次密码输入不一致");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }

        // 检查用户名是否已存在
        User existingUser = userDao.findByUsername(username.trim());
        if (existingUser != null) {
            req.setAttribute("errorMsg", "用户名已存在，请换一个");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }

        // 创建用户 JavaBean
        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(password.trim());
        user.setNickname(nickname != null ? nickname.trim() : username.trim());
        user.setEmail(email != null ? email.trim() : "");
        user.setPhone(phone != null ? phone.trim() : "");

        // 调用 DAO 插入数据
        int result = userDao.insert(user);

        if (result > 0) {
            // 注册成功：自动登录
            User loggedInUser = userDao.login(username.trim(), password.trim());
            if (loggedInUser != null) {
                session.setAttribute("user", loggedInUser);
            }
            System.out.println("[UserServlet] 用户 " + username + " 注册成功");
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        } else {
            req.setAttribute("errorMsg", "注册失败，请稍后重试");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
        }
    }

    // ==================== 退出处理 ====================

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();  // 销毁 session
        }
        System.out.println("[UserServlet] 用户已退出登录");
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }

    // ==================== 更新个人信息 ====================

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String nickname = req.getParameter("nickname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        currentUser.setNickname(nickname != null ? nickname.trim() : "");
        currentUser.setEmail(email != null ? email.trim() : "");
        currentUser.setPhone(phone != null ? phone.trim() : "");

        int result = userDao.update(currentUser);
        if (result > 0) {
            // 更新 session 中的用户信息
            session.setAttribute("user", currentUser);
            req.setAttribute("successMsg", "个人信息更新成功");
        } else {
            req.setAttribute("errorMsg", "更新失败");
        }

        req.getRequestDispatcher("/jsp/user-profile.jsp").forward(req, resp);
    }

    // ==================== 修改密码 ====================

    private void handleUpdatePassword(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String oldPwd = req.getParameter("oldPassword");
        String newPwd = req.getParameter("newPassword");
        String confirmPwd = req.getParameter("confirmPassword");

        if (!currentUser.getPassword().equals(oldPwd)) {
            req.setAttribute("errorMsg", "原密码不正确");
            req.getRequestDispatcher("/jsp/user-profile.jsp").forward(req, resp);
            return;
        }
        if (!newPwd.equals(confirmPwd)) {
            req.setAttribute("errorMsg", "两次新密码输入不一致");
            req.getRequestDispatcher("/jsp/user-profile.jsp").forward(req, resp);
            return;
        }

        int result = userDao.updatePassword(currentUser.getId(), newPwd);
        if (result > 0) {
            currentUser.setPassword(newPwd);
            session.setAttribute("user", currentUser);
            req.setAttribute("successMsg", "密码修改成功");
        } else {
            req.setAttribute("errorMsg", "密码修改失败");
        }

        req.getRequestDispatcher("/jsp/user-profile.jsp").forward(req, resp);
    }

    @Override
    public void destroy() {
        System.out.println("[UserServlet] 用户模块 Servlet 已销毁");
    }
}
