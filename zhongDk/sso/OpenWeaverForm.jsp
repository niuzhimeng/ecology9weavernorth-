<%@ page import="com.weaver.general.Util" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.MD5" %>
<%@ page import="weaver.hrm.OnLineMonitor" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.login.Account" %>
<%@ page import="weaver.systeminfo.SysMaintenanceLog" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyRtxLogin" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%
    /**
     * 慧点打开泛微流程表单
     */
    BaseBean baseBean = new BaseBean();

    try {
        String loginId = request.getParameter("loginId");
        String requestId = request.getParameter("requestId");
        String timestamp = request.getParameter("timestamp");
        String sign = request.getParameter("sign");
        baseBean.writeLog("打开慧点系统表单Start===================loginId=" + loginId + ", requestId=" + requestId +
                "sign=" + sign);

        if (StringUtils.isBlank(loginId) || StringUtils.isBlank(requestId) || StringUtils.isBlank(sign)) {
            baseBean.writeLog("参数不全，跳转到登录页");
            response.sendRedirect("/login/Login.jsp?logintype=1");
            return;
        }
        String md5ofStr = new MD5().getMD5ofStr(loginId + requestId + "OPEN_WEAVER_FORM" + timestamp);

        if (!md5ofStr.equalsIgnoreCase(sign)) {
            baseBean.writeLog("验证失败md5ofStr: " + md5ofStr);
            response.sendRedirect("/login/Login.jsp?logintype=1");
            return;
        }

        RecordSet recordSet = new RecordSet();
        recordSet.executeQuery("select * from HrmResource where loginid = lower('" + loginId + "') and status < 4");
        if (recordSet.next()) {
            baseBean.writeLog("打开表单用户姓名---" + recordSet.getString("lastname"));
            User userNew = new User();
            userNew.setUid(recordSet.getInt("id"));
            userNew.setLoginid(recordSet.getString("loginid"));
            userNew.setFirstname(recordSet.getString("firstname"));
            userNew.setLastname(recordSet.getString("lastname"));
            userNew.setAliasname(recordSet.getString("aliasname"));
            userNew.setTitle(recordSet.getString("title"));
            userNew.setTitlelocation(recordSet.getString("titlelocation"));
            userNew.setSex(recordSet.getString("sex"));
            userNew.setPwd(recordSet.getString("password"));
            String languageidweaver = recordSet.getString("systemlanguage");
            userNew.setLanguage(Util.getIntValue(languageidweaver, 0));
            userNew.setTelephone(recordSet.getString("telephone"));
            userNew.setMobile(recordSet.getString("mobile"));
            userNew.setMobilecall(recordSet.getString("mobilecall"));
            userNew.setEmail(recordSet.getString("email"));
            userNew.setCountryid(recordSet.getString("countryid"));
            userNew.setLocationid(recordSet.getString("locationid"));
            userNew.setResourcetype(recordSet.getString("resourcetype"));
            userNew.setStartdate(recordSet.getString("startdate"));
            userNew.setEnddate(recordSet.getString("enddate"));
            userNew.setContractdate(recordSet.getString("contractdate"));
            userNew.setJobtitle(recordSet.getString("jobtitle"));
            userNew.setJobgroup(recordSet.getString("jobgroup"));
            userNew.setJobactivity(recordSet.getString("jobactivity"));
            userNew.setJoblevel(recordSet.getString("joblevel"));
            userNew.setSeclevel(recordSet.getString("seclevel"));
            userNew.setUserDepartment(Util.getIntValue(recordSet.getString("departmentid"), 0));
            userNew.setUserSubCompany1(Util.getIntValue(recordSet.getString("subcompanyid1"), 0));
            userNew.setUserSubCompany2(Util.getIntValue(recordSet.getString("subcompanyid2"), 0));
            userNew.setUserSubCompany3(Util.getIntValue(recordSet.getString("subcompanyid3"), 0));
            userNew.setUserSubCompany4(Util.getIntValue(recordSet.getString("subcompanyid4"), 0));
            userNew.setManagerid(recordSet.getString("managerid"));
            userNew.setAssistantid(recordSet.getString("assistantid"));
            userNew.setPurchaselimit(recordSet.getString("purchaselimit"));
            userNew.setCurrencyid(recordSet.getString("currencyid"));
            userNew.setLastlogindate(recordSet.getString("currentdate"));
            userNew.setLogintype("1");
            userNew.setAccount(recordSet.getString("account"));

            userNew.setLoginip(request.getRemoteAddr());
            List<Account> childAccountList = getChildAccountList(userNew);//子账号相关设置
            request.getSession(true).setMaxInactiveInterval(60 * 60 * 24);
            request.getSession(true).setAttribute("weaver_user@bean", userNew);
            request.getSession(true).setAttribute("accounts", childAccountList);
            request.getSession(true).setAttribute("browser_isie", getisIE(request));

            request.getSession(true).setAttribute("moniter", new OnLineMonitor("" + userNew.getUID(), userNew.getLoginip()));
            Util.setCookie(response, "loginfileweaver", "/main.jsp", 172800);
            Util.setCookie(response, "loginidweaver", "" + userNew.getUID(), 172800);
            Util.setCookie(response, "languageidweaver", languageidweaver, 172800);

            Map logmessages1 = (Map) application.getAttribute("logmessages");
            if (logmessages1 == null) {
                logmessages1 = new HashMap();
                logmessages1.put(String.valueOf(userNew.getUID()), "");
                application.setAttribute("logmessages", logmessages1);
            }

            request.getSession(true).setAttribute("logmessage", getLogMessage(String.valueOf(userNew.getUID())));

            // 登录日志
            SysMaintenanceLog log1 = new SysMaintenanceLog();
            log1.resetParameter();
            log1.setRelatedId(recordSet.getInt("id"));
            log1.setRelatedName((recordSet.getString("firecordSettname") + " " + recordSet.getString("lastname")).trim());
            log1.setOperateType("6");
            log1.setOperateDesc("");
            log1.setOperateItem("60");
            log1.setOperateUserid(recordSet.getInt("id"));
            log1.setClientAddress(request.getRemoteAddr());
            try {
                log1.setSysLogInfo();
            } catch (Exception e) {
                e.printStackTrace();
            }
            //String workFlowUrl = "/workflow/request/ViewRequest.jsp?requestid=" + requestId + "&_workflowtype=&isovertime=0";
            String workFlowUrl = "/spa/workflow/static4form/index.html#/main/workflow/req?requestid=" + requestId;
            // String workFlowUrl = "/wui/index.html#/main";
            if ("1".equals(recordSet.getString("accounttype"))) {
                // 次账号，需拼接额外两个参数
                workFlowUrl += "&f_weaver_belongto_userid=" + recordSet.getString("id") + "&f_weaver_belongto_usertype=0";
            }
            response.sendRedirect(workFlowUrl);
        } else {
            // OA中查无此人，必须重新登录
            response.sendRedirect("/login/Login.jsp?logintype=1");
        }

    } catch (Exception e) {
        baseBean.writeLog("慧点打开泛微表单异常： " + e);
    }
%>

<%!
    private List<Account> getChildAccountList(User user) {
        List<Account> accounts = new ArrayList<Account>();
        int uid = user.getUID();
        RecordSet rs = new RecordSet();
        rs.executeSql("select * from hrmresource where status in (0,1,2,3) and (belongto = " + uid + " or id = " + uid + ")");
        while (rs.next()) {
            Account account = new Account();
            account.setId(rs.getInt("id"));
            account.setDepartmentid(rs.getInt("departmentid"));
            account.setJobtitleid(rs.getInt("JOBTITLE"));
            account.setSubcompanyid(rs.getInt("SUBCOMPANYID1"));
            account.setType(rs.getInt("ACCOUNTTYPE"));
            account.setAccount(Util.null2String(rs.getString("ACCOUNT")));
            accounts.add(account);
        }
        return accounts;
    }

    /**
     * 获取日志信息
     */
    private String getLogMessage(String uid) {
        String message = "";
        RecordSet rs = new RecordSet();
        String sqltmp = "";
        if (rs.getDBType().equals("oracle")) {
            sqltmp = "select * from (select * from SysMaintenanceLog where relatedid = " + uid + " and operatetype='6' and operateitem='60' order by id desc ) where rownum=1 ";
        } else if (rs.getDBType().equals("db2")) {
            sqltmp = "select * from SysMaintenanceLog where relatedid = " + uid + " and operatetype='6' and operateitem='60' order by id desc fetch first 1 rows only ";
        } else if (rs.getDBType().equals("mysql")) {
            sqltmp = "SELECT t2.* FROM (SELECT * FROM SysMaintenanceLog WHERE relatedid = " + uid + " and  operatetype='6' AND operateitem='60' ORDER BY id DESC) t2  LIMIT 1 ,1";
        } else {
            sqltmp = "select top 1 * from SysMaintenanceLog where relatedid = " + uid + " and operatetype='6' and operateitem='60' order by id desc";
        }

        rs.executeSql(sqltmp);
        if (rs.next()) {
            message = rs.getString("clientaddress") + " " + rs.getString("operatedate") + " " + rs.getString("operatetime");
        }

        return message;
    }

    /**
     * 判断浏览器是否为IE
     *
     * @param request
     * @return
     */
    private String getisIE(HttpServletRequest request) {
        String isIE = "true";
        String agent = request.getHeader("User-Agent").toLowerCase();
        if (!agent.contains("rv:11") && !agent.contains("msie")) {
            isIE = "false";
        }
        if (agent.contains("rv:11") || agent.indexOf("msie") > -1) {
            isIE = "true";
        }
        return isIE;
    }
%>


