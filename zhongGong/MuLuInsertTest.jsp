<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.conn.RecordSet" %>

<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="java.util.UUID" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 跟踪信息（修改跟踪状态等） 历史数据获取；本年初 - 至今
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    RecordSet updateSet = new RecordSet();

    String parameter = request.getParameter("");

    // 操作批次号
    String batch_code = UUID.randomUUID().toString();

    try {
        baseBean.writeLog("创建目录开始================");
        String insertSql = "INSERT INTO docseccategory (subcategoryid, categoryname, docmouldid, publishable, replyable, shareable, hashrmres, maxuploadfilesize, maxofficedocfilesize, parentid, weaver_code, batch_code)VALUES(1,?,1,1,1,1,1,5,8,0, ?,?)";
        String updateSql = "update docseccategory set parentid = ? where id = ?";

        // 插入目录数据
        recordSet.executeQuery("select name, code from zhonggong_mulu");
        while (recordSet.next()) {
            updateSet.executeUpdate(insertSql, recordSet.getString("name"), recordSet.getString("code"), batch_code);
        }
        baseBean.writeLog("插入数据完成================");

        // code - id
        Map<String, String> map = new HashMap<>();
        recordSet.executeQuery("select a.id, a.weaver_code from DOCSECCATEGORY a where a.batch_code = '" + batch_code + "'");
        while (recordSet.next()) {
            if (StringUtils.isNotBlank(recordSet.getString("weaver_code"))) {
                map.put(recordSet.getString("weaver_code"), recordSet.getString("id"));
            }
        }
        map.put("parent_best", "1");
        baseBean.writeLog("map构件完成================" + JSONObject.toJSONString(map));

        // 更新父目录
        recordSet.executeQuery("select a.id, b.parentcode from DOCSECCATEGORY a left join zhonggong_mulu b on a.weaver_code = b.code where a.batch_code ='" + batch_code + "'");
        while (recordSet.next()) {
            updateSet.executeUpdate(updateSql, map.get(recordSet.getString("parentcode")), recordSet.getString("id"));
        }
        baseBean.writeLog("更新父目录完成================");

        out.clear();
        out.print("创建完成");
    } catch (Exception e) {
        baseBean.writeLog("批量创建目录异常： " + e);
    }

%>