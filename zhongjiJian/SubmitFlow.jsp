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

    String ids = request.getParameter("ids"); // ��ѯ�б�ѡ��id
    int userId = Integer.parseInt(request.getParameter("userid"));
    try {
        baseBean.writeLog("�����ύ����Start, ����ǰ̨����= " + ids);
        if (ids.endsWith(",")) {
            ids = ids.substring(0, ids.length() - 1);
        }
        // ��ѯ����id��Ӧ��requestId ȥ��
        List<String> requestIdList = new ArrayList<>();
        recordSet.executeQuery("select distinct qqid from uf_yhxxb where id in (" + ids + ")");
        while (recordSet.next()) {
            requestIdList.add(recordSet.getString("qqid"));
        }

        // requestId תΪ���ŷָ����ַ���
        StringJoiner stringJoiner = new StringJoiner(",");
        requestIdList.forEach(stringJoiner::add);

        // ��ѯÿ��requestId���Ӧ���� - ��׼
        Map<String, Integer> requestMap = new HashMap<>();
        recordSet.executeQuery("select qqid, count(*) mycount from uf_yhxxb where qqid in (" + stringJoiner.toString() + ") group by qqid");
        while (recordSet.next()) {
            requestMap.put(recordSet.getString("qqid"), recordSet.getInt("mycount"));
        }
        baseBean.writeLog("requestId-��Ӧ����map�� " + JSONObject.toJSONString(requestMap));

        // ��ѯÿ��requestId���Ӧ���� - ǰ̨��������
        Map<String, Integer> requestMap_front = new HashMap<>();
        recordSet.executeQuery("select id, qqid from uf_yhxxb where id in (" + ids + ")");
        while (recordSet.next()) {
            String qqid = recordSet.getString("qqid");
            // requestMap_front.merge(qqid, 1, (old, newVal)-> old + 1);
            requestMap_front.merge(qqid, 1, Integer::sum);
        }
        baseBean.writeLog("requestId-��Ӧ����map_front�� " + JSONObject.toJSONString(requestMap_front));

        // ɸѡǰ��δȫ����ѡ��requestId
        List<String> lackList = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : requestMap_front.entrySet()) {
            if (entry.getValue() < requestMap.get(entry.getKey())) {
                lackList.add(entry.getKey());
            }
        }
        baseBean.writeLog("δ��ѡȫ���ļ��ϣ� " + JSONObject.toJSONString(lackList));
        if (lackList.size() > 0) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("ifLack", true);
            jsonObject.put("lack_message", String.join(",", lackList));

            out.clear();
            out.print(jsonObject.toJSONString());
            return;
        }

        // �ύ����
        // �ύʧ�ܵļ���
        List<String> errList = new ArrayList<>();
        boolean ifFlush = false; // ǰ��ҳ���Ƿ�ˢ��
        for (Map.Entry<String, Integer> entry : requestMap_front.entrySet()) {
            String result = workflowService.submitWorkflowRequest(workflowRequestInfo, Integer.parseInt(entry.getKey()), userId, "submit", "");
            baseBean.writeLog("���ͽ���� " + entry.getKey() + ": " + result);
            if ("success".equals(result)) {
                ifFlush = true;
                updateSet.executeUpdate("update uf_yhxxb set zt = 0 where qqid = '" + entry.getKey() + "'");
            } else {
                // �ύʧ��
                errList.add(entry.getKey());
            }
        }

        baseBean.writeLog("�ύʧ�ܵļ��ϣ� " + JSONObject.toJSONString(errList));

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
        baseBean.writeLog("�����ύ�����쳣�� " + e);
    }
%>

<%!
    /**
     * ����requestId���� ��ѯrequestName
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
