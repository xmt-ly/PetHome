package com.pethome.model;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 订单明细 JavaBean
 *
 * 对应数据库 t_order_item 表
 * 记录订单中每个商品的具体信息
 */
public class OrderItem implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private int orderId;
    private int productId;
    private String productName;     // 冗余存储，防止商品删除后订单失效
    private BigDecimal price;       // 购买时的单价
    private int quantity;           // 购买数量

    // 无参构造方法
    public OrderItem() {
    }

    public OrderItem(int productId, String productName, BigDecimal price, int quantity) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
    }

    // --- Getter 和 Setter 方法 ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    /**
     * 计算小计金额（非数据库字段，用于 JSP 页面显示）
     */
    public BigDecimal getSubtotal() {
        return price.multiply(BigDecimal.valueOf(quantity));
    }

    @Override
    public String toString() {
        return "OrderItem{productName='" + productName + "', quantity=" + quantity + ", price=" + price + "}";
    }
}
