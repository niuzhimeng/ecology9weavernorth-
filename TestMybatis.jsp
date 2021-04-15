<%@page import="com.weavernorth.Example.service.HrmResourceService"%>
<%@page import="com.weavernorth.Example.service.impl.HrmResourceServiceImpl"%>
<%@ page import="com.weavernorth.Example.entity.HrmResource" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.engine.common.util.ServiceUtil" %>
<%@ page import="weaver.hrm.User" %>
<%--
  Created by IntelliJ IDEA.
  User: liujun
  Date: 2019/8/28
  Time: 11:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    try {
        User user = new User();
        HrmResourceService service = (HrmResourceService) ServiceUtil.getService(HrmResourceServiceImpl.class, user);

    	Map<String, Object> mapReturn = service.listUser(new HashMap<>());
        List<HrmResource> hrmResourceList = (List<HrmResource>)mapReturn.get("data");
        if (hrmResourceList != null) {
            out.println("MyBatis部署成功！共测试查下到" + hrmResourceList.size() + "条数据！");
        } else {
            out.println("MyBatis部署失败！");
        }
    }catch (Exception e){
        out.println("MyBatis部署失败！");
        out.println("错误信息："+e.toString());
        e.printStackTrace();
    }
%>