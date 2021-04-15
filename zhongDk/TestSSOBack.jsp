<%@ page import="okhttp3.*" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyRtxLogin" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page language="java" contentType="text/html; charset=gbk" %>
<%

    BaseBean baseBean = new BaseBean();
    try {
        baseBean.writeLog("OA单点标准接口start");
        Map<String, String> body = new HashMap<>();
        body.put("appid", "HD");
        body.put("loginid", "tangwy");
        String token = okPostBodyHeader("http://127.0.0.1:8080/ssologin/getToken", body, null);
        baseBean.writeLog("打开首页： " + "http://localhost:8080/wui/index.html?ssoToken=" + token + "#/main");
        baseBean.writeLog("打开流程： " + "http://localhost:8080/spa/workflow/static4form/index.html?ssoToken=" + token + "#/main/workflow/req?requestid=305305");
        baseBean.writeLog("打开待办： " + "http://localhost:8080/wui/index.html?ssoToken=" + token + "#/main/workflow/listDoing");
    } catch (Exception e) {
        baseBean.writeLog("OA单点标准接口测试异常： " + e);
    }
%>

<%!
    public static String okPostBodyHeader(String url, Map<String, String> body, Map<String, String> herder) {
        OkHttpClient okHttpClient = new OkHttpClient();
        FormBody.Builder bodyBuilder = new FormBody.Builder();
        if (body != null) {
            body.forEach(bodyBuilder::add);
        }

        Request.Builder builder = new Request.Builder()
                .url(url)
                .post(bodyBuilder.build());
        if (herder != null) {
            herder.forEach(builder::header);
        }

        Request request = builder.build();

        Call call = okHttpClient.newCall(request);
        String returnStr = "";
        try {
            //同步调用,返回Response,会抛出IO异常
            Response response = call.execute();
            returnStr = response.body().string();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return returnStr;
    }
%>

