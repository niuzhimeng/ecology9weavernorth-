<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.category.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    RecordSet updateSet = new RecordSet();
    try {
        new SubCategoryComInfo().removeMainCategoryCache();
        new SecCategoryComInfo().removeMainCategoryCache();
        new SecCategoryDocPropertiesComInfo().removeCache();
        new DocTreelistComInfo().removeGetDocListInfordCache();
        new MainCategoryComInfo().removeMainCategoryCache();

        out.clear();
        out.print("ok");
    } catch (Exception e) {
        baseBean.writeLog("mybatis获取对象异常： " + e);
    }

%>













