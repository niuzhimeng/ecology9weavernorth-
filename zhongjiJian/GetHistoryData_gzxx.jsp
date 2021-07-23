<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.TemporalAdjusters" %>
<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 跟踪信息（修改跟踪状态等） 历史数据获取；本年初 - 至今
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    try {
        String userId = request.getParameter("userId");
        baseBean.writeLog("当前人: " + userId);
        LocalDate now = LocalDate.now();
        String start = now.getYear() + "-01-01";

        LocalDate end = now.with(TemporalAdjusters.firstDayOfMonth());

        String selSql = "select id, xmmc from uf_gzxxb where modedatacreater = '" + userId + "' and tjrq >= '" + start + "' and " +
                " gzjd in (0, 1)";
        baseBean.writeLog("跟踪信息查询sql： " + selSql);
        recordSet.executeQuery(selSql);

        JSONArray jsonArray = new JSONArray();
        while (recordSet.next()) {
            JSONObject object = new JSONObject();
            object.put("xmmcId", recordSet.getString("id"));
            object.put("xmmc", recordSet.getString("xmmc"));

            jsonArray.add(object);
        }

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("myState", jsonArray.size() > 0);
        jsonObject.put("info", jsonArray);

        out.clear();
        out.print(jsonObject.toJSONString());
    } catch (Exception e) {
        baseBean.writeLog("跟踪信息 历史数据获取异常： " + e);
    }

%>