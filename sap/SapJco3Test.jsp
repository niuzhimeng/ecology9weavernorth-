<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="java.util.zip.ZipFile" %>
<%@ page import="com.weavernorth.huamei.sap.HuaMeiPoolThree_zdy" %>
<%@ page import="com.sap.conn.jco.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // sapjco3 自定义配置文件地址
    try {
        BaseBean baseBean = new BaseBean();
        JCoDestination jCoDestination = HuaMeiPoolThree_zdy.getJCoDestination();
        jCoDestination.ping();
        baseBean.writeLog("通=====");

        JCoFunction function = jCoDestination.getRepository().getFunction("ZFM_FI004");
        baseBean.writeLog("获取函数完成===== " + function);

        JCoTable tTab = function.getTableParameterList().getTable("T_TAB");
        baseBean.writeLog(tTab);
        JCoFieldIterator fieldIterator = tTab.getFieldIterator();
        while (fieldIterator.hasNextField()) {
            JCoField jCoField = fieldIterator.nextField();
            baseBean.writeLog(jCoField.getName() + " : " + jCoField.getDescription());
        }
    } catch (JCoException e) {
        e.printStackTrace();
    }

%>