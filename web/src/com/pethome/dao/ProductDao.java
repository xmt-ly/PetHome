package com.pethome.dao;

import com.pethome.model.Product;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * 商品数据访问对象
 *
 * 实现商品模块的完整 CRUD 操作
 */
public class ProductDao extends BaseDao<Product> {

    /**
     * 查询销量最高的 Top N 商品（首页精选推荐用）
     */
    public List<Product> findTopBySales(int limit) {
        String sql = "SELECT p.*, c.name AS category_name "
                + "FROM t_product p LEFT JOIN t_category c ON p.category_id = c.id "
                + "WHERE p.status = 1 ORDER BY p.sales DESC LIMIT ?";
        return queryForList(sql, limit);
    }

    /**
     * 查询所有商品（管理后台用，按 ID 正序）
     */
    public List<Product> findAll() {
        String sql = "SELECT p.*, c.name AS category_name "
                + "FROM t_product p LEFT JOIN t_category c ON p.category_id = c.id "
                + "ORDER BY p.id ASC";
        return queryForList(sql);
    }

    /**
     * 分页查询上架商品
     */
    public List<Product> findPage(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT p.*, c.name AS category_name "
                + "FROM t_product p LEFT JOIN t_category c ON p.category_id = c.id "
                + "WHERE p.status = 1 ORDER BY p.created_at DESC LIMIT ?, ?";
        return queryForList(sql, offset, pageSize);
    }

    /**
     * 根据 ID 查询商品
     */
    public Product findById(int id) {
        String sql = "SELECT p.*, c.name AS category_name "
                + "FROM t_product p LEFT JOIN t_category c ON p.category_id = c.id "
                + "WHERE p.id = ?";
        return queryForObject(sql, id);
    }

    /**
     * 根据分类 ID 查询商品
     */
    public List<Product> findByCategoryId(int categoryId) {
        String sql = "SELECT p.*, c.name AS category_name "
                + "FROM t_product p LEFT JOIN t_category c ON p.category_id = c.id "
                + "WHERE p.status = 1 AND p.category_id = ? ORDER BY p.sales DESC";
        return queryForList(sql, categoryId);
    }

    /**
     * 关键字搜索商品（模糊查询）
     */
    public List<Product> search(String keyword) {
        String sql = "SELECT p.*, c.name AS category_name "
                + "FROM t_product p LEFT JOIN t_category c ON p.category_id = c.id "
                + "WHERE p.status = 1 AND (p.name LIKE ? OR p.brand LIKE ?) "
                + "ORDER BY p.sales DESC";
        String pattern = "%" + keyword + "%";
        return queryForList(sql, pattern, pattern);
    }

    /**
     * 新增商品（INSERT）
     */
    public int insert(Product product) {
        String sql = "INSERT INTO t_product (name, description, price, original_price, "
                + "image_url, category_id, brand, stock, tag, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return update(sql,
                product.getName(),
                product.getDescription(),
                product.getPrice(),
                product.getOriginalPrice(),
                product.getImageUrl(),
                product.getCategoryId(),
                product.getBrand(),
                product.getStock(),
                product.getTag(),
                product.getStatus());
    }

    /**
     * 更新商品信息（UPDATE）
     */
    public int update(Product product) {
        String sql = "UPDATE t_product SET name = ?, description = ?, price = ?, "
                + "original_price = ?, image_url = ?, category_id = ?, brand = ?, "
                + "stock = ?, tag = ?, status = ? WHERE id = ?";
        return update(sql,
                product.getName(),
                product.getDescription(),
                product.getPrice(),
                product.getOriginalPrice(),
                product.getImageUrl(),
                product.getCategoryId(),
                product.getBrand(),
                product.getStock(),
                product.getTag(),
                product.getStatus(),
                product.getId());
    }

    /**
     * 删除商品（DELETE）
     */
    public int deleteById(int id) {
        String sql = "DELETE FROM t_product WHERE id = ?";
        return update(sql, id);
    }

    /**
     * 更新库存（下单时减少库存）
     */
    public int decreaseStock(int productId, int quantity) {
        String sql = "UPDATE t_product SET stock = stock - ?, sales = sales + ? WHERE id = ? AND stock >= ?";
        return update(sql, quantity, quantity, productId, quantity);
    }

    /**
     * 统计上架商品总数
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM t_product WHERE status = 1";
        return count(sql);
    }

    /**
     * 查询同分类推荐商品（排除自身）
     */
    public List<Product> findRelated(int productId, int categoryId, int limit) {
        String sql = "SELECT p.*, c.name AS category_name "
                + "FROM t_product p LEFT JOIN t_category c ON p.category_id = c.id "
                + "WHERE p.status = 1 AND p.category_id = ? AND p.id != ? "
                + "ORDER BY p.sales DESC LIMIT ?";
        return queryForList(sql, categoryId, productId, limit);
    }

    // ==================== ResultSet 映射 ====================

    @Override
    protected Product resultSetToModel(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setOriginalPrice(rs.getBigDecimal("original_price"));
        p.setImageUrl(rs.getString("image_url"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setBrand(rs.getString("brand"));
        p.setStock(rs.getInt("stock"));
        p.setSales(rs.getInt("sales"));
        p.setStatus(rs.getInt("status"));
        p.setTag(rs.getString("tag"));
        // 分类名称（LEFT JOIN 得到）
        p.setCategoryName(rs.getString("category_name"));
        if (rs.getTimestamp("created_at") != null) {
            p.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        if (rs.getTimestamp("updated_at") != null) {
            p.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        }
        return p;
    }
}
