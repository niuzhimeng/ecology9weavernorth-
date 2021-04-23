<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    BaseBean baseBean = new BaseBean();
    try {
        String key = request.getParameter("key");
        baseBean.writeLog("热词联想Start===========: " + key);
        JSONArray jsonArray = new JSONArray();
        if (key.startsWith("张")) {
            for (int i = 0; i < 100; i++) {
                jsonArray.put("张三" + i);
            }
        } else if (key.startsWith("李")) {
            for (int i = 0; i < 100; i++) {
                jsonArray.put("李四" + i);
            }
        }

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("key", "1");
        jsonObject.put("result", jsonArray);


        out.clear();
        out.print(jsonObject.toString());

    } catch (Exception e) {

        e.printStackTrace();
    }
%>