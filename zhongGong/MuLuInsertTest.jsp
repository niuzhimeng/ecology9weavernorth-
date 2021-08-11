<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.conn.RecordSet" %>

<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="java.util.UUID" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.engine.doc.service.DocSecCategoryService" %>
<%@ page import="com.engine.doc.service.impl.DocSecCategoryServiceImpl" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="com.engine.common.util.ServiceUtil" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.SubCategoryComInfo" %>
<%@ page import="weaver.docs.category.SecCategoryComInfo" %>
<%@ page import="weaver.docs.category.SecCategoryDocPropertiesComInfo" %>
<%@ page import="weaver.docs.category.DocTreelistComInfo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 跟踪信息（修改跟踪状态等） 历史数据获取；本年初 - 至今
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    RecordSet updateSet = new RecordSet();

    // 操作批次号
    String batch_code = UUID.randomUUID().toString();
    // 根目录id - 项目文件目录
    String rootId = request.getParameter("rootId");
    // 本次创建目录名称
    String name = request.getParameter("name");

    try {
        baseBean.writeLog("创建目录开始================");
        baseBean.writeLog("根目录id： " + rootId);
        baseBean.writeLog("name： " + name);

        User userNew = getUser();
        DocSecCategoryService docSecCategoryService = ServiceUtil.getService(DocSecCategoryServiceImpl.class, userNew);
        String insertSql = "update docseccategory set weaver_code = ?, batch_code = ? where id = ?";
        String updateSql = "update docseccategory set parentid = ? where id = ? and weaver_code != 'parent'";

        // 插入目录
        Map<String, Object> params = new HashMap<>();
        params.put("parentid", rootId);
        params.put("categoryname", name);
        params.put("subcompanyid", "0");
        params.put("extendParentAttr", "1");
        Map<String, Object> returnMap = docSecCategoryService.addDocMainCategory(params);
        baseBean.writeLog("returnMap: " + JSONObject.toJSONString(returnMap));
        Boolean api_status = (Boolean) returnMap.get("api_status");
        if (!api_status) {
            out.clear();
            out.print("创建失败： " + returnMap.get("msg"));
            return;
        }
        String id = String.valueOf(returnMap.get("id"));
        baseBean.writeLog("返回id： " + id);
        updateSet.executeUpdate(insertSql, "parent", batch_code, id);

        // 插入该目录下固定的一套目录
        recordSet.executeQuery("select name, code from zhonggong_mulu order by name");
        while (recordSet.next()) {
            params.put("parentid", rootId);
            params.put("categoryname", recordSet.getString("name"));
            params.put("subcompanyid", "0");
            params.put("extendParentAttr", "1");

            Map<String, Object> returnMapFor = docSecCategoryService.addDocMainCategory(params);
            updateSet.executeUpdate(insertSql, recordSet.getString("code"), batch_code, returnMapFor.get("id"));
        }
        baseBean.writeLog("插入数据完成================");

        // 查出本批次新增目录的对应关系code - id
        Map<String, String> map = new HashMap<>();
        recordSet.executeQuery("select id, weaver_code from DOCSECCATEGORY  where batch_code = '" + batch_code + "'");
        while (recordSet.next()) {
            if (StringUtils.isNotBlank(recordSet.getString("weaver_code"))) {
                map.put(recordSet.getString("weaver_code"), recordSet.getString("id"));
            }
        }

        baseBean.writeLog("map构件完成================" + JSONObject.toJSONString(map));

        // 更新父目录
        recordSet.executeQuery("select a.id, b.parentcode from DOCSECCATEGORY a left join zhonggong_mulu b on a.weaver_code = b.code where a.batch_code ='" + batch_code + "'");
        while (recordSet.next()) {
            updateSet.executeUpdate(updateSql, map.get(recordSet.getString("parentcode")), recordSet.getString("id"));
        }
        baseBean.writeLog("更新父目录完成================");

        new SubCategoryComInfo().removeMainCategoryCache();
        new SecCategoryComInfo().removeMainCategoryCache();
        new SecCategoryDocPropertiesComInfo().removeCache();
        new DocTreelistComInfo().removeGetDocListInfordCache();

        out.clear();
        out.print("创建完成");
    } catch (Exception e) {
        baseBean.writeLog("批量创建目录异常： " + e);
        out.clear();
        out.print("批量创建目录异常： " + e);
    }

%>

<%!
    private User getUser() {
        RecordSet recordSet = new RecordSet();
        User userNew = new User();
        try {
            String loginId = "nzm";
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