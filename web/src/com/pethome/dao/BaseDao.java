package com.pethome.dao;

import com.pethome.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 通用 DAO 基类
 *
 * 封装了 JDBC 通用的 CRUD 操作方法：
 * - 通用增删改（update）
 * - 通用查询列表（queryForList）
 * - 通用查询单条（queryForObject）
 * - 统计查询（count）
 *
 * 子类只需实现结果集到 JavaBean 的映射（resultSetToModel）
 */
public abstract class BaseDao<T> {

    /**
     * 执行增、删、改操作（INSERT / UPDATE / DELETE）
     *
     * @param sql    SQL 语句（使用 ? 占位符）
     * @param params 参数数组
     * @return 受影响的行数
     */
    protected int update(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            setParameters(ps, params);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("数据库操作失败: " + sql, e);
        } finally {
            DBUtil.close(ps, conn);
        }
    }

    /**
     * 使用事务执行更新操作
     */
    protected int updateWithTransaction(Connection conn, String sql, Object... params) {
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement(sql);
            setParameters(ps, params);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("事务操作失败: " + sql, e);
        } finally {
            DBUtil.close(ps);
        }
    }

    /**
     * 查询单条记录
     *
     * @param sql    SQL 语句
     * @param params 参数数组
     * @return 泛型对象，未找到时返回 null
     */
    protected T queryForObject(String sql, Object... params) {
        List<T> list = queryForList(sql, params);
        return list.isEmpty() ? null : list.get(0);
    }

    /**
     * 查询多条记录
     *
     * @param sql    SQL 语句
     * @param params 参数数组
     * @return 泛型对象列表
     */
    protected List<T> queryForList(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<T> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            setParameters(ps, params);
            rs = ps.executeQuery();
            while (rs.next()) {
                T obj = resultSetToModel(rs);
                if (obj != null) {
                    list.add(obj);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("数据库查询失败: " + sql, e);
        } finally {
            DBUtil.close(rs, ps, conn);
        }
        return list;
    }

    /**
     * 统计查询（COUNT）
     */
    protected int count(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            setParameters(ps, params);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("统计查询失败: " + sql, e);
        } finally {
            DBUtil.close(rs, ps, conn);
        }
        return 0;
    }

    // ==================== 辅助方法 ====================

    /**
     * 设置 PreparedStatement 的参数
     * 支持 String, Integer, Long, Double, BigDecimal, java.sql.Date 等类型
     */
    private void setParameters(PreparedStatement ps, Object... params) throws SQLException {
        if (params == null || params.length == 0) {
            return;
        }
        for (int i = 0; i < params.length; i++) {
            int index = i + 1;
            Object param = params[i];
            if (param == null) {
                ps.setObject(index, null);
            } else if (param instanceof String) {
                ps.setString(index, (String) param);
            } else if (param instanceof Integer) {
                ps.setInt(index, (Integer) param);
            } else if (param instanceof Long) {
                ps.setLong(index, (Long) param);
            } else if (param instanceof Double) {
                ps.setDouble(index, (Double) param);
            } else if (param instanceof java.math.BigDecimal) {
                ps.setBigDecimal(index, (java.math.BigDecimal) param);
            } else if (param instanceof java.util.Date) {
                ps.setTimestamp(index, new java.sql.Timestamp(((java.util.Date) param).getTime()));
            } else if (param instanceof java.sql.Date) {
                ps.setDate(index, (java.sql.Date) param);
            } else {
                ps.setObject(index, param);
            }
        }
    }

    // ==================== 抽象方法 ====================

    /**
     * 将 ResultSet 当前行转换为 JavaBean 对象
     * 子类必须实现此方法
     */
    protected abstract T resultSetToModel(ResultSet rs) throws SQLException;
}
