<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.TemporalAdjusters" %>
<%@ page import="com.alibaba.fastjson.JSONArray" %>

<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="com.weavernorth.mybatisTest.dao.MyJdbcTestDao" %>
<%@ page import="com.weavernorth.mybatisTest.entity.MyJdbcTest" %>
<%@ page import="com.weavernorth.mybatisTest.Ebu8MyBatisUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 跟踪信息（修改跟踪状态等） 历史数据获取；本年初 - 至今
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    try (
            SqlSession sqlSession = Ebu8MyBatisUtil.getSqlSession();
    ) {
        MyJdbcTestDao mapper = sqlSession.getMapper(MyJdbcTestDao.class);
        MyJdbcTest myJdbcTest = mapper.selectByPrimaryKey(5);

        baseBean.writeLog("mybatis获取对象： " + myJdbcTest);
        baseBean.writeLog("mybatis获取对象： " + JSONObject.toJSONString(myJdbcTest));
        out.clear();
        out.print(myJdbcTest.toString());
    } catch (Exception e) {
        baseBean.writeLog("mybatis获取对象异常： " + e);
    }

%>