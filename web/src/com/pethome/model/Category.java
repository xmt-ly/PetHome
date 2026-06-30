package com.pethome.model;

import java.io.Serializable;

/**
 * 商品分类 JavaBean
 *
 * 对应数据库 t_category 表
 * 新增 icon（emoji）和 subcategories（子类目描述）字段
 */
public class Category implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private String icon;           // emoji 图标 (🍖 🎒 🎾 🛋️ ...)
    private String subcategories;  // 子类目描述 (主粮 · 零食 · 营养品)
    private int sortOrder;         // 排序序号

    // 无参构造
    public Category() {}

    // --- Getter 和 Setter ---

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public String getSubcategories() { return subcategories; }
    public void setSubcategories(String subcategories) { this.subcategories = subcategories; }

    public int getSortOrder() { return sortOrder; }
    public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }

    @Override
    public String toString() {
        return "Category{id=" + id + ", name='" + name + "', icon='" + icon + "'}";
    }
}
