<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    // 单点回调接口
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("OA_SSO_YKB_BACK.jsp 回调接口执行--------------> " + TimeUtil.getCurrentTimeString());
    String token = request.getParameter("token");
    baseBean.writeLog("收到的token: " + token);

    RecordSet recordSet = new RecordSet();
    recordSet.execute("select userid from uf_sso_ykb where token = '" + token + "'");

    // OA系统登录名
    String userId = "";
    // 用户姓名
    String lastName = "";
    if (recordSet.next()) {
        userId = recordSet.getString("userid");
        RecordSet hrmSet = new RecordSet();
        hrmSet.executeQuery("select lastname from hrmresource where id = " + userId);
        if (hrmSet.next()) {
            lastName = hrmSet.getString("lastname");
        }
    }
    response.setContentType("application/json");
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("id", userId);
    jsonObject.put("lastName", lastName);

    baseBean.writeLog("返回json数据： " + jsonObject.toJSONString());
    out.clear();
    out.print(jsonObject);
%>