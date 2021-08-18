<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    response.setContentType("application/json");
    //
    BaseBean baseBean = new BaseBean();

    Thread.sleep(2000);
    JSONArray jsonArray = new JSONArray();
    for (int i = 0; i < 5; i++) {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("key", i);
        jsonObject.put("requestName", "党建活动测试流程标题" + i);
        jsonObject.put("createDate", TimeUtil.getCurrentDateString());
        jsonArray.add(jsonObject);
    }

    JSONObject jsonObject = new JSONObject();
    jsonObject.put("myStatus", true);
    jsonObject.put("myData", jsonArray);

    baseBean.writeLog("返回json数据： " + jsonObject.toJSONString());
    out.clear();
    out.print(jsonObject);
%>