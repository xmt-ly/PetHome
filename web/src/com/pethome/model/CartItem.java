package com.pethome.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 购物车项 JavaBean
 *
 * 用于在 HttpSession 中存储购物车数据
 * 不是数据库实体类，而是内存中的临时数据
 */
public class CartItem implements Serializable {

    private static final long serialVersionUID = 1L;

    private int productId;
    private String productName;
    private BigDecimal price;
    private String imageUrl;
    private int quantity;

    // 无参构造方法
    public CartItem() {
    }

    public CartItem(int productId, String productName, BigDecimal price,
                    String imageUrl, int quantity) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.imageUrl = imageUrl;
        this.quantity = quantity;
    }

    // --- Getter 和 Setter 方法 ---

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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    /**
     * 计算小计金额
     */
    public BigDecimal getSubtotal() {
        return price.multiply(BigDecimal.valueOf(quantity));
    }

    @Override
    public String toString() {
        return "CartItem{productId=" + productId + ", name='" + productName + "', qty=" + quantity + "}";
    }
}
