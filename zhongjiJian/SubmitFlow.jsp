<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.workflow.webservices.WorkflowRequestInfo" %>
<%@ page import="weaver.workflow.webservices.WorkflowServiceImpl" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyRtxLogin" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %>

<%
    response.setHeader("Content-Type", "application/json;charset=UTF-8");
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    RecordSet updateSet = new RecordSet();
    WorkflowServiceImpl workflowService = new WorkflowServiceImpl();
    WorkflowRequestInfo workflowRequestInfo = new WorkflowRequestInfo();

    String ids = request.getParameter("ids"); // 查询列表勾选的id
    int userId = Integer.parseInt(request.getParameter("userid"));
    try {
        baseBean.writeLog("批量提交流程Start, 接收前台参数= " + ids);
        if (ids.endsWith(",")) {
            ids = ids.substring(0, ids.length() - 1);
        }
        // 查询数据id对应的requestId 去重
        List<String> requestIdList = new ArrayList<>();
        recordSet.executeQuery("select distinct qqid from uf_yhxxb where id in (" + ids + ")");
        while (recordSet.next()) {
            requestIdList.add(recordSet.getString("qqid"));
        }

        // requestId 转为逗号分隔的字符串
        StringJoiner stringJoiner = new StringJoiner(",");
        requestIdList.forEach(stringJoiner::add);

        // 查询每个requestId与对应条数 - 标准
        Map<String, Integer> requestMap = new HashMap<>();
        recordSet.executeQuery("select qqid, count(*) mycount from uf_yhxxb where qqid in (" + stringJoiner.toString() + ") group by qqid");
        while (recordSet.next()) {
            requestMap.put(recordSet.getString("qqid"), recordSet.getInt("mycount"));
        }
        baseBean.writeLog("requestId-对应条数map： " + JSONObject.toJSONString(requestMap));

        // 查询每个requestId与对应条数 - 前台传过来的
        Map<String, Integer> requestMap_front = new HashMap<>();
        recordSet.executeQuery("select id, qqid from uf_yhxxb where id in (" + ids + ")");
        while (recordSet.next()) {
            String qqid = recordSet.getString("qqid");
            // requestMap_front.merge(qqid, 1, (old, newVal)-> old + 1);
            requestMap_front.merge(qqid, 1, Integer::sum);
        }
        baseBean.writeLog("requestId-对应条数map_front： " + JSONObject.toJSONString(requestMap_front));

        // 筛选前端未全部勾选的requestId
        List<String> lackList = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : requestMap_front.entrySet()) {
            if (entry.getValue() < requestMap.get(entry.getKey())) {
                lackList.add(entry.getKey());
            }
        }
        baseBean.writeLog("未勾选全部的集合： " + JSONObject.toJSONString(lackList));
        if (lackList.size() > 0) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("ifLack", true);
            jsonObject.put("lack_message", String.join(",", lackList));

            out.clear();
            out.print(jsonObject.toJSONString());
            return;
        }

        // 提交流程
        // 提交失败的集合
        List<String> errList = new ArrayList<>();
        boolean ifFlush = false; // 前端页面是否刷新
        for (Map.Entry<String, Integer> entry : requestMap_front.entrySet()) {
            String result = workflowService.submitWorkflowRequest(workflowRequestInfo, Integer.parseInt(entry.getKey()), userId, "submit", "");
            baseBean.writeLog("推送结果： " + entry.getKey() + ": " + result);
            if ("success".equals(result)) {
                ifFlush = true;
                updateSet.executeUpdate("update uf_yhxxb set zt = 0 where qqid = '" + entry.getKey() + "'");
            } else {
                // 提交失败
                errList.add(entry.getKey());
            }
        }

        baseBean.writeLog("提交失败的集合： " + JSONObject.toJSONString(errList));

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("ifFlush", ifFlush);

        if (errList.size() > 0) {
            jsonObject.put("ifErr", true);
            jsonObject.put("err_message", String.join(",", errList));
        } else {
            jsonObject.put("ifErr", false);
        }

        out.clear();
        out.print(jsonObject.toJSONString());

    } catch (Exception e) {
        baseBean.writeLog("批量提交流程异常： " + e);
    }
%>

<%!
    /**
     * 根据requestId集合 查询requestName
     */
    private String getRequestNameByRequestId(List<String> requestIdList) {
        if (requestIdList.size() <= 0) {
            return "";
        }

        StringJoiner returnJoiner = new StringJoiner(",");

        StringJoiner stringJoiner = new StringJoiner(",");
        requestIdList.forEach(stringJoiner::add);
        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("select requestnamenew from workflow_requestbase where requestid in (" + stringJoiner.toString() + ")");
        while (recordSet.next()) {
            returnJoiner.add(recordSet.getString("requestnamenew"));
        }

        return returnJoiner.toString();
    }
%>
