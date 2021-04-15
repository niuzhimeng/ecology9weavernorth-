<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    RecordSet recordSet = new RecordSet();
    RecordSet updateSet = new RecordSet();
    BaseBean baseBean = new BaseBean();

    try {
        baseBean.writeLog("建模数据过滤开始==============");
        Map<String, String> map = new HashMap<>();
        recordSet.executeQuery("select bmmc, km from uf_bmdyyjkm");
        baseBean.writeLog("uf_bmdyyjkm表数据条数： " + recordSet.getCounts());
        while (recordSet.next()) {
            map.put(recordSet.getString("bmmc"), recordSet.getString("km"));
        }
        // 插入语句
        String insertSql = "insert into formtable_main_231(xmbh, xmmc, bm, ysed, kyys, " +
                "spzys, yyys, yskm, nf, cpx)values(?,?,?,?,?, ?,?,?,?,?)";

        recordSet.executeQuery("SELECT\n" +
                " a.*,\n" +
                " b.NAME supname \n" +
                "FROM\n" +
                " expotTemp_1225 a\n" +
                " LEFT JOIN fnabudgetfeetype b ON a.supsubject = b.id \n" +
                "ORDER BY\n" +
                " a.bm");
        baseBean.writeLog("expotTemp_1225视图数据条数： " + recordSet.getCounts());
        while (recordSet.next()) {
            String xmbh = recordSet.getString("xmbh");
            String xmmc = recordSet.getString("xmmc");
            String bm = recordSet.getString("bm");
            String ysed = recordSet.getString("ysed");
            String kyys = recordSet.getString("kyys");

            String yskm = recordSet.getString("yskm");
            String cpx = recordSet.getString("cpx");

            String departmentname = Util.null2String(recordSet.getString("departmentname")); // 部门名称
            String supsubject = Util.null2String(recordSet.getString("supname")); // 科目名称
            if (supsubject.equals(map.get(departmentname))) {
                // 合规数据
                updateSet.executeUpdate(insertSql, xmbh, xmmc, bm, ysed, kyys,
                        "0", "0", yskm, 2021, cpx);
            }
        }
        baseBean.writeLog("建模数据过滤结束==============");
    } catch (Exception e) {
        baseBean.writeLog("建模数据过滤异常： " + e);
    }

%>