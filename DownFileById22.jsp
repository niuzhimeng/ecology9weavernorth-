<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="java.util.zip.ZipFile" %>
<%@ page import="java.io.File" %>
<%@ page import="cn.hutool.core.io.FileUtil" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="org.apache.commons.io.FileUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // jsp下载文件有问题  同样代码换成servlet好使
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    File file = new File("E:\\WEAVER\\测试的文件你23ABC.pdf");
    String imagefilename = FileUtil.getName(file);

    String filerealpath = ""; // 文件全路径
    //  String imagefiletype = recordSet.getString("imagefiletype");
    String imagefiletype = "application/x-download";

    // 设置响应头打开方式
    response.reset();
    response.setHeader("content-disposition", "attachment;filename=\"" + URLEncoder.encode(imagefilename, "utf-8") + "\"");
    response.setDateHeader("Expires", -1);
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
    ServletContext servletContext = request.getSession().getServletContext();
    String mimeType = servletContext.getMimeType(imagefilename);
    baseBean.writeLog("mimeType: " + mimeType);
    response.setHeader("content-type", mimeType);
    // response.setContentType("application/x-download");

    FileUtils.copyFile(file, response.getOutputStream());
//    try (FileInputStream inputStream = new FileInputStream(file);
//         ServletOutputStream outputStream = response.getOutputStream();) {
//
//        byte[] bytes = new byte[1024 * 2];
//        int len;
//        while ((len = inputStream.read(bytes)) != -1) {
//            outputStream.write(bytes, 0, len);
//        }
//
//    } catch (Exception e) {
//        baseBean.writeLog("下载异常： " + e);
//    }

    // 开始解压
    //  InputStream inputStream;
//    try (ZipFile zipFile = new ZipFile(filerealpath)) {
//        Enumeration<?> entries = zipFile.entries();
//        if (entries.hasMoreElements()) {
//            ZipEntry entry = (ZipEntry) entries.nextElement();
//            inputStream = zipFile.getInputStream(entry);
//            ServletOutputStream outputStream = response.getOutputStream();
//            byte[] bytes = new byte[1024 * 2];
//            int len;
//            while ((len = inputStream.read(bytes)) != -1) {
//                outputStream.write(bytes, 0, len);
//            }
//            inputStream.close();
//        }
//
//        response.flushBuffer();
//    } catch (Exception e) {
//        baseBean.writeLog("GetFileById.jsp解压异常：" + e);
//    }

%>