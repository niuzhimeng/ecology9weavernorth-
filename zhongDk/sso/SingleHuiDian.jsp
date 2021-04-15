<%@ page import="weaver.general.BaseBean" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyRtxLogin" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    BaseBean baseBean = new BaseBean();

    try {
        String str = "OA_HD_SSO";
        String loginId = user.getLoginid();
        long currentTimeMillis = System.currentTimeMillis();
        baseBean.writeLog("单点慧点系统开始=================== " + loginId);

        String url = "http://oa.cepec.com/indishare/wscenterforjk.nsf/agtlogin?openagent&url=http://oa.cepec.com&username=" + loginId +
                "&timestamp=" + currentTimeMillis + "&sign=" + new MD5().getMD5ofStr(loginId + str + currentTimeMillis);

        baseBean.writeLog("跳转单点地址： " + url);
        response.sendRedirect(url);
    } catch (Exception e) {
        baseBean.writeLog("单点慧点系统异常： " + e);
    }
%>


