<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // cookie session 练习
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("cookie session 练习开始");
    // 同时设置服务器 + 客户端的字符集
    response.setContentType("text/html;charset=utf-8");


    // 1、创建cookie 同样的key会更新 如需要中文 特殊符号，则需要base64
//    String cookieVal = "一串中文";
//    Base64.Encoder encoder = Base64.getEncoder();
//    String s = encoder.encodeToString(cookieVal.getBytes(StandardCharsets.UTF_8));
//    Cookie cookie = new Cookie("test", s);
//    response.addCookie(cookie);

    // 2、获取cookie
//    StringBuilder stringBuilder = new StringBuilder();
//    Cookie[] cookies = request.getCookies();
//    for (Cookie cookie1 : cookies) {
//        stringBuilder.append("key: ").append(cookie1.getName()).append("; value: ").append(cookie1.getValue()).append("</br>");
//    }
//
//    response.getWriter().write("全部的cookie： " + stringBuilder);

    /**
     * 过期时间 默认-1
     * 整数：N秒后过期
     * 负数：浏览器关闭后失效
     * 0 ： 马上删除cookie
     *
     */
    Cookie cookie2 = new Cookie("test2", "12321");
    // cookie2.setMaxAge(5);

    /**
     * 设置有效路径，只有与请求的路径匹配  才会发给服务器
     */
    String contextPath = request.getContextPath();

    cookie2.setPath("/weavernorth/");
    response.addCookie(cookie2);

    StringBuilder stringBuilder = new StringBuilder();
    Cookie[] cookies = request.getCookies();
    for (Cookie cookie1 : cookies) {
        stringBuilder.append("key: ").append(cookie1.getName()).append("; value: ").append(cookie1.getValue()).append("</br>");
    }

    response.getWriter().write("全部的cookie： " + stringBuilder);
%>