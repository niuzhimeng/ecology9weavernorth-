<%@ page import="weaver.general.BaseBean" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyRtxLogin" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    BaseBean baseBean = new BaseBean();

    String url = "https://demo.elearnplus.com/learnking";
    try {
        // ʹ��u=�û���+d=ʱ���+n=����ַ�����+key=Eebiep2Aec4vahl3 ������飻
        String loginId = user.getLoginid();
        baseBean.writeLog("������ѵƽ̨��ʼ=================== " + loginId);
        // ����ַ���
        String n = org.apache.commons.lang3.RandomStringUtils.random(8, "utf-8");
        // ˫��Լ����Կ������ʱ����
        String key = "qeCakc2PUOjn5lHg";
        // ʱ���
        long d = System.currentTimeMillis();
        String[] str = new String[]{"key=" + key, "u=" + loginId, "d=" + d, "n=" + n};
        // ���� ����
        Arrays.sort(str);
        // ƴ�ӳ��ַ���
        StringBuilder params = new StringBuilder();
        for (String s : str) {
            params.append(s).append("&");
        }
        // ȥ�����һ��&
        String queryString = params.toString().substring(0, params.toString().length() - 1);
        //md5Hex ����
        String sign = cn.hutool.crypto.digest.DigestUtil.md5Hex(queryString, "utf-8");
        url += "?u=" + loginId + "&d=" + d + "&n=" + n + "&s=" + sign;

        baseBean.writeLog("��ת�����ַ�� " + url);
        response.sendRedirect(url);
    } catch (Exception e) {
        baseBean.writeLog("������ѵƽ̨�쳣�� " + e);
    }
%>


