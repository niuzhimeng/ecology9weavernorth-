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
    int MesResource = 1156; // 消息来源（见文档第四点补充 必填）
    BaseBean baseBean = new BaseBean();
    MessageType messageType = MessageType.newInstance(MesResource);

    Set<String> userIdList = new HashSet<>(); // 接收人id 必填
    userIdList.add("21");
    String title = "标题: " + TimeUtil.getCurrentTimeString(); // 标题
    String context = "内容"; // 内容
    String linkUrl = "http://www.baidu.com"; // PC端链接
    String linkMobileUrl = "移动端链接"; // 移动端链接
    try {
        MessageBean messageBean = Util_Message.createMessage(messageType, userIdList, title, context, linkUrl, linkMobileUrl);
        baseBean.writeLog("messageBean: " + JSONObject.toJSONString(messageBean));
        messageBean.setCreater(1);// 创建人id
        messageBean.setBizState("0");// 需要修改消息为已处理等状态时传入,表示消息最初状态为待处理
        messageBean.setTargetId(MesResource + "|" + messageBean.getTargetId()); //消息来源code +“|”+业务id需要修改消息为已处理等状态时传入
        Util_Message.store(messageBean);
    } catch (IOException e) {
        e.printStackTrace();
    }

%>




