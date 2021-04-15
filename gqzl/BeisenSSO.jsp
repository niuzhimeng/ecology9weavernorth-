<%@ page import="com.weavernorth.gqzl.BeisenSSO.oidcsdk.provider.BeisenTokenProvider" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    //SSO地址
    String ssourl = "https://oapi.italent.cn/SSO/AuthCenter?id_token=";
    //跳转地址
    String url = "&return_url=http://www.italent.cn/124834313/ITalentHome#widget%2Fitalent%3FiTalentFrameType%3Diframe%26iTalentNavId%3D5158%26iTalentNavCode%3Ditalent-home%26iTalentFrame%3Dhttp%253A%252F%252Fwww.italent.cn%252F124834313%252FPageBuilder%2523%252FHomePage%26";
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    try {
        baseBean.writeLog("uid--------------> " + user.getUID());
        recordSet.execute("select email from hrmresource where id = '"+user.getUID()+"'");
        String email = "";
        if (recordSet.next()) {
            email = recordSet.getString("email");
            baseBean.writeLog("email--->> " + email);
            String id_token = BeisenTokenProvider.GenerateBeisenIDToken(email,"0");
            if (!"".equals(id_token)) {
                baseBean.writeLog("id_token--------------> " + id_token);
                String realUrl = ssourl+id_token+url;
                response.sendRedirect(realUrl);
            } else {
                out.clear();
            }
        }
    } catch (Exception e) {
        baseBean.writeLog("单点北森系统异常： " + e);
    }
%>