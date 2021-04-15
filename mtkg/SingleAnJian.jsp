<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.IvParameterSpec" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.util.Base64" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("OA单点安全监管系统Start================");

    String url = "http://101.37.168.17/ccteg/authority/#/login?encryptedData="; // 安全监管系统单点地址
    String secretKey = "Password12345678";

    String sysid = Util.null2String(request.getParameter("id"));// 系统标识
    baseBean.writeLog("系统标志：" + sysid + " userId: " + user.getUID());
    RecordSet recordSet = new RecordSet();
    String username = "";
    String password = "";

    recordSet.executeQuery("select account,password from outter_account where sysid='" + sysid + "' and userid='" + user.getUID() + "'");
    if (recordSet.next()) {
        username = recordSet.getString("account");
        password = recordSet.getString("password");
        baseBean.writeLog("username: " + username + ", password: " + password);
        if (!"".equals(username) || !"".equals(password)) {
            password = SecurityHelper.decryptSimple(password);
        }
    }
    if ("".equals(username) || "".equals(password)) {
        // 没有维护安全监管系统的用户名密码，跳转到密码维护界面
        response.sendRedirect("/spa/integration/static4engine/engine.html#/main/integration/accountSetting");
    } else {
        String jsonStr = "{\"MenuType\":null,\"LoginName\":\"" + username + "\",\"Password\":\"" + password + "\"}";
        // aes加密
        String encryptStr = encrypt(jsonStr, secretKey);
        encryptStr = URLEncoder.encode(encryptStr, "utf-8");
        url += encryptStr + "&redirecturl=/ccteg";
        baseBean.writeLog("跳转地址： " + url);
        response.sendRedirect(url);
    }
    baseBean.writeLog("OA单点安全监管系统End================");
%>


<%!
    public String encrypt(String src, String key) {
        byte[] rgbIV = {49, 99, 105, 53, 99, 114, 110, 100, 97, 54, 111, 106, 122, 103, 116, 114};
        try {
            // 加密
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            IvParameterSpec iv = new IvParameterSpec(rgbIV);
            cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "AES"), iv);
            byte[] result = cipher.doFinal(src.getBytes());

            return Base64.getEncoder().encodeToString(result); //通过Base64转码返回
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
%>