<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="java.util.zip.ZipFile" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 根据附件id下载附件
    String fileId = request.getParameter("fileId");
    BaseBean baseBean = new BaseBean();
    baseBean.writeLog("下载文件开始，文件id： " + fileId);
    if ("".equals(fileId)) {
        out.clear();
        out.print("下载失败，文件id不能为空。");
        return;
    }

    RecordSet recordSet = new RecordSet();
    // 查询附件字段的sql
    String pathSql = "SELECT im.imagefiletype, im.imagefilename,im.filerealpath FROM ImageFile im LEFT JOIN DocImageFile df " +
            "ON df.imagefileid = im.imagefileid WHERE df.docid = '" + fileId + "'";
    recordSet.executeQuery(pathSql);
    if (recordSet.next()) {
        String imagefilename = recordSet.getString("imagefilename");
        String filerealpath = recordSet.getString("filerealpath"); // 文件全路径
        //  String imagefiletype = recordSet.getString("imagefiletype");
        String imagefiletype = "application/x-download";

        // 设置响应头打开方式
        response.reset();
        response.setHeader("content-disposition", "attachment;filename=" + URLEncoder.encode(imagefilename, "utf-8"));
        response.setDateHeader("Expires", -1);
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Pragma", "no-cache");
        //response.setHeader("content-type", imagefiletype);

        response.setContentType("application/x-download");

        // 开始解压
        InputStream inputStream;
        try (ZipFile zipFile = new ZipFile(filerealpath)) {
            Enumeration<?> entries = zipFile.entries();
            if (entries.hasMoreElements()) {
                ZipEntry entry = (ZipEntry) entries.nextElement();
                inputStream = zipFile.getInputStream(entry);
                ServletOutputStream outputStream = response.getOutputStream();
                byte[] bytes = new byte[1024 * 2];
                int len;
                while ((len = inputStream.read(bytes)) != -1) {
                    outputStream.write(bytes, 0, len);
                }
                inputStream.close();
            }

            response.flushBuffer();
        } catch (Exception e) {
            baseBean.writeLog("GetFileById.jsp解压异常：" + e);
        }
    } else {
        out.clear();
        out.print("下载失败，文件id不存在。");
        return;
    }

%>