package com.pethome.dao;

import com.pethome.model.Service;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * 服务数据访问对象
 *
 * 实现服务模块的 CRUD 操作
 */
public class ServiceDao extends BaseDao<Service> {

    /**
     * 根据分类查询服务（grooming/boarding/clinic）
     */
    public List<Service> findByCategory(String category) {
        String sql = "SELECT * FROM t_service WHERE status = 1 AND category = ? ORDER BY price ASC";
        return queryForList(sql, category);
    }

    /**
     * 查询所有服务（管理后台用，按 ID 正序）
     */
    public List<Service> findAll() {
        String sql = "SELECT * FROM t_service ORDER BY id ASC";
        return queryForList(sql);
    }

    /**
     * 根据 ID 查询服务
     */
    public Service findById(int id) {
        String sql = "SELECT * FROM t_service WHERE id = ?";
        return queryForObject(sql, id);
    }

    /**
     * 查询同分类推荐服务（排除自身）
     */
    public List<Service> findRelated(String category, int excludeId, int limit) {
        String sql = "SELECT * FROM t_service WHERE status = 1 AND category = ? AND id != ? ORDER BY price ASC LIMIT ?";
        return queryForList(sql, category, excludeId, limit);
    }

    /**
     * 新增服务（INSERT）
     */
    public int insert(Service service) {
        String sql = "INSERT INTO t_service (name, description, price, category, image_url, status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        return update(sql,
                service.getName(),
                service.getDescription(),
                service.getPrice(),
                service.getCategory(),
                service.getImageUrl(),
                service.getStatus());
    }

    /**
     * 更新服务（UPDATE）
     */
    public int update(Service service) {
        String sql = "UPDATE t_service SET name = ?, description = ?, price = ?, "
                + "category = ?, image_url = ?, status = ? WHERE id = ?";
        return update(sql,
                service.getName(),
                service.getDescription(),
                service.getPrice(),
                service.getCategory(),
                service.getImageUrl(),
                service.getStatus(),
                service.getId());
    }

    /**
     * 删除服务（DELETE）
     */
    public int deleteById(int id) {
        String sql = "DELETE FROM t_service WHERE id = ?";
        return update(sql, id);
    }

    // ==================== ResultSet 映射 ====================

    @Override
    protected Service resultSetToModel(ResultSet rs) throws SQLException {
        Service s = new Service();
        s.setId(rs.getInt("id"));
        s.setName(rs.getString("name"));
        s.setDescription(rs.getString("description"));
        s.setPrice(rs.getBigDecimal("price"));
        s.setCategory(rs.getString("category"));
        s.setImageUrl(rs.getString("image_url"));
        s.setStatus(rs.getInt("status"));
        if (rs.getTimestamp("created_at") != null) {
            s.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        return s;
    }
}
