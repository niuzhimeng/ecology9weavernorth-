<%@ page import="com.cloudstore.dev.api.bean.MessageBean" %>
<%@ page import="com.cloudstore.dev.api.bean.MessageType" %>
<%@ page import="com.cloudstore.dev.api.util.Util_Message" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ include file="/systeminfo/init_wev8.jsp" %>--%>

<%
    MessageBean messageBean = Util_Message.createMessage();
    messageBean.setUserList(new HashSet<>());//接收人id
    messageBean.setTargetId("1156|22");
    messageBean.setBizState("1"); //bizState 业务状态 待处理 0 已处理 1 已同意 2 已拒绝 3 已删除 27 已暂停 34 已撤销 35
    //messageBean.setMessageType(MessageType.newInstance(121));//消息来源code(传了代表code也做为修改时的条件，默认不传）
    try {
        Util_Message.updateBizState(messageBean);
    } catch (Exception e) {
        e.printStackTrace();
    }


%>




