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

        String insertSql = "INSERT INTO docseccategory (subcategoryid, categoryname, docmouldid, publishable, replyable, shareable, hashrmres, maxuploadfilesize, maxofficedocfilesize, parentid, weaver_code, batch_code)VALUES(1,?,1,1,1,1,1,5,8, ?,?,?)";
        String updateSql = "update docseccategory set parentid = ? where id = ? and weaver_code != 'parent'";

        // 插入目录
        updateSet.executeUpdate(insertSql, name, rootId, "parent", batch_code);

        // 插入该目录下固定的一套目录
        recordSet.executeQuery("select name, code from zhonggong_mulu order by name");
        while (recordSet.next()) {
            updateSet.executeUpdate(insertSql, recordSet.getString("name"), "0", recordSet.getString("code"), batch_code);
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

        out.clear();
        out.print("创建完成");
    } catch (Exception e) {
        baseBean.writeLog("批量创建目录异常： " + e);
    }

%>