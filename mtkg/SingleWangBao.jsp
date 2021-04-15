<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.IvParameterSpec" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.util.Base64" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("OA单点网报系统Start================");

    String url = "http://172.18.102.205:5200/router"; // 网报系统单点地址-正式
    //String url = "http://172.18.102.203:5200/router"; // 网报系统单点地址
    String secretKey = "secretKey";

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
        // 没有维护网报系统的用户名密码，跳转到密码维护界面
        response.sendRedirect("/spa/integration/static4engine/engine.html#/main/integration/accountSetting");
    } else {
        JSONObject jsonObject = new JSONObject(true);
        jsonObject.put("code", username);
        jsonObject.put("password", password);

        // aes加密
        String encryptStr = encrypt(jsonObject.toJSONString(), secretKey);
        url = url + "?languageCode=zh-CHS&tenantId=10000&routeParam=" + encryptStr;
        baseBean.writeLog("跳转地址： " + url);
        response.sendRedirect(url);
    }
    baseBean.writeLog("OA单点网报系统End================");
%>


<%!
    public static String encrypt(String stringIn, String key) {
        byte[] byteIn = stringIn.getBytes(StandardCharsets.UTF_8);
        byte[] byteOut = encrypt(byteIn, key);
        return Base64.getEncoder().encodeToString(byteOut);
    }

    public static byte[] encrypt(byte[] byteIn, String key) {
        byteIn = appendBottomZero(byteIn, 128);
        byte[] keyByte = getLegalKey(key);
        byte[] vector = getLegalIV(key);
        return encrypt(byteIn, keyByte, vector);
    }

    public static byte[] encrypt(byte[] byteIn, byte[] key, byte[] vector) {
        try {
            SecretKeySpec aesSecretKeySpec = new SecretKeySpec(key, "AES");
            Cipher cipher = Cipher.getInstance("AES/CBC/NoPadding");
            cipher.init(1, aesSecretKeySpec, new IvParameterSpec(vector));
            return cipher.doFinal(byteIn);
        } catch (Exception var6) {
            var6.printStackTrace();
            return null;
        }
    }

    private static byte[] getLegalKey(String key) {
        String resultString;
        int length = key.length() * 8;
        if (length <= 128) {
            resultString = String.format("%-" + 128 / 8 + "s", key);
        } else if (length <= 256) {
            length = ((length - 1) / 64 + 1) * 64;
            resultString = String.format("%-" + length / 8 + "s", key);
        } else {
            resultString = key.substring(0, 256 / 8);
        }
        return resultString.getBytes(StandardCharsets.UTF_8);
    }

    private static byte[] getLegalIV(String key) {
        if (key.length() > 128 / 8) {
            key = key.substring(0, 128 / 8);
        }
        return String.format("%-" + 128 / 8 + "s", key).getBytes(StandardCharsets.UTF_8);
    }

    private static byte[] appendBottomZero(byte[] bytes, int blockSize) {
        int length = bytes.length;
        blockSize /= 8;
        if (length % blockSize != 0) {
            length += blockSize - length % blockSize;
        }
        byte[] result = new byte[length];
        System.arraycopy(bytes, 0, result, 0, bytes.length);
        return result;
    }
%>