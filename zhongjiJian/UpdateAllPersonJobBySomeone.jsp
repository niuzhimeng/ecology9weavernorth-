<%@ page import="com.weavernorth.zhongJiJian.ConnUtil" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 更新 人员信息查询中，业绩信息tab
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    RecordSet updateSet = new RecordSet();
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
    String updateSql = "insert into uf_perjob(ryid, xmmc, gwmc) values (?, ?, ?)";
    Map<String, String> colMap = ConnUtil.colMap;
    try {
        baseBean.writeLog("更新一人建模人员信息岗Start==" + xm);
        if (StringUtils.isBlank(xm)) {
            baseBean.writeLog("xm为空，不作操作");
            return;
        }

        synchronized (ConnUtil.class) {
            updateSet.executeUpdate("delete from uf_perjob where ryid = ?", xm);
            recordSet.executeQuery(selectSql, xm);
            List<String> list = new ArrayList<>();
            while (recordSet.next()) {
                String id = recordSet.getString("id"); // 自定义人员表id uf_ryzcxxb
                String xmid = recordSet.getString("xmid"); // 项目名称
                for (Map.Entry<String, String> entry : colMap.entrySet()) {
                    String curVal = recordSet.getString(entry.getKey());
                    if (id.equals(curVal)) {
                        list.add(entry.getValue());
                    }
                }

                String joinerStr = String.join(", ", list);
                // 插入或更新到 人员 - 岗位表
                updateSet.executeUpdate(updateSql,
                        id, xmid, joinerStr);
                list.clear();
            }
            baseBean.writeLog("更新一人建模人员信息岗End");
        }

        response.sendRedirect("/spa/cube/index.html#/main/cube/search?customid=151&hidetop=1&xm=" + xm);
    } catch (Exception e) {
        baseBean.writeLog("更新建模人员信息岗位异常： " + e);
    }

%>