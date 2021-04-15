<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("OA单点帆软系统Start================");

    // 帆软系统单点地址
    String url = "http://124.207.154.86:8080/webroot/decision/url/ssoLogin";

    RecordSet recordSet = new RecordSet();
    String username = "";
    String password = "";
    recordSet.executeQuery("select loginid, password from hrmresource where id = '" + user.getUID() + "'");
    if (recordSet.next()) {
        username = recordSet.getString("loginid");
        password = Util.null2String(recordSet.getString("password")).toLowerCase();
        baseBean.writeLog("username: " + username + ", password: " + password);
    }

    url += "?userName=" + username + "&psd=" + password;
    baseBean.writeLog("跳转地址： " + url);
    response.sendRedirect(url);

    baseBean.writeLog("OA单点帆软系统End================");
%>
