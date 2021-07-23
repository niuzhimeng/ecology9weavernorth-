<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<script type="text/javascript">

    $(function () {
        $.ajax({
            type: "post",
            url: "/api/hrm/login/checkLogout",
            cache: false,
            async: true,
            data: {},
            dataType: 'json',
            success: function (myData) {
                window.parent.location.href = '/wui/index.html';
            }
        });

    })

</script>


