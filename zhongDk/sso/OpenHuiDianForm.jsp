<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
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

        // ��ѯpcurl��ַ
        String pcUrl = "";
        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("SELECT pcurlsrc FROM ofs_todo_data where id = ?", tododataid);
        if (recordSet.next()) {
            pcUrl = recordSet.getString("pcurlsrc");
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


