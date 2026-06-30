package com.pethome.dao;

import com.pethome.model.User;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * 用户数据访问对象
 *
 * 实现用户模块的 CRUD 操作：
 * - 用户注册（insert）
 * - 登录验证（select by username + password）
 * - 根据 ID 查询
 * - 检查用户名是否存在
 * - 更新用户信息
 * - 查询所有用户（管理员功能）
 * - 删除用户（管理员功能）
 */
public class UserDao extends BaseDao<User> {

    /**
     * 用户注册（INSERT）
     */
    public int insert(User user) {
        String sql = "INSERT INTO t_user (username, password, nickname, email, phone) VALUES (?, ?, ?, ?, ?)";
        return update(sql,
                user.getUsername(),
                user.getPassword(),
                user.getNickname(),
                user.getEmail(),
                user.getPhone());
    }

    /**
     * 用户登录验证（SELECT by username AND password）
     * 返回 User 对象，登录失败返回 null
     */
    public User login(String username, String password) {
        String sql = "SELECT * FROM t_user WHERE username = ? AND password = ?";
        return queryForObject(sql, username, password);
    }

    /**
     * 根据用户名查询
     */
    public User findByUsername(String username) {
        String sql = "SELECT * FROM t_user WHERE username = ?";
        return queryForObject(sql, username);
    }

    /**
     * 根据 ID 查询用户
     */
    public User findById(int id) {
        String sql = "SELECT * FROM t_user WHERE id = ?";
        return queryForObject(sql, id);
    }

    /**
     * 更新用户信息（UPDATE）
     */
    public int update(User user) {
        String sql = "UPDATE t_user SET nickname = ?, email = ?, phone = ? WHERE id = ?";
        return update(sql, user.getNickname(), user.getEmail(), user.getPhone(), user.getId());
    }

    /**
     * 更新密码
     */
    public int updatePassword(int userId, String newPassword) {
        String sql = "UPDATE t_user SET password = ? WHERE id = ?";
        return update(sql, newPassword, userId);
    }

    /**
     * 查询所有用户（管理员功能，按 ID 正序）
     */
    public List<User> findAll() {
        String sql = "SELECT * FROM t_user ORDER BY id ASC";
        return queryForList(sql);
    }

    /**
     * 删除用户（管理员功能，DELETE）
     */
    public int deleteById(int id) {
        String sql = "DELETE FROM t_user WHERE id = ? AND role = 0"; // 不能删除管理员
        return update(sql, id);
    }

    /**
     * 统计用户总数
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM t_user";
        return count(sql);
    }

    // ==================== 实现 ResultSet 到 JavaBean 的映射 ====================

    @Override
    protected User resultSetToModel(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setNickname(rs.getString("nickname"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setAvatar(rs.getString("avatar"));
        user.setRole(rs.getInt("role"));
        if (rs.getTimestamp("created_at") != null) {
            user.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        if (rs.getTimestamp("updated_at") != null) {
            user.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        }
        return user;
    }
}
