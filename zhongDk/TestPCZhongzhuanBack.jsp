<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.weaverboot.frame.ioc.filter.util.RequestParamUtils" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.util.Map" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyRtxLogin" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page language="java" contentType="text/html; charset=gbk" %>
<%

    BaseBean baseBean = new BaseBean();
    try {
        Map<String, Object> requestMap = RequestParamUtils.request2Map(request);
        baseBean.writeLog("������ϵͳ������תҳ��start===" + JSONObject.toJSONString(requestMap));

    } catch (Exception e) {
        baseBean.writeLog("O������ϵͳ������תҳ���쳣�� " + e);
    }
%>

<%!

%>

