<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.weavernorth.zhongJiJian.UpdateContractMoney" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 更新 工程基本信息维护 显示模板中的 【工程合同变更后造价】
    BaseBean baseBean = new BaseBean();
    try {
        String htmcVal = request.getParameter("htmcVal");
        baseBean.writeLog("校准工程合同变更后造价Start: " + htmcVal);
        double newValue = UpdateContractMoney.updateMode(htmcVal);
        baseBean.writeLog("校准后金额: " + newValue);

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("newValue", newValue);

        out.clear();
        out.print(jsonObject.toJSONString());
    } catch (Exception e) {
        baseBean.writeLog("上传异常： " + e);
    }

%>