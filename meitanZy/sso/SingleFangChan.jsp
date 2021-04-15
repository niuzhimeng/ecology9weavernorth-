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
    String fcIp = "192.168.98.91"; // 房产系统ip

    String tokenUrl = "http://" + fcIp + "/rvhm/api/v1/user/login"; // 获取token的url
    String url = "http://" + fcIp + "/rvhm/api/v1/user/oalogin?userid=";
    try {
        int uid = user.getUID();
        baseBean.writeLog("单点房产系统开始===================");
        // 获取token
        String tokenUserId = "admin";
        String md5ofStr = new MD5().getMD5ofStr(tokenUserId).toLowerCase();

        Map<String, String> bodyMap = new HashMap<>();
        bodyMap.put("userid", tokenUserId);
        bodyMap.put("password", md5ofStr);

        String tokenReturn = MtHttpUtil.postKeyValue(tokenUrl, bodyMap);
        JSONObject tokenObj = JSONObject.parseObject(tokenReturn);
        if (!"0".equals(tokenObj.getString("code"))) {
            baseBean.writeLog("获取token异常： " + tokenReturn);
            return;
        }
        String tokenStr = tokenObj.getString("token");
        baseBean.writeLog("tokenStr: " + tokenStr);

        // 获取token完成=============
        recordSet.executeQuery("select workcode from hrmresource where id = ?", uid);
        recordSet.next();
        String workCode = recordSet.getString("workcode");
        url += workCode;

        Map<String, String> headerMap = new HashMap<>();
        headerMap.put("Authorization", tokenStr);

        String loginStr = MtHttpUtil.get(url, headerMap);
        baseBean.writeLog("房产系统返回json： " + loginStr);
        JSONObject returnObj = JSONObject.parseObject(loginStr);
        String code = returnObj.getString("code");
        if ("0".equals(code)) {
            String forwardUrl = returnObj.getJSONObject("data").getString("url");
            forwardUrl = forwardUrl.replace("regular-view.net", fcIp);
            baseBean.writeLog("跳转url： " + forwardUrl);
            response.sendRedirect(forwardUrl);
        } else {
            out.clear();
            out.print("房产系统单点认证失败: 工号： " + workCode);
            baseBean.writeLog("房产系统单点认证失败======");
        }
    } catch (Exception e) {
        baseBean.writeLog("单点房产系统异常： " + e);
    }
%>


