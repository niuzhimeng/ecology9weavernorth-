<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.conn.RecordSetDataSource" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    // 主表带出明细表数据
    BaseBean baseBean = new BaseBean(); // 打日志用
    RecordSet recordSet = new RecordSet(); // 查本地数据库用
    RecordSetDataSource recordSetDataSource = new RecordSetDataSource(""); // 查中间库用

    JSONObject returnObj = new JSONObject(); //返回json数据用
    JSONArray dataArray = new JSONArray();
    boolean flag = true;
    try {
        String currId = request.getParameter("currId");
        baseBean.writeLog("后端接口接收到参数： " + currId);
        recordSet.executeQuery("SELECT h2.* FROM hrmresource h1 INNER JOIN hrmresource h2 on h1.departmentid = h2.departmentid " +
                " where h1.id = ?", currId);
        while (recordSet.next()) {
            String sex = recordSet.getString("sex");
            if ("0".equals(sex)) {
                sex = "男";
            } else {
                sex = "女";
            }
            JSONObject dataObj = new JSONObject();
            dataObj.put("loginid", recordSet.getString("loginid"));
            dataObj.put("sex", sex);
            dataObj.put("deptId", recordSet.getString("deptId"));
            dataObj.put("departmentname", recordSet.getString("departmentname"));
            dataObj.put("seclevel", recordSet.getString("seclevel"));
            dataObj.put("lastname", recordSet.getString("lastname"));

            dataArray.add(dataObj);
        }
        returnObj.put("myState", flag);
        returnObj.put("dataArray", dataArray);
    } catch (Exception e) {
        baseBean.writeLog("获取数据测试 Err: " + e);
    }
    out.clear();
    out.print(returnObj);

%>