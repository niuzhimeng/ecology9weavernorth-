<%@ page import="weaver.general.BaseBean" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyRtxLogin" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    BaseBean baseBean = new BaseBean();

    String url = "http://10.120.4.21:8080/cidp/index_menu.jsp";
    try {
        String currentDate = TimeUtil.getCurrentDateString();
        String loginId = user.getLoginid();
        baseBean.writeLog("单点主数据系统开始=================== " + loginId);
        String token = new MD5().getMD5ofStr(currentDate + loginId).toLowerCase();
        url += "?token=" + token + "&userId=" + loginId;

        baseBean.writeLog("跳转单点地址： " + url);
        response.sendRedirect(url);
    } catch (Exception e) {
        baseBean.writeLog("单点主数据系统异常： " + e);
    }
%>


