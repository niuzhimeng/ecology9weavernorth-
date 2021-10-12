<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    BaseBean baseBean = new BaseBean();
    try {
        baseBean.writeLog("主次账号交换Start");
        RecordSet recordSet = new RecordSet();
//        recordSet.executeUpdate("update hrmresource set accounttype = 1, belongto = 31 where id = 21");
//        recordSet.executeUpdate("update hrmresource set accounttype = 0, belongto = -1 where id = 31");

//        recordSet.executeUpdate("update hrmresource set accounttype = 0, belongto = -1 where id = 21");
//        recordSet.executeUpdate("update hrmresource set accounttype = 1, belongto = 21 where id = 31");
//
//        new ResourceComInfo().removeResourceCache();
    } catch (Exception e) {
        baseBean.writeLog("主次账号交换异常： " + e);
    }

%>



