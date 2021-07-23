<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.TemporalAdjusters" %>
<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // CS2-1工程项目信息表 历史数据获取；本年初 - 至今
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    try {
        String userId = request.getParameter("userId");
        baseBean.writeLog("当前人: " + userId);
        LocalDate now = LocalDate.now();
        String start = now.getYear() + "-01-01";
        LocalDate end = now.with(TemporalAdjusters.firstDayOfMonth());

        String selSql = "select id, htmcdxwb from uf_htxxb where modedatacreater = '" + userId + "' and tjrq >= '" + start + "' and sfywg = 1";
        baseBean.writeLog("工程项目查询sql： " + selSql);
        recordSet.executeQuery(selSql);

        StringJoiner stringJoiner = new StringJoiner(",");
        JSONArray jsonArray = new JSONArray();
        while (recordSet.next()) {
            JSONObject object = new JSONObject();
            // 带出历史数据的id，对应页面上【工程名称】
            String id = recordSet.getString("id");
            object.put("xmmcId", recordSet.getString("id"));
            object.put("xmmc", recordSet.getString("htmcdxwb"));

            stringJoiner.add(id);
            jsonArray.add(object);
        }

        // 根据历史数据id查询一部分字段的合计
        Map<String, String> exeMap = new HashMap<>();
        String selSql1 = "select gcmcll, SUM(byczzxwc) total_1, SUM(byczxtnfb) total_2, SUM(byczdwfb) total_3, SUM(jfqrdbygcl) total_4 " +
                " from uf_gcxmmxb group by gcmcll having gcmcll in(" + stringJoiner + ")";
        baseBean.writeLog("合计查询sql： " + selSql1);
        recordSet.executeQuery(selSql1);
        while (recordSet.next()) {
            exeMap.put(recordSet.getString("gcmcll"),
                    recordSet.getString("total_1") + "," +
                            recordSet.getString("total_2") + "," +
                            recordSet.getString("total_3") + "," +
                            recordSet.getString("total_4")
            );
        }

        // 根据历史数据id查询后三列数据 去年12月的合计
        int year = LocalDate.now().minusYears(1).getYear();
        String str12 = year + "-12-%"; // 去年12月 例：2020-12-
        Map<String, String> laterMap = new HashMap<>();
        String selSql1_1 = "select gcmcll, bnljczhj, jfqrdbngcl, tjrq " +
                " from uf_gcxmmxb where gcmcll in (" + stringJoiner + ") and tjrq like '" + str12 + "'";
        baseBean.writeLog("后三列合计查询sql： " + selSql1_1);
        recordSet.executeQuery(selSql1_1);
        while (recordSet.next()) {
            laterMap.put(recordSet.getString("gcmcll"),
                    recordSet.getString("bnljczhj") + "," +
                            recordSet.getString("jfqrdbngcl")
            );
        }

        // 将查出来的合计数据 整合到第一个json数组中
        int size = jsonArray.size();
        for (int i = 0; i < size; i++) {
            JSONObject jsonObject = jsonArray.getJSONObject(i);
            // 根据项目名称id找到 统计的数据
            String xmmcId = jsonObject.getString("xmmcId");
            String total = exeMap.get(xmmcId);
            String total_1 = laterMap.get(xmmcId);
            jsonObject.put("calculates", total); // 前三列计算
            jsonObject.put("calculates_1", total_1); // 后三列计算，去年12月的合计
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("myState", jsonArray.size() > 0);
        jsonObject.put("info", jsonArray);

        out.clear();
        out.print(jsonObject.toJSONString());
    } catch (Exception e) {
        baseBean.writeLog("工程项目 历史数据获取异常： " + e);
    }

%>