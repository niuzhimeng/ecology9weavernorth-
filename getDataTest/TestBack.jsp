<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.conn.RecordSetDataSource" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    // 主表带出主表数据
    BaseBean baseBean = new BaseBean(); // 打日志用
    RecordSet recordSet = new RecordSet(); // 查本地数据库用
    RecordSetDataSource recordSetDataSource = new RecordSetDataSource(""); // 查中间库用

    JSONObject returnObj = new JSONObject(); //返回json数据用
    JSONObject DataObj = new JSONObject();
    boolean flag = true;
    try {
        String currId = request.getParameter("currId");
        baseBean.writeLog("后端接口接收到参数： " + currId);
        recordSet.executeQuery("select h.seclevel, h.loginid, h.sex, d.id deptId, d.departmentname from hrmresource h " +
                " left join hrmdepartment d on h.departmentid = d.id where h.id = ?", currId);
        if (recordSet.next()) {
            String sex = recordSet.getString("sex");
            if ("0".equals(sex)) {
                sex = "男";
            } else {
                sex = "女";
            }

            DataObj.put("loginid", recordSet.getString("loginid"));
            DataObj.put("sex", sex);
            DataObj.put("deptId", recordSet.getString("deptId"));
            DataObj.put("departmentname", recordSet.getString("departmentname"));
            DataObj.put("seclevel", recordSet.getString("seclevel"));
        } else {
            flag = false;
        }
        returnObj.put("myState", flag);
        returnObj.put("data", DataObj);
    } catch (Exception e) {
        baseBean.writeLog("获取数据测试 Err: " + e);
    }
    out.clear();
    out.print(returnObj);

%>