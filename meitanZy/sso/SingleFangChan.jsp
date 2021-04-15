<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.weavernorth.meitanzy.util.MtHttpUtil" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyRtxLogin" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%

    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    String fcIp = "192.168.98.91"; // ����ϵͳip

    String tokenUrl = "http://" + fcIp + "/rvhm/api/v1/user/login"; // ��ȡtoken��url
    String url = "http://" + fcIp + "/rvhm/api/v1/user/oalogin?userid=";
    try {
        int uid = user.getUID();
        baseBean.writeLog("���㷿��ϵͳ��ʼ===================");
        // ��ȡtoken
        String tokenUserId = "admin";
        String md5ofStr = new MD5().getMD5ofStr(tokenUserId).toLowerCase();

        Map<String, String> bodyMap = new HashMap<>();
        bodyMap.put("userid", tokenUserId);
        bodyMap.put("password", md5ofStr);

        String tokenReturn = MtHttpUtil.postKeyValue(tokenUrl, bodyMap);
        JSONObject tokenObj = JSONObject.parseObject(tokenReturn);
        if (!"0".equals(tokenObj.getString("code"))) {
            baseBean.writeLog("��ȡtoken�쳣�� " + tokenReturn);
            return;
        }
        String tokenStr = tokenObj.getString("token");
        baseBean.writeLog("tokenStr: " + tokenStr);

        // ��ȡtoken���=============
        recordSet.executeQuery("select workcode from hrmresource where id = ?", uid);
        recordSet.next();
        String workCode = recordSet.getString("workcode");
        url += workCode;

        Map<String, String> headerMap = new HashMap<>();
        headerMap.put("Authorization", tokenStr);

        String loginStr = MtHttpUtil.get(url, headerMap);
        baseBean.writeLog("����ϵͳ����json�� " + loginStr);
        JSONObject returnObj = JSONObject.parseObject(loginStr);
        String code = returnObj.getString("code");
        if ("0".equals(code)) {
            String forwardUrl = returnObj.getJSONObject("data").getString("url");
            forwardUrl = forwardUrl.replace("regular-view.net", fcIp);
            baseBean.writeLog("��תurl�� " + forwardUrl);
            response.sendRedirect(forwardUrl);
        } else {
            out.clear();
            out.print("����ϵͳ������֤ʧ��: ���ţ� " + workCode);
            baseBean.writeLog("����ϵͳ������֤ʧ��======");
        }
    } catch (Exception e) {
        baseBean.writeLog("���㷿��ϵͳ�쳣�� " + e);
    }
%>


