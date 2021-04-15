<%@ page import="com.weavernorth.meitanzy.util.MeiTanConfigInfo" %>
<%@ page import="com.weavernorth.meitanzy.util.MeiTanZyFtpUtil" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.commons.net.ftp.FTPClient" %>
<%@ page import="org.apache.commons.net.ftp.FTPReply" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.File" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.FileInputStream" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyRtxLogin" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%

    BaseBean baseBean = new BaseBean();
    try {
        baseBean.writeLog("获取文件开始");
        File file = new File("d:\\QitaAZB\\weaver\\ecology\\weavernorth\\测试123.txt");
        String name = file.getName();
        name = new String(name.getBytes("gbk"), StandardCharsets.ISO_8859_1);
        InputStream inputStream = new FileInputStream(file);

        String currentDate = "202010";
        String htbm = "002";
        String fieldName = "testzd";
        String savePath = "/home/document/" + MeiTanConfigInfo.DWBM.getValue() + "/" + currentDate + "/" + htbm + "/" + fieldName + "/";

        // 获取ftp对象
        FTPClient ftpClient = MeiTanZyFtpUtil.getFtpClient(MeiTanConfigInfo.FTP_URL.getValue(), Integer.parseInt(MeiTanConfigInfo.FTP_PORT.getValue()),
                "cqyjyftp", "cqyjyftp");
        boolean b1 = ftpClient.changeWorkingDirectory(savePath);
        baseBean.writeLog("目录切换结果： " + b1);
        MeiTanZyFtpUtil.upload(savePath,name, inputStream, ftpClient);

        MeiTanZyFtpUtil.disconnect(ftpClient);

        inputStream.close();
    } catch (Exception e) {
        baseBean.writeLog("上传测试异常： " + e);
    }
%>

<%!
    /**
     * 连接 FTP 服务器
     *
     * @param addr     FTP 服务器 IP 地址
     * @param port     FTP 服务器端口号
     * @param username 登录用户名
     * @param password 登录密码
     * @return
     * @throws Exception
     */
    public static FTPClient connectFtpServer(String addr, int port, String username, String password) {
        BaseBean baseBean = new BaseBean();
        FTPClient ftpClient = new FTPClient();
        try {
            /**设置文件传输的编码*/
            ftpClient.setControlEncoding("utf-8");

            /**连接 FTP 服务器
             * 如果连接失败，则此时抛出异常，如ftp服务器服务关闭时，抛出异常：
             * java.net.ConnectException: Connection refused: connect*/
            ftpClient.connect(addr, port);
            /**登录 FTP 服务器
             * 1）如果传入的账号为空，则使用匿名登录，此时账号使用 "Anonymous"，密码为空即可*/
            if (StringUtils.isBlank(username)) {
                ftpClient.login("Anonymous", "");
            } else {
                ftpClient.login(username, password);
            }

            /** 设置传输的文件类型
             * BINARY_FILE_TYPE：二进制文件类型
             * ASCII_FILE_TYPE：ASCII传输方式，这是默认的方式
             * ....
             */
            ftpClient.setFileType(FTPClient.BINARY_FILE_TYPE);

            /**
             * 确认应答状态码是否正确完成响应
             * 凡是 2开头的 isPositiveCompletion 都会返回 true，因为它底层判断是：
             * return (reply >= 200 && reply < 300);
             */
            int reply = ftpClient.getReplyCode();
            baseBean.writeLog("reply: " + reply);
            if (!FTPReply.isPositiveCompletion(reply)) {
                /**
                 * 如果 FTP 服务器响应错误 中断传输、断开连接
                 * abort：中断文件正在进行的文件传输，成功时返回 true,否则返回 false
                 * disconnect：断开与服务器的连接，并恢复默认参数值
                 */
                ftpClient.abort();
                ftpClient.disconnect();
            }
        } catch (IOException e) {
            baseBean.writeLog(">>>>>FTP服务器连接登录失败，请检查连接参数是否正确，或者网络是否通畅*********: " + e);
        }
        return ftpClient;
    }
%>

