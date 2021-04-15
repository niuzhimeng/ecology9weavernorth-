<%@ page import="weaver.general.BaseBean" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyRtxLogin" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    BaseBean baseBean = new BaseBean();

    String url = "https://demo.elearnplus.com/learnking";
    try {
        // 使用u=用户名+d=时间戳+n=随机字符串组+key=Eebiep2Aec4vahl3 组成数组；
        String loginId = user.getLoginid();
        baseBean.writeLog("单点培训平台开始=================== " + loginId);
        // 随机字符串
        String n = org.apache.commons.lang3.RandomStringUtils.random(8, "utf-8");
        // 双方约定密钥，传参时不传
        String key = "qeCakc2PUOjn5lHg";
        // 时间戳
        long d = System.currentTimeMillis();
        String[] str = new String[]{"key=" + key, "u=" + loginId, "d=" + d, "n=" + n};
        // 排序 升序
        Arrays.sort(str);
        // 拼接成字符串
        StringBuilder params = new StringBuilder();
        for (String s : str) {
            params.append(s).append("&");
        }
        // 去掉最后一个&
        String queryString = params.toString().substring(0, params.toString().length() - 1);
        //md5Hex 加密
        String sign = cn.hutool.crypto.digest.DigestUtil.md5Hex(queryString, "utf-8");
        url += "?u=" + loginId + "&d=" + d + "&n=" + n + "&s=" + sign;

        baseBean.writeLog("跳转单点地址： " + url);
        response.sendRedirect(url);
    } catch (Exception e) {
        baseBean.writeLog("单点培训平台异常： " + e);
    }
%>


