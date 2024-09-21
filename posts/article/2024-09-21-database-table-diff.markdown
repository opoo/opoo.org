---
layout: post
title: 数据库大表数据比对
date: '2024-09-21 20:00'
comments: true
published: true
description: "本文描述如何对数据库的两个表结构相同的大表进行数据比对，包括纯 SQL 和 JDBC 的实现。"
excerpt: "本文描述如何对数据库的两个表结构相同的大表进行数据比对，包括纯 SQL 和 JDBC 的实现。"
categories: [Java]
tags: [MySQL, 数据库, 数据比对]
url: '/2024/database-table-diff/'
---

日常数据维护中，在对数据表进行复制或者迁移后，通常需要进行比对，以确保复制或着迁移的正确性。本文展示两种数据对比方法：SQL比对即JDBC编程比对。

## 一、使用 SQL 实现数据比对
适合同库不同的表，支持跨 Schema。假设有 a 和 b 两个表：

1、查询主键一致但其它字段不一致的记录（JOIN 或 INNER JOIN）
```sql
select a.*, b.* from a
join b on a.id=b.id
where a.col1 <> b.col1 or a.col2 <> b.col2 or ...
```
2、查询A表有B表没有的记录（LEFT JOIN）
```sql
select a.* from a
left join b on a.id=b.id
where b.id is null
```
3、查询B表有A表没有的记录（RIGHT JOIN）
```sql
select b.* from a
right join b on a.id=b.id
where a.id is null
```

## 二、使用 Java 操作 JDBC 实现数据比对
可同库比对，也可以跨库比对。

1、实施步骤
Step0: 设置3个集合（A表独有主键集合a、B表独有主键集合b、AB表都有但非主键不一致的主键集合ab），一个计数器c（记录完全一致的记录数量），用于记录比对结果。

Step1: 使用**流式查询**获得2个表查询结果的 ResultSet，例如 rs1（a表） 和 rs2（b表）。查询须按主键正序排列。

Step2: 对比的前置处理：rs1、 rs2 指向第一条记录。

Step3：记录比对：
- 如果 rs1 和 rs2 都为空，退出比对。
- 如果 rs1 为空，则 rs2 从当前起所有记录都记录在集合b中，退出对比。
- 如果 rs2 为空，则 rs1 从当前起所有记录都记录在集合a中，退出对比。
- 如果 rs1 的主键小于 rs2 的主键，则将 rs1 的主键记录在集合a中，rs1 指向下一条记录，rs2 不变，递归回调 Step3。
- 如果 rs2 的主键小于 rs1 的主键，则将 rs2 的主键记录在集合b中，rs2 指向下一条记录，rs1 不变，递归回调 Step3。
- 如果主键相同，则对比 rs1 和 rs2 的其余字段，全部一致则累加计数器c，任意字段不一致则将主键记录到集合ab中。最后，递归回调 Step3。

2、简单的示例代码如下
```java
package org.opoo.demos.tablediff;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.ConnectionCallback;
import org.springframework.jdbc.core.StatementCallback;
import org.springframework.jdbc.datasource.DataSourceUtils;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Slf4j
@SpringBootTest
class TableDiffTests {
    
    @Autowired
    private DataSource dataSource;

    @Test
    void test() throws SQLException {
        final String sql1 = "select * from a order by id";
        final String sql2 = "select * from b order by id";
        final Result result = new Result();
        // 不同数据源则支持跨库
        try (final Connection conn1 = DataSourceUtils.getConnection(dataSource);
             final Connection conn2 = DataSourceUtils.getConnection(dataSource);
             final Statement stmt1 = conn1.createStatement();
             final Statement stmt2 = conn2.createStatement()) {
            // MySQL 设置后底层为 ResultsetRowsStreaming
            stmt1.setFetchSize(Integer.MIN_VALUE);
            stmt2.setFetchSize(Integer.MIN_VALUE);
            
            try (final ResultSet rs1 = stmt1.executeQuery(sql1);
                 final ResultSet rs2 = stmt2.executeQuery(sql2)) {
                final Context context = new Context();
                boolean more;
                do {
                    more = compare(context, result, rs1, rs2);
                } while (more);
            }
        }

        log.info("比对结果：{}", result);
        Assertions.assertTrue(result.getMatchCount() > 0);
    }

    private boolean compare(Context context, Result result, ResultSet rs1, ResultSet rs2) throws SQLException {
        final Long id1 = get(context.getId1(), () -> getNextId(rs1));
        final Long id2 = get(context.getId2(), () -> getNextId(rs2));
        if (id1 == null && id2 == null) {
            return false;
        }

        log.debug("id1 = {}, id2 = {}", id1, id2);
        if (id1 == null) {
            // 只有id1是null，rs2剩下的全是b独有的，包括id2
            addRemainIds(id2, rs2, result.getIdsOnlyIn2());
            return false;
        }

        if (id2 == null) {
            // 只有id2是null，rs1剩下的全是a独有的，包括id1
            addRemainIds(id1, rs1, result.getIdsOnlyIn1());
            return false;
        }
        
        // 联合主键可扩展这个方法
        final int compareTo = id1.compareTo(id2);
        if (compareTo < 0) {
            // id1 还不够大，对不齐，保存并取下一个id1
            result.getIdsOnlyIn1().add(id1);
            context.set(null, id2);
        } else if (compareTo > 0) {
            // id2 还不够大，对不齐，保存并取下一个id2
            result.getIdsOnlyIn2().add(id2);
            context.set(id1, null);
        } else {
            // ID 是一样大的，则对比其它字段
            if (equals(rs1, rs2, id1)) {
                result.setMatchCount(result.getMatchCount() + 1);
            } else {
                result.getIdsMismatch().add(id1);
            }
            context.set(null, null);
        }
        return true;
    }

    private Long getNextId(ResultSet resultSet) throws SQLException {
        // 联合主键可扩展这个方法
        if (resultSet.next()) {
            return resultSet.getLong("id");
        }
        return null;
    }

    private void addRemainIds(Long id, ResultSet rs, List<Long> idsOnlyIn) throws SQLException {
        idsOnlyIn.add(id);
        while (rs.next()) {
            idsOnlyIn.add(rs.getLong("id"));
        }
    }

    private boolean equals(ResultSet rs1, ResultSet rs2, final Long id) throws SQLException {
        final String[] names = {"col1", "col2", "col3"};
        for (String name : names) {
            final String val1 = rs1.getString(name);
            final String var2 = rs2.getString(name);
            if (!Objects.equals(val1, var2)) {
                log.warn("[{}]的{}字段值不一致：{} <> {}", id, name, val1, var2);
                return false;
            }
        }
        return true;
    }

    private <T> T get(T t, SqlSupplier<T> supplier) throws SQLException {
        if (t != null) {
            return t;
        }

        return supplier.get();
    }

    @Data
    public static class Result {
        final private List<Long> idsOnlyIn1 = new ArrayList<>();
        final private List<Long> idsOnlyIn2 = new ArrayList<>();
        final private List<Long> idsMismatch = new ArrayList<>();
        private long matchCount = 0;
    }

    @Data
    public static class Context {
        private Long id1;
        private Long id2;
        public void set(Long id1, Long id2) {
            this.id1 = id1;
            this.id2 = id2;
        }
    }

    @FunctionalInterface
    public interface SqlSupplier<T> {
        T get() throws SQLException;
    }
}

```
