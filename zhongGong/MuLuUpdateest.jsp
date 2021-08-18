<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.conn.RecordSet" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    RecordSet updateSet = new RecordSet();
    try {
        recordSet.executeQuery("select * from zhonggong_mulu");
        int i = 1;
        while (recordSet.next()) {
            String code = recordSet.getString("code");
            updateSet.executeUpdate("update zhonggong_mulu set code = ? where code = ?", i, code);
            updateSet.executeUpdate("update zhonggong_mulu set parentCode = ? where parentCode = ?", i, code);
            i++;
        }

        out.clear();
        out.print("ok");
    } catch (Exception e) {
        baseBean.writeLog("mybatis获取对象异常： " + e);
    }

%>













