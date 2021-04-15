<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyRtxLogin" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page language="java" contentType="text/html; charset=gbk" %>
<%

    BaseBean baseBean = new BaseBean();
    try {
        baseBean.writeLog("主数据web接口测试start");
        String strUrl = "http://10.120.4.21:8080/cidp/ws/intfsServiceWS";
        String sendXml = "<soapenv:Envelope\n" +
                "    xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"\n" +
                "    xmlns:int=\"http://www.meritit.com/ws/IntfsServiceWS\">\n" +
                "    <soapenv:Header/>\n" +
                "    <soapenv:Body>\n" +
                "        <int:importData>\n" +
                "            <int:modelCode>?</int:modelCode>\n" +
                "            <int:dataStr>?</int:dataStr>\n" +
                "            <int:dataType>?</int:dataType>\n" +
                "            <int:dataStatus>?</int:dataStatus>\n" +
                "            <int:userName>?</int:userName>\n" +
                "            <int:password>?</int:password>\n" +
                "        </int:importData>\n" +
                "    </soapenv:Body>\n" +
                "</soapenv:Envelope>";

        URL url = new URL(strUrl);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Host", "10.120.4.21:8080");
        connection.setRequestProperty("Content-Type", "text/xml;charset=UTF-8");
        connection.setRequestProperty("SOAPAction", "");
        connection.setRequestProperty("Content-Length", String.valueOf(sendXml.length()));
        connection.setDoInput(true);
        connection.setDoOutput(true);
        connection.setUseCaches(false);
        connection.setDefaultUseCaches(false);

        OutputStream outputStream = connection.getOutputStream();
        outputStream.write(sendXml.getBytes(StandardCharsets.UTF_8));
        outputStream.close();

        int responseCode = connection.getResponseCode();
        baseBean.writeLog("responseCode: " + responseCode);

        if (200 == responseCode) {
            InputStream inputStream = connection.getInputStream();
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8));
            StringBuilder stringBuilder = new StringBuilder();
            String str = "";
            while ((str = bufferedReader.readLine()) != null) {
                stringBuilder.append(str);
            }

            bufferedReader.close();
            String voucherReturn = stringBuilder.toString();
            baseBean.writeLog("主数据接口返回：" + voucherReturn);


        }
    } catch (Exception e) {
        baseBean.writeLog("主数据web接口测试异常： " + e);
    }
%>


