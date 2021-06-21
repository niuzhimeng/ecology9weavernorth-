<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ include file="/systeminfo/init_wev8.jsp" %>--%>

<%
    // 进度条后端
    BaseBean baseBean = new BaseBean();
    String flag = request.getParameter("flag");
    if ("getCount".equals(flag)) {
        String percentage = "0";
        // 获取执行进度
        String allCount = (String) session.getAttribute("nzmallCount");
        String count = (String) session.getAttribute("nzmcount");
        if ("0".equals(count)) {

        } else if (allCount.equals(count)) {
            percentage = "100";
        }

        BigDecimal bigDecimal = new BigDecimal(count);
        BigDecimal bigDecimal2 = new BigDecimal(allCount);
        BigDecimal divide = bigDecimal.divide(bigDecimal2, 4, BigDecimal.ROUND_HALF_UP);

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("percentage", percentage);
        out.clear();
        out.print(jsonObject.toJSONString());
        return;
    }
    // 执行业务
    String ids = request.getParameter("ids");
    baseBean.writeLog("接收前端数据： " + ids);
    int length = ids.split(",").length;
    baseBean.writeLog("总数： " + length);
    // 设置当前请求的总数
    session.setAttribute("nzmallCount", String.valueOf(length));

    for (int i = 1; i <= length; i++) {
        session.setAttribute("nzmcount", String.valueOf(i));
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

    }

    session.removeAttribute("nzmallCount");
    session.removeAttribute("nzmcount");
    JSONObject result = new JSONObject();
    result.put("myState", true);
    out.clear();
    out.print(result.toJSONString());
%>





