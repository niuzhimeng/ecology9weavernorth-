<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.engine.workflow.entity.publicApi.ApiWorkflowRequestInfo" %>
<%@ page import="com.engine.workflow.publicApi.impl.WorkflowRequestListPAImpl" %>
<%@ page import="com.weaver.general.Util" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
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
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page language="java" contentType="text/html; charset=gbk" %>
<%

    String str = "OA_HD_TODO";
    BaseBean baseBean = new BaseBean();
    JSONObject returnJson = new JSONObject();
    response.setHeader("Content-Type", "application/json;charset=UTF-8");
    try {
        String loginId = Util.null2String(request.getParameter("loginId")).trim();
        String timestamp = Util.null2String(request.getParameter("timestamp")).trim();
        String sign = Util.null2String(request.getParameter("sign")).trim();
        int count = Util.getIntValue(request.getParameter("count"), 10);
        if (count > 50) {
            count = 50;
        }

        baseBean.writeLog("慧点获取OA待办Start============" + loginId);

        // 非空判断
        if (StringUtils.isBlank(sign)) {
            JSONObject returnObj = createReturnObj("500", "认证失败-sign为空");
            out.clear();
            out.print(returnObj.toJSONString());
            return;
        }

        // 时间验证
        long currentTimeMillis = System.currentTimeMillis();
        long longValue = getLongValue(timestamp);
        long result = currentTimeMillis - longValue;
        long min = result / 1000 / 60;
        if (min > 15) {
            JSONObject returnObj = createReturnObj("500", "认证失败-sign已过期");
            out.clear();
            out.print(returnObj.toJSONString());
            return;
        }

        // 加密方式验证
        String md5ofStr = new MD5().getMD5ofStr(timestamp + str + loginId);
        if (!md5ofStr.equals(sign)) {
            JSONObject returnObj = createReturnObj("500", "认证失败-sign错误");
            out.clear();
            out.print(returnObj.toJSONString());
            return;
        }

        RecordSet recordSet = new RecordSet();

        recordSet.executeQuery("select * from HrmResource where loginid = lower('" + loginId + "') and status < 4");
        if (!recordSet.next()) {
            JSONObject returnObj = createReturnObj("500", "认证失败-loginId不存在");
            out.clear();
            out.print(returnObj.toJSONString());
            return;
        }
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
        log1.setSysLogInfo();

        // 查询待办条件
        Map<String, String> map = new HashMap<>();
        WorkflowRequestListPAImpl workflowRequestListPA = new WorkflowRequestListPAImpl();

        List<ApiWorkflowRequestInfo> toDoWorkflowRequestList = workflowRequestListPA.getToDoWorkflowRequestList(1, count, userNew, map, true, true);

        returnJson.put("code", 200);
        returnJson.put("message", "获取成功");
        returnJson.put("count", toDoWorkflowRequestList.size());
        returnJson.put("content", toDoWorkflowRequestList);

        out.clear();
        out.print(returnJson.toJSONString());

    } catch (Exception e) {
        baseBean.writeLog("慧点获取OA待办Error================" + e);
    }
    baseBean.writeLog("慧点获取OA待办End================");
%>


<%!

    private static long getLongValue(String time) {
        try {
            return Long.parseLong(time);
        } catch (Exception e) {
            return -1;
        }
    }

    public static JSONObject createReturnObj(String status, String message) {
        JSONObject jsonObject = new JSONObject(true);
        jsonObject.put("status", status);
        jsonObject.put("message", message);
        return jsonObject;
    }

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

