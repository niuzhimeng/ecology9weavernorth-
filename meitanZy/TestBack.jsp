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
        baseBean.writeLog("��ȡ�ļ���ʼ");
        File file = new File("d:\\QitaAZB\\weaver\\ecology\\weavernorth\\����123.txt");
        String name = file.getName();
        name = new String(name.getBytes("gbk"), StandardCharsets.ISO_8859_1);
        InputStream inputStream = new FileInputStream(file);

        String currentDate = "202010";
        String htbm = "002";
        String fieldName = "testzd";
        String savePath = "/home/document/" + MeiTanConfigInfo.DWBM.getValue() + "/" + currentDate + "/" + htbm + "/" + fieldName + "/";

        // ��ȡftp����
        FTPClient ftpClient = MeiTanZyFtpUtil.getFtpClient(MeiTanConfigInfo.FTP_URL.getValue(), Integer.parseInt(MeiTanConfigInfo.FTP_PORT.getValue()),
                "cqyjyftp", "cqyjyftp");
        boolean b1 = ftpClient.changeWorkingDirectory(savePath);
        baseBean.writeLog("Ŀ¼�л������ " + b1);
        MeiTanZyFtpUtil.upload(savePath,name, inputStream, ftpClient);

        MeiTanZyFtpUtil.disconnect(ftpClient);

        inputStream.close();
    } catch (Exception e) {
        baseBean.writeLog("�ϴ������쳣�� " + e);
    }
%>

<%!
    /**
     * ���� FTP ������
     *
     * @param addr     FTP ������ IP ��ַ
     * @param port     FTP �������˿ں�
     * @param username ��¼�û���
     * @param password ��¼����
     * @return
     * @throws Exception
     */
    public static FTPClient connectFtpServer(String addr, int port, String username, String password) {
        BaseBean baseBean = new BaseBean();
        FTPClient ftpClient = new FTPClient();
        try {
            /**�����ļ�����ı���*/
            ftpClient.setControlEncoding("utf-8");

            /**���� FTP ������
             * �������ʧ�ܣ����ʱ�׳��쳣����ftp����������ر�ʱ���׳��쳣��
             * java.net.ConnectException: Connection refused: connect*/
            ftpClient.connect(addr, port);
            /**��¼ FTP ������
             * 1�����������˺�Ϊ�գ���ʹ��������¼����ʱ�˺�ʹ�� "Anonymous"������Ϊ�ռ���*/
            if (StringUtils.isBlank(username)) {
                ftpClient.login("Anonymous", "");
            } else {
                ftpClient.login(username, password);
            }

            /** ���ô�����ļ�����
             * BINARY_FILE_TYPE���������ļ�����
             * ASCII_FILE_TYPE��ASCII���䷽ʽ������Ĭ�ϵķ�ʽ
             * ....
             */
            ftpClient.setFileType(FTPClient.BINARY_FILE_TYPE);

            /**
             * ȷ��Ӧ��״̬���Ƿ���ȷ�����Ӧ
             * ���� 2��ͷ�� isPositiveCompletion ���᷵�� true����Ϊ���ײ��ж��ǣ�
             * return (reply >= 200 && reply < 300);
             */
            int reply = ftpClient.getReplyCode();
            baseBean.writeLog("reply: " + reply);
            if (!FTPReply.isPositiveCompletion(reply)) {
                /**
                 * ��� FTP ��������Ӧ���� �жϴ��䡢�Ͽ�����
                 * abort���ж��ļ����ڽ��е��ļ����䣬�ɹ�ʱ���� true,���򷵻� false
                 * disconnect���Ͽ�������������ӣ����ָ�Ĭ�ϲ���ֵ
                 */
                ftpClient.abort();
                ftpClient.disconnect();
            }
        } catch (IOException e) {
            baseBean.writeLog(">>>>>FTP���������ӵ�¼ʧ�ܣ��������Ӳ����Ƿ���ȷ�����������Ƿ�ͨ��*********: " + e);
        }
        return ftpClient;
    }
%>

