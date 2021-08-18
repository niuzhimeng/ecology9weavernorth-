<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.engine.doc.service.impl.DocSecCategoryServiceImpl" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.engine.common.util.ServiceUtil" %>
<%@ page import="com.engine.doc.service.DocSecCategoryService" %>
<%@ page import="com.engine.workflow.util.CommonUtil" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="com.weaver.general.Util" %>
<%@ page import="weaver.login.Account" %>
<%@ page import="java.util.List" %>
<%@ page import="weaver.hrm.OnLineMonitor" %>
<%@ page import="java.util.ArrayList" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    BaseBean baseBean = new BaseBean();

    Map<String, Object> map = new HashMap<>();
    map.put("parentid", "1");
    map.put("categoryname", "jspAdd1");
    map.put("subcompanyid", "0");
    map.put("extendParentAttr", "1");

    Map<String, Object> resultMap = null;
    try {
        User userNew = getUser();
        DocSecCategoryService docSecCategoryService = ServiceUtil.getService(DocSecCategoryServiceImpl.class, userNew);
        resultMap = docSecCategoryService.addDocMainCategory(map);
    } catch (Exception e) {
        out.clear();
        out.print("异常了： " + e);
        return;
    }

    out.clear();
    out.print(JSONObject.toJSONString(resultMap));
%>
<%!
    private User getUser() {
        RecordSet recordSet = new RecordSet();
        User userNew = new User();
        try {
            String loginId = "ceshi";
            recordSet.executeQuery("select * from HrmResource where loginid = lower('" + loginId + "') and status < 4");
            recordSet.next();

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

        } catch (Exception e) {
            e.printStackTrace();
        }
        return userNew;
    }

%>














