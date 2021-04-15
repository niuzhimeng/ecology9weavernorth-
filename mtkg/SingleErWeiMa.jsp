<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.KeyGenerator" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("OA单点二维码系统Start================");

    String url = "http://119.40.55.125:8001/groupcgi/"; // 二维码系统单点地址
    String secretKey = "1234567890abcdef";

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
        // 没有维护二维码系统的用户名密码，跳转到密码维护界面
        response.sendRedirect("/spa/integration/static4engine/engine.html#/main/integration/accountSetting");
    } else {
        JSONObject jsonObject = new JSONObject(true);
        jsonObject.put("id", username);
        jsonObject.put("password", password);

        // aes加密
        String encryptStr = aesEncrypt(jsonObject.toJSONString(), secretKey);
        //encryptStr = URLEncoder.encode(encryptStr, "utf-8");
        url = url + "?redirecturl=http%3A%2F%2F119.40.55.125:8001%2F&routeParam=" + encryptStr;
        baseBean.writeLog("跳转地址： " + url);
        response.sendRedirect(url);
    }
    baseBean.writeLog("OA单点二维码系统End================");
%>


<%!
    /**
     * base 64 encode
     *
     * @param bytes 待编码的byte[]
     * @return 编码后的base 64 code
     */
    private static String base64Encode(byte[] bytes) {
        return org.apache.commons.codec.binary.Base64.encodeBase64String(bytes);
    }

    /**
     * AES加密
     *
     * @param content    待加密的内容
     * @param encryptKey 加密密钥
     * @return 加密后的byte[]
     */
    private static byte[] aesEncryptToBytes(String content, String encryptKey) throws Exception {
        KeyGenerator kgen = KeyGenerator.getInstance("AES");
        kgen.init(128);
        Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(encryptKey.getBytes(), "AES"));

        return cipher.doFinal(content.getBytes("utf-8"));
    }


    /**
     * AES加密为base 64 code
     *
     * @param content    待加密的内容
     * @param encryptKey 加密密钥
     * @return 加密后的base 64 code
     */
    private static String aesEncrypt(String content, String encryptKey) {
        try {
            return base64Encode(aesEncryptToBytes(content, encryptKey));
        } catch (Exception e) {
            new BaseBean().writeLog("单点二维码系统aes加密异常： " + e);
        }
        return "";
    }

%>