<%@ page import="weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    //单点综合管理平台--生产管理
    BaseBean.writeLog("----------单点综合管理平台--生产管理--开始----------");
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
    BaseBean.writeLog("----------单点综合管理平台--生产管理--结束----------");
%>

<script type="text/javascript">
    function login() {
        var flag = <%=flag%>;
        if(!flag){
            alert("账号或密码有误，请修改。");
            window.location.href="/spa/integration/static4engine/engine.html#/main/integration/accountSetting";
            return;
        }else {
            var userParam = {
                "username":'<%=username%>',
                "password":'<%=password%>'
            };
            var ip = "http://172.18.102.70:80";
            var url = "http://172.18.102.69:80/service/authc/login";
            jQuery.ajax({
                url:url,
                type:"POST",
                data:userParam,
                async:false,
                dataType:'json',
                success:function(data){
                    var tokenId = data.tokenId;
                    // var userId = JSON.stringify(data.user.userId);
                    // var username = JSON.stringify(data.user.username);
                    localStorage.setItem('name', JSON.stringify(data.user.memoName));
                    localStorage.setItem('key', JSON.stringify(data.tokenId));
                    localStorage.setItem('userId', JSON.stringify(data.user.userId));
                    localStorage.setItem('username', JSON.stringify(data.user.username));

                    //跳转地址
                    window.location.href="http://172.18.102.29:9370/?tokenId="+tokenId;
                },
                error:function(data){
                    alert('用户名或密码不正确');
                    window.location.href="/spa/integration/static4engine/engine.html#/main/integration/accountSetting";
                }
            });
        }
    }
    login();
</script>
