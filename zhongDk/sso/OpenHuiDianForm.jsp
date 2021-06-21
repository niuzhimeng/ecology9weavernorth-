<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.ofs.manager.OfsTodoDataManagerNew" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyRtxLogin" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    /**
     * �򿪻۵����̱�
     */
    BaseBean baseBean = new BaseBean();

    try {
        String str = "OA_HD_SSO";
        String tododataid = request.getParameter("tododataid");
        String loginId = user.getLoginid();
        long currentTimeMillis = System.currentTimeMillis();
        baseBean.writeLog("�򿪻۵�ϵͳ��Start===================loginId=" + loginId + ", flowId=" + tododataid);

        JSONObject jsonObject = new JSONObject();
        // ��ѯpcurl��ַ
        String pcUrl = "";
        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("SELECT pcurlsrc, syscode, flowid, requestname, workflowname, " +
                "nodename, receiver FROM ofs_todo_data where id = ?", tododataid);
        if (recordSet.next()) {
            pcUrl = recordSet.getString("pcurlsrc");
            // �칹ϵͳ��ʶ
            jsonObject.put("syscode", Util.null2String(recordSet.getString("syscode")));
            // flowid
            jsonObject.put("flowid", Util.null2String(recordSet.getString("flowid")));
            // ���⣨��Ҫ��֮ǰ�Ĵ�����ͬ�����򲻺�ʹ��
            jsonObject.put("requestname", Util.null2String(recordSet.getString("requestname")));
            // ������������
            jsonObject.put("workflowname", Util.null2String(recordSet.getString("workflowname")));
            // �������ƣ��ڵ����ƣ�
            jsonObject.put("nodename", Util.null2String(recordSet.getString("nodename")));
            // �����ˣ�ԭֵ��
            jsonObject.put("receiver", Util.null2String(recordSet.getString("receiver")));
            jsonObject.put("receivets", String.valueOf(System.currentTimeMillis()));
            jsonObject.put("isremark", "2");
            jsonObject.put("viewtype", "1");
        }
        if (pcUrl.contains("&todoRead=1")) {
            baseBean.writeLog("�������̣���Ϊ�Ѱ�ִ��=== " + jsonObject.toJSONString());
            RecordSet recordSet1 = new RecordSet();
            recordSet1.executeUpdate("update ofs_todo_data set isremark = 2 where id = '" + tododataid + "'");
            OfsTodoDataManagerNew manager = new OfsTodoDataManagerNew();
            manager.setClientIp("10.120.4.11");
            String s = manager.receiveRequestInfoByJson(jsonObject.toJSONString());
            baseBean.writeLog("���Ѱ����� " + s);
        }

        pcUrl += "&username=" + loginId + "&timestamp=" + currentTimeMillis + "&sign=" +
                new MD5().getMD5ofStr(loginId + str + currentTimeMillis);

        String endUrl = "http://oa.cepec.com/indishare/wscenterforjk.nsf/agtlogin?openagent&url=" + pcUrl;
        baseBean.writeLog("�򿪱���ת��ַ�� " + endUrl);
        response.sendRedirect(endUrl);
    } catch (Exception e) {
        baseBean.writeLog("����۵�ϵͳ�쳣�� " + e);
    }
%>


