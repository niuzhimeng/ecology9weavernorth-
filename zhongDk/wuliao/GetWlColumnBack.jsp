<%@ page import="org.json.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyRtxLogin" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page language="java" contentType="text/html; charset=gbk" %>
<%

    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    try {
        String wlflVal = request.getParameter("wlflVal"); // 物料分类
        baseBean.writeLog("获取物料配置字段Start====物料分类： " + wlflVal);

        JSONObject jsonObject = new JSONObject();
        Map<String, String> zdMap = new HashMap<>();
        recordSet.executeQuery("select b.oazdm, b.oaxsm from uf_wlfldzb a right join uf_wlfldzb_dt1 b on a.id = b.mainid where a.wlfl like '%," + wlflVal + ",%'");
        while (recordSet.next()) {
            zdMap.put(recordSet.getString("oazdm"), recordSet.getString("oaxsm"));
        }

        jsonObject.put("myState", zdMap.size() > 0);
        jsonObject.put("zds", zdMap);

        out.clear();
        out.print(jsonObject.toString());
        baseBean.writeLog("获取物料配置字段End");
    } catch (Exception e) {
        baseBean.writeLog("获取物料配置字段异常： " + e);
    }
%>


