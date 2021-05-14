<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    String str = "[{\"id\":1,\"crmcode\":\"0049001564\",\"name\":\"上海泛微网络科技股份有限公司\",\"Bank_country_code\":\"CN\",\"Bank_code\":\"305290002029\",\"bankName\":\"中国民生银行股份有限公司上海浦东支行\",\"bank_type\":\"\",\"Account_name\":\"上海泛微网络科技股份有限公司\",\"accounts\":\"0202014170007220\",\"Bank_Reference\":\"\",\"BSTRAS\":\"上海上海市\",\"LSTRAS\":\"上海市奉贤区环城西路3006号\",\"ZNAME\":\"Shanghai Weaver Network Technology Co., Ltd.\"}]";
%>
<script type="text/javascript">
    // $(function () {
    //
    //     $.ajax({
    //         type: "post",
    //         url: "/api/hrm/login/checkLogout",
    //         cache: false,
    //         async: true,
    //         data: {},
    //         dataType: 'json',
    //         success: function (myData) {
    //             window.parent.location.href = '/wui/index.html';
    //         }
    //     });
    //
    // })
    $("#datas").data(<%=str%>);
</script>


<body>
<input style="width: 100%"  id = 'datas'  value= <%=str%> />
<textarea style="display: none" id = 'textarr'> <%=str%></textarea>
</body>