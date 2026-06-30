package com.pethome.servlet;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;
import javax.imageio.ImageIO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 验证码图片生成 Servlet
 *
 * URL: /captcha
 * 生成 4 位随机字母 + 数字验证码，存入 Session（键名：captchaCode）
 *
 * 体现知识点：
 * - BufferedImage + Graphics 画图 API
 * - Session 存储验证码（服务器端校验）
 * - 禁止浏览器缓存（Pragma / Cache-Control / Expires）
 * - response.setContentType("image/jpeg") 输出图片流
 */
@WebServlet("/captcha")
public class ImageServlet extends HttpServlet {

    /** 图片宽度 */
    private static final int WIDTH = 120;
    /** 图片高度 */
    private static final int HEIGHT = 40;
    /** 验证码字符数 */
    private static final int CODE_COUNT = 4;
    /** 干扰线数量 */
    private static final int LINE_COUNT = 6;
    /** 验证码字符池（去掉易混淆的 0/O、1/I/l） */
    private static final String CHAR_POOL = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ";

    private final Random random = new Random();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 禁止浏览器缓存
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);
        response.setContentType("image/jpeg");

        // 1. 创建画布
        BufferedImage image = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics g = image.getGraphics();

        // 2. 绘制背景（浅色）
        g.setColor(new Color(240, 248, 255));
        g.fillRect(0, 0, WIDTH, HEIGHT);

        // 3. 生成验证码字符串并绘制
        StringBuilder code = new StringBuilder();
        Font font = new Font("SansSerif", Font.BOLD | Font.ITALIC, 28);
        g.setFont(font);

        for (int i = 0; i < CODE_COUNT; i++) {
            String ch = String.valueOf(CHAR_POOL.charAt(random.nextInt(CHAR_POOL.length())));
            code.append(ch);
            // 每个字符随机颜色
            g.setColor(new Color(
                    random.nextInt(100),
                    random.nextInt(100),
                    random.nextInt(100)
            ));
            // 字符间距均匀，带少量随机偏移
            int x = i * 25 + 8 + random.nextInt(5);
            int y = 28 + random.nextInt(6);
            g.drawString(ch, x, y);
        }

        // 4. 绘制干扰线
        for (int i = 0; i < LINE_COUNT; i++) {
            g.setColor(new Color(
                    150 + random.nextInt(106),
                    150 + random.nextInt(106),
                    150 + random.nextInt(106)
            ));
            int x1 = random.nextInt(WIDTH);
            int y1 = random.nextInt(HEIGHT);
            int x2 = random.nextInt(WIDTH);
            int y2 = random.nextInt(HEIGHT);
            g.drawLine(x1, y1, x2, y2);
        }

        // 5. 存入 Session
        HttpSession session = request.getSession(true);
        session.setAttribute("captchaCode", code.toString());

        // 6. 输出图片
        g.dispose();
        ImageIO.write(image, "JPEG", response.getOutputStream());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
