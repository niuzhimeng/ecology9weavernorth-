<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<%@ page import="org.apache.commons.codec.digest.DigestUtils" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.SecretKey" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    //单点综合管理平台--档案系统
    BaseBean.writeLog("----------单点综合管理平台--档案系统--开始----------");
    String sysid = Util.null2String(request.getParameter("id"));// 系统标识
    BaseBean.writeLog("系统标志："+sysid);
    RecordSet recordSet = new RecordSet();
    String username = "";
    String password = "";
    Boolean flag = true;
    recordSet.executeQuery("select account,password from outter_account where sysid='"+ sysid + "' and userid='" + user.getUID()+"'");
    BaseBean.writeLog("select account,password from outter_account where sysid='"+ sysid + "' and userid=" + user.getUID());
    if (recordSet.next()) {
        username = recordSet.getString("account");
        password = recordSet.getString("password");
        if (!"".equals(username) || !"".equals(password)) {
            password = SecurityHelper.decryptSimple(password);
            BaseBean.writeLog("账号：" + username + "    密码：" + password);
        }
    }
    if("".equals(username) || "".equals(password)){
        flag = false;
    }else {
        String key = "820c19ba9b3a6f80e1f3f5da34274eec";
        //档案系统登录名和密码加密处理
        String loginName = username+"#"+(new Date()).getTime()+"#"+password;
        String encode = encode3Des(key, loginName);
        String URLencode = URLEncoder.encode(encode,"UTF-8");
        response.sendRedirect("http://172.18.102.15/SSO/index?type=sso&token="+URLencode);
    }
    BaseBean.writeLog("flag："+flag);
    BaseBean.writeLog("----------单点综合管理平台--档案系统--结束----------");
%>

<script type="text/javascript">
    function login() {
        var flag = <%=flag%>;
        console.log(flag);
        if (!flag) {
            alert("账号或密码有误，请修改。");
            window.location.href = "/spa/integration/static4engine/engine.html#/main/integration/accountSetting";
            return;
        }
    }
    login();
</script>

<%!
    /**
     * 转换成十六进制字符串
     */
    public byte[] hex(String key){
        String f = DigestUtils.md5Hex(key);
        byte[] bkeys = new String(f).getBytes();
        byte[] enk = new byte[24];
        for (int i=0;i<24;i++){
            enk[i] = bkeys[i];
        }
        return enk;
    }

    /**
     * 3DES加密
     * @param key 密钥，24位
     * @param srcStr 将加密的字符串
     * @return
     */
    public String encode3Des(String key, String srcStr){
        byte[] keybyte = hex(key);
        byte[] src = srcStr.getBytes();
        try {
            //生成密钥
            SecretKey deskey = new SecretKeySpec(keybyte, "DESede");
            //加密
            Cipher c1 = Cipher.getInstance("DESede");
            c1.init(Cipher.ENCRYPT_MODE, deskey);
            String pwd = Base64.encodeBase64String(c1.doFinal(src));
            return pwd;
        } catch (java.security.NoSuchAlgorithmException e1) {
            e1.printStackTrace();
        }catch(javax.crypto.NoSuchPaddingException e2){
            e2.printStackTrace();
        }catch(Exception e3){
            e3.printStackTrace();
        }
    return null;
    }

    /**
     * 3DES解密
     * @param key 加密密钥，长度为24字节
     * @param desStr 解密后的字符串
     * @return
     */
    public String decode3Des(String key, String desStr){
        Base64 base64 = new Base64();
        byte[] keybyte = hex(key);
        byte[] src = base64.decode(desStr);
        try {
            //生成密钥
            SecretKey deskey = new SecretKeySpec(keybyte, "DESede");
            //解密
            Cipher c1 = Cipher.getInstance("DESede");
            c1.init(Cipher.DECRYPT_MODE, deskey);
            String pwd = new String(c1.doFinal(src));
            return pwd;
        } catch (java.security.NoSuchAlgorithmException e1) {
            e1.printStackTrace();
        }catch(javax.crypto.NoSuchPaddingException e2){
            e2.printStackTrace();
        }catch(Exception e3){
            e3.printStackTrace();
        }
        return null;
    }
%>