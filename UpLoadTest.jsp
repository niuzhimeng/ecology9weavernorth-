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
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 文件上传，使用阿帕奇的包
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("上传文件开始");
    // 同时设置服务器 + 客户端的字符集
    response.setContentType("text/html;charset=utf-8");

    try {
        // 产生关键对象upload，该对象用来取数据
        FileItemFactory factory = new DiskFileItemFactory();

        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setFileSizeMax(2 * 1024 * 1024);//设置单个文件上传的大小
        //  parser.setSizeMax(6*1024*1024);//多文件上传时总大小限制
        // 把request中的数据装换成FileItem的集合
        List<FileItem> itemList = upload.parseRequest(request);
        for (FileItem fileItem : itemList) {
            // 字段名
            String fieldName = fileItem.getFieldName();
            if (fileItem.isFormField()) {
                // 普通字段
                String value = fileItem.getString("utf-8");
                baseBean.writeLog("fieldName: " + fieldName + "; value: " + value);
            } else {
                // 文件
                String name = fileItem.getName();
                baseBean.writeLog("fieldName: " + fieldName + "; 文件名: " + name);
//                FileUtil.file()
//                File file = new File("D:/uploadTest/" + name);
//                fileItem.write(file);

                InputStream inputStream = new BufferedInputStream(fileItem.getInputStream());
                OutputStream outputStream = FileUtil.getOutputStream("E:/WEAVER/ecology/weavernorth/uploadTest/" + name);
                long copySize = IoUtil.copy(inputStream, outputStream, IoUtil.DEFAULT_BUFFER_SIZE);
                baseBean.writeLog("复制文件大小：" + copySize);

                IoUtil.close(inputStream);
                IoUtil.close(outputStream);
            }
        }

    } catch (Exception e) {
        baseBean.writeLog("上传文件err： " + e);
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("myStatus", false);
        jsonObject.put("message", e.getMessage());
        out.clear();
        out.print(jsonObject.toJSONString());
        return;
    }

    JSONObject jsonObject = new JSONObject();
    jsonObject.put("myStatus", true);
    jsonObject.put("myMessage", "ok");
    out.clear();
    out.print(jsonObject.toJSONString());
    return;

%>