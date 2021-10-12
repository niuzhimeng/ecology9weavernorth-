<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ include file="/systeminfo/init_wev8.jsp" %>--%>

<%
    /**
     * session练习
     * 每个客户端都有一个session会话
     * session超时时间内 如果删除cookie，再请求  会创建一个新的session
     * cookie通过JSESSIONID与服务器端的session关联
     *
     * 服务器每创建一个session对象的时候  都会创建一个cookie对象与之关联
     *
     */
    // 第一次调用是创建session，之后调用都是获取前面创建好的session
    HttpSession session1 = request.getSession();
    // true：表示刚创建； false：表示获取之前创建的
    boolean aNew = session1.isNew();

    BaseBean baseBean = new BaseBean();
    String time = (String) session1.getAttribute("time");
    response.getWriter().write("获取到session值： " + time);
    if (StringUtils.isBlank(time)) {
        session1.setAttribute("time", TimeUtil.getCurrentTimeString());
        // 删除session中的属性
        //session1.removeAttribute("");
        // 设置超时时间 单位：秒；负数标识永不超时(极少使用)；
        // 默认30分钟过期 可配置 在web.xml中可更改
        // session的超时指的是 客户端两次请求的最大间隔
        //session1.setMaxInactiveInterval(4);
        int maxInactiveInterval = session1.getMaxInactiveInterval();

        // 让当前session立刻失效
        // session1.invalidate();
        response.getWriter().write("设置成功");
    }

%>

<script type="text/javascript">


</script>
