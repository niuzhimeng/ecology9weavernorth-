<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ include file="/systeminfo/init_wev8.jsp" %>--%>

<%
    BaseBean baseBean = new BaseBean();
    String time = (String) session.getAttribute("time");
    baseBean.writeLog("获取到session： " + time);
    if (StringUtils.isBlank(time)) {
        baseBean.writeLog("设置session===========");
        session.setAttribute("time", TimeUtil.getCurrentTimeString());
    }

%>

<script type="text/javascript">



