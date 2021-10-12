<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="org.apache.commons.fileupload.FileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.hutool.core.io.FileUtil" %>
<%@ page import="cn.hutool.core.io.IoUtil" %>
<%@ page import="java.io.*" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.integration.logging.LoggerFactory" %>
<%@ page import="weaver.integration.logging.Logger" %>
<%@ page import="com.weavernorth.downfile.FileTest" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 同时设置服务器 + 客户端的字符集
    response.setContentType("text/html;charset=utf-8");

    try {
        Logger logger = LoggerFactory.getLogger(FileTest.class);
        logger.info("打日志测试");
    } catch (Exception e) {

    }


%>