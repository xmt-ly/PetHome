package com.pethome.dao;

import com.pethome.model.Order;
import com.pethome.model.OrderItem;
import com.pethome.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * 订单数据访问对象
 *
 * 实现订单模块的 CRUD 操作：
 * - 创建订单（事务：同时插入 t_order 和 t_order_item，扣减库存）
 * - 根据用户 ID 查询订单列表
 * - 根据 ID 查询订单（含明细）
 * - 更新订单状态
 * - 管理员查询所有订单
 * - 取消订单
 */
public class OrderDao extends BaseDao<Order> {

    /**
     * 创建订单（使用事务）
     *
     * 同时完成：
     * 1. 插入订单表 t_order
     * 2. 插入订单明细表 t_order_item
     * 3. 扣减商品库存
     *
     * @return 订单 ID，失败返回 -1
     */
    public int createOrder(Order order, List<OrderItem> items) {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psItem = null;
        PreparedStatement psStock = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            // 开启事务（取消自动提交）
            conn.setAutoCommit(false);

            // 1. 插入订单
            String sqlOrder = "INSERT INTO t_order (order_no, user_id, total_amount, status, "
                    + "address, phone, receiver, remark) VALUES (?, ?, ?, 0, ?, ?, ?, ?)";
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, order.getOrderNo());
            psOrder.setInt(2, order.getUserId());
            psOrder.setBigDecimal(3, order.getTotalAmount());
            psOrder.setString(4, order.getAddress());
            psOrder.setString(5, order.getPhone());
            psOrder.setString(6, order.getReceiver());
            psOrder.setString(7, order.getRemark());
            psOrder.executeUpdate();

            // 获取生成的订单 ID
            rs = psOrder.getGeneratedKeys();
            int orderId;
            if (rs.next()) {
                orderId = rs.getInt(1);
            } else {
                conn.rollback();
                return -1;
            }

            // 2. 插入订单明细 + 扣减库存
            String sqlItem = "INSERT INTO t_order_item (order_id, product_id, product_name, price, quantity) "
                    + "VALUES (?, ?, ?, ?, ?)";
            String sqlStock = "UPDATE t_product SET stock = stock - ?, sales = sales + ? WHERE id = ? AND stock >= ?";

            psItem = conn.prepareStatement(sqlItem);
            psStock = conn.prepareStatement(sqlStock);

            for (OrderItem item : items) {
                // 插入明细
                psItem.setInt(1, orderId);
                psItem.setInt(2, item.getProductId());
                psItem.setString(3, item.getProductName());
                psItem.setBigDecimal(4, item.getPrice());
                psItem.setInt(5, item.getQuantity());
                psItem.addBatch();

                // 扣减库存
                psStock.setInt(1, item.getQuantity());
                psStock.setInt(2, item.getQuantity());
                psStock.setInt(3, item.getProductId());
                psStock.setInt(4, item.getQuantity());
                psStock.addBatch();
            }

            psItem.executeBatch();
            int[] stockResults = psStock.executeBatch();

            // 检查库存是否足够（任何一条返回 0 表示库存不足）
            for (int r : stockResults) {
                if (r == 0) {
                    conn.rollback();
                    return -1;
                }
            }

            // 提交事务
            conn.commit();
            return orderId;

        } catch (SQLException e) {
            // 事务回滚
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            throw new RuntimeException("创建订单失败", e);
        } finally {
            DBUtil.close(rs, psStock, psItem, psOrder);
            DBUtil.closeConnection(conn);
        }
    }

    /**
     * 根据用户 ID 查询订单列表（按时间倒序）
     */
    public List<Order> findByUserId(int userId) {
        String sql = "SELECT o.*, u.username FROM t_order o "
                + "LEFT JOIN t_user u ON o.user_id = u.id "
                + "WHERE o.user_id = ? ORDER BY o.created_at DESC";
        return queryForList(sql, userId);
    }

    /**
     * 查询所有订单（管理员用，按 ID 正序）
     */
    public List<Order> findAll() {
        String sql = "SELECT o.*, u.username FROM t_order o "
                + "LEFT JOIN t_user u ON o.user_id = u.id "
                + "ORDER BY o.id ASC";
        return queryForList(sql);
    }

    /**
     * 根据 ID 查询订单
     */
    public Order findById(int id) {
        String sql = "SELECT o.*, u.username FROM t_order o "
                + "LEFT JOIN t_user u ON o.user_id = u.id WHERE o.id = ?";
        return queryForObject(sql, id);
    }

    /**
     * 根据订单编号查询
     */
    public Order findByOrderNo(String orderNo) {
        String sql = "SELECT o.*, u.username FROM t_order o "
                + "LEFT JOIN t_user u ON o.user_id = u.id WHERE o.order_no = ?";
        return queryForObject(sql, orderNo);
    }

    /**
     * 更新订单状态
     */
    public int updateStatus(int orderId, int status) {
        String sql = "UPDATE t_order SET status = ? WHERE id = ?";
        return update(sql, status, orderId);
    }

    /**
     * 取消订单（只有待付款状态可以取消）
     */
    public int cancelOrder(int orderId) {
        String sql = "UPDATE t_order SET status = 4 WHERE id = ? AND status = 0";
        return update(sql, orderId);
    }

    /**
     * 查询订单统计
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM t_order";
        return count(sql);
    }

    // ==================== 订单明细查询 ====================

    /**
     * 根据订单 ID 查询订单明细列表
     */
    public List<OrderItem> findItemsByOrderId(int orderId) {
        String sql = "SELECT * FROM t_order_item WHERE order_id = ?";
        return queryForItemList(sql, orderId);
    }

    /**
     * 查询多条明细记录
     */
    private List<OrderItem> queryForItemList(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<OrderItem> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    ps.setObject(i + 1, params[i]);
                }
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setQuantity(rs.getInt("quantity"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, ps, conn);
        }
        return list;
    }

    // ==================== ResultSet 映射 ====================

    @Override
    protected Order resultSetToModel(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setOrderNo(rs.getString("order_no"));
        o.setUserId(rs.getInt("user_id"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setStatus(rs.getInt("status"));
        o.setAddress(rs.getString("address"));
        o.setPhone(rs.getString("phone"));
        o.setReceiver(rs.getString("receiver"));
        o.setRemark(rs.getString("remark"));
        if (rs.getTimestamp("created_at") != null) {
            o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        if (rs.getTimestamp("updated_at") != null) {
            o.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        }
        // 用户名（LEFT JOIN 得到）
        o.setUsername(rs.getString("username"));
        return o;
    }
}
