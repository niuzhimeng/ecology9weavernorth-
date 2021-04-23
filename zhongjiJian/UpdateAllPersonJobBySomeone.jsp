<%@ page import="com.weavernorth.zhongJiJian.ConnUtil" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 更新 人员信息查询中，业绩信息tab
    BaseBean baseBean = new BaseBean();
    String xm = request.getParameter("xm");
    String selectSql = "SELECT\n" +
            "\ta.id,\n" +
            "\tb.id xmid,\n" +
            "\tb.xmmc,\n" +
            "\tb.xmjlbaxmjlryxx,\n" +
            "\tb.bgxmjlryxx,\n" +
            "\tb.xmzxjlryxx,\n" +
            "\tb.bgxmzxjlryxx,\n" +
            "\tb.xmjsfzrryxx,\n" +
            "\tb.bgxmjsfzrryxx,\n" +
            "\tb.xmsjjsfzrryxx,\n" +
            "\tb.bgxmsjjsfzrryxx,\n" +
            "\tb.xmfjlryxx,\n" +
            "\tb.bgxmfjlryxx,\n" +
            "\tb.xmkzjl,\n" +
            "\tb.bgxmkzjl,\n" +
            "\tb.xmaqjl,\n" +
            "\tb.bgxmaqjl \n" +
            "FROM\n" +
            "\tuf_ryzcxxb a\n" +
            "\tINNER JOIN uf_gcjbxxwh b ON a.id = b.xmjlbaxmjlryxx \n" +
            "\tOR a.id = b.bgxmjlryxx \n" +
            "\tOR a.id = b.xmzxjlryxx \n" +
            "\tOR a.id = b.bgxmzxjlryxx \n" +
            "\tOR a.id = b.xmjsfzrryxx \n" +
            "\tOR a.id = b.bgxmjsfzrryxx \n" +
            "\tOR a.id = b.xmsjjsfzrryxx \n" +
            "\tOR a.id = b.bgxmsjjsfzrryxx \n" +
            "\tOR a.id = b.xmfjlryxx \n" +
            "\tOR a.id = b.bgxmfjlryxx \n" +
            "\tOR a.id = b.xmkzjl \n" +
            "\tOR a.id = b.bgxmkzjl \n" +
            "\tOR a.id = b.xmaqjl \n" +
            "\tOR a.id = b.bgxmaqjl \n" +
            "WHERE\n" +
            "\ta.id = ? \n" +
            "ORDER BY\n" +
            "\ta.id";

    Map<String, String> colMap = ConnUtil.colMap;
    try {
        baseBean.writeLog("更新一人建模人员信息岗Start==" + xm);
        if (StringUtils.isBlank(xm)) {
            baseBean.writeLog("xm为空，不作操作");
            return;
        }
        RecordSet recordSet = new RecordSet();
        RecordSet updateSet = new RecordSet();

        // 查询当前人已有的业绩数据条数
        List<String> idList = new ArrayList<>();
        recordSet.executeQuery("select id from uf_perjob where ryid = ?", xm);
        int oldCounts = recordSet.getCounts();
        baseBean.writeLog("已有数据条数： " + oldCounts);
        while (recordSet.next()) {
            idList.add(recordSet.getString("id"));
        }

        recordSet.executeQuery(selectSql, xm);
        int newCounts = recordSet.getCounts(); // 本次将要操作的数据条数
        baseBean.writeLog("本次操作数据条数： " + newCounts);

        Map<String, String> map = new HashMap<>();
        List<String> list = new ArrayList<>();
        while (recordSet.next()) {
            String xmid = recordSet.getString("xmid"); // 项目名称
            for (Map.Entry<String, String> entry : colMap.entrySet()) {
                String curVal = recordSet.getString(entry.getKey());
                if (xm.equals(curVal)) {
                    list.add(entry.getValue());
                }
            }
            String joinerStr = String.join(", ", list);
            map.put(xmid, joinerStr);
            list.clear();
        }

        if (oldCounts == newCounts) {
            // 总条数未变，执行更新
            int i = 0;
            for (Map.Entry<String, String> entry : map.entrySet()) {
                updateSet.executeUpdate("update uf_perjob set xmmc = ?, gwmc = ? where id = ?",
                        entry.getKey(), entry.getValue(), idList.get(i));
                i++;
            }
        } else {
            synchronized (ConnUtil.class) {
                long currentTimeMillis = System.currentTimeMillis();
                // 全部删除，新插入
                // 查询上次更新时间
                updateSet.executeQuery("select operate_time from uf_perjob where ryid = ?", xm);
                if (updateSet.next()) {
                    long operate_time = getLong(updateSet.getString("operate_time"));
                    if (currentTimeMillis - operate_time > 3000) {
                        insert(xm, map);
                    }
                } else {
                    insert(xm, map);
                }
            }
        }
        baseBean.writeLog("更新一人建模人员信息岗End");

        response.sendRedirect("/spa/cube/index.html#/main/cube/search?customid=151&hidetop=1&xm=" + xm);
    } catch (Exception e) {
        baseBean.writeLog("更新建模人员信息岗位异常： " + e);
    }

%>

<%!

    public void insert(String xm, Map<String, String> map) {
        long currentTimeMillis = System.currentTimeMillis();
        new BaseBean().writeLog("当前时间戳： " + currentTimeMillis);
        RecordSet updateSet = new RecordSet();
        updateSet.executeUpdate("delete from uf_perjob where ryid = ?", xm);
        // 插入或更新到 人员 - 岗位表
        for (Map.Entry<String, String> entry : map.entrySet()) {
            updateSet.executeUpdate("insert into uf_perjob(ryid, xmmc, gwmc, operate_time) values (?, ?, ?, '" + currentTimeMillis + "')",
                    xm, entry.getKey(), entry.getValue());
        }
    }

    public long getLong(String s) {
        try {
            return Long.parseLong(s);
        } catch (Exception e) {
            return 0;
        }
    }
%>