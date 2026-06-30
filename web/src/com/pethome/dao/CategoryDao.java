package com.pethome.dao;

import com.pethome.model.Category;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * 商品分类数据访问对象
 *
 * 提供分类的查询操作
 */
public class CategoryDao extends BaseDao<Category> {

    /**
     * 查询全部分类（按 sort_order 排序）
     */
    public List<Category> findAll() {
        String sql = "SELECT * FROM t_category ORDER BY sort_order ASC";
        return queryForList(sql);
    }

    /**
     * 根据 ID 查询分类
     */
    public Category findById(int id) {
        String sql = "SELECT * FROM t_category WHERE id = ?";
        return queryForObject(sql, id);
    }

    /**
     * 根据名称查询分类
     */
    public Category findByName(String name) {
        String sql = "SELECT * FROM t_category WHERE name = ?";
        return queryForObject(sql, name);
    }

    @Override
    protected Category resultSetToModel(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setId(rs.getInt("id"));
        c.setName(rs.getString("name"));
        c.setIcon(rs.getString("icon"));
        c.setSubcategories(rs.getString("subcategories"));
        c.setSortOrder(rs.getInt("sort_order"));
        return c;
    }
}
