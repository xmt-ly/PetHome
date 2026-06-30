package com.pethome.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 用户 JavaBean
 *
 * 体现了 JavaBean 规范：
 * 1. 类必须是 public
 * 2. 拥有无参构造方法
 * 3. 属性为 private
 * 4. 提供 public 的 getter/setter 方法
 * 5. 实现 Serializable 接口（可用于 session 存储）
 */
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String username;
    private String password;
    private String nickname;
    private String email;
    private String phone;
    private String avatar;
    private int role;           // 0=普通用户, 1=管理员
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 无参构造方法
    public User() {
    }

    // 带参构造方法
    public User(int id, String username, String password, String nickname,
                String email, String phone, String avatar, int role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.nickname = nickname;
        this.email = email;
        this.phone = phone;
        this.avatar = avatar;
        this.role = role;
    }

    // --- Getter 和 Setter 方法 ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
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

    @Override
    public String toString() {
        return "User{id=" + id + ", username='" + username + "', nickname='" + nickname + "', role=" + role + "}";
    }
}
