package com.pethome.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 订单 JavaBean
 *
 * 对应数据库 t_order 表
 * 包含该订单的所有订单明细（一对多关系）
 */
public class Order implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String orderNo;             // 订单编号
    private int userId;
    private String username;            // 用户名（关联查询）
    private BigDecimal totalAmount;
    private int status;                 // 0=待付款, 1=已付款, 2=已发货, 3=已完成, 4=已取消
    private String statusText;          // 状态中文描述（非数据库字段）
    private String address;
    private String phone;
    private String receiver;
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 一对多：订单包含的明细列表（非数据库字段）
    private List<OrderItem> items;

    // 无参构造方法
    public Order() {
    }

    // --- Getter 和 Setter 方法 ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    /**
     * 获取状态的中文描述（JSP 页面显示用）
     */
    public String getStatusText() {
        switch (this.status) {
            case 0: return "待付款";
            case 1: return "已付款";
            case 2: return "已发货";
            case 3: return "已完成";
            case 4: return "已取消";
            default: return "未知";
        }
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getReceiver() {
        return receiver;
    }

    public void setReceiver(String receiver) {
        this.receiver = receiver;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    @Override
    public String toString() {
        return "Order{id=" + id + ", orderNo='" + orderNo + "', status=" + status + ", total=" + totalAmount + "}";
    }
}
