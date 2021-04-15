<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.integration.util.HTTPUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    //单点综合管理平台--企业邮箱
    BaseBean.writeLog("----------单点综合管理平台--企业邮箱--开始----------");
    String sysid = Util.null2String(request.getParameter("id"));// 系统标识
    BaseBean.writeLog("系统标志："+sysid);
    RecordSet recordSet = new RecordSet();
    String username = "";
    String password = "";
    Boolean flag = true;
    String result = "";
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
        //企业邮箱
        //密钥
        String authadmin = "xianyjy";
        String authpass ="A12345";
        String passKey = authadmin+"."+System.currentTimeMillis()/1000+"."+new com.weaver.general.MD5().getMD5ofStr(authpass).toLowerCase();
        String url = "http://10.10.10.66/restful/neworg.php/get_ext_authkey?user="+username+"&passkey="+passKey+"&key="+username+"&oid=1";
        BaseBean.writeLog("获取key邮箱url："+url);
        //获取邮箱认证的key
        String json = HTTPUtil.doGet(url);
        BaseBean.writeLog("获取key邮箱返回json："+json);
        /*JsonObject jsonObject = (JsonObject) new JsonParser().parse(json);
        String errcode = jsonObject.get("errcode").getAsString();
        //成功跳转企业邮箱
        if("0".equals(errcode)){
            response.sendRedirect("http://10.10.10.66/login.php?rd="+jsonObject.get("result").getAsString());
        }else {
            flag = false;
        }*/

        if(!"".equals(json)){
            result = json.replace("\"","").trim();
            result = URLDecoder.decode(result, "gbk");
        }else {
            flag = false;
        }
    }
    BaseBean.writeLog("flag："+flag);
    BaseBean.writeLog("result："+result);
    BaseBean.writeLog("----------单点综合管理平台--企业邮箱--结束----------");
%>

<html>
<body>
<form id="loginForm"
      action="http://10.10.10.66/login.php"
      method="get" style="display:none">
    <input type="hidden" id="rd" name="rd" value="<%=result%>"/>
</form>
</body>
</html>


<script type="text/javascript">
    function login() {
        var flag = <%=flag%>;
        if (!flag) {
            alert("账号或密码有误，请修改。");
            window.location.href = "/spa/integration/static4engine/engine.html#/main/integration/accountSetting";
            return;
        }else {
            document.getElementById("loginForm").submit();
        }
    }
    login();
</script>
