<%@ page import="weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<script type="text/javascript" language="javascript">
    window.onload = function () {
        document.getElementById("loginForm").submit();
    }
</script>
<%
    //单点综合管理平台--管理提升年
    BaseBean.writeLog("----------单点综合管理平台--双百行动--开始----------");
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
    }
    BaseBean.writeLog("flag："+flag);
    BaseBean.writeLog("----------单点综合管理平台--双百行动--结束----------");
%>

<script type="text/javascript">
    function login() {
        var flag = <%=flag%>;
        if (!flag) {
            alert("账号或密码有误，请修改。");
            window.location.href = "/spa/integration/static4engine/engine.html#/main/integration/accountSetting";
            return;
        }
    }
    login();
</script>

<html>
<body>
<form id="loginForm"
      action="http://172.18.102.120:8080/a/login"
      method="post" style="display:none">
    <input type="hidden" id="username" name="username" value="<%=username%>"/>
    <input type="hidden" id="password" name="password" value="<%=password%>"/>
</form>
</body>
</html>
