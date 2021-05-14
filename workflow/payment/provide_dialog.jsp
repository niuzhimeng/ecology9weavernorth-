<%@page import="com.weavernorth.util.LogUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.BaseBean"  %>
<%@ page import="org.json.JSONArray"%>
<%@ page import="org.json.JSONException"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="com.weavernorth.workflow.payment.Purchase_order_SAP" %>
<%@ page import="com.weavernorth.util.LogUtil" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rshrm" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
   String issubmit = "1";
    String method=Util.null2String(request.getParameter("method"));
    String from=Util.null2String(request.getParameter("from"));
    issubmit=Util.null2String(request.getParameter("issubmit"));
%>
<HTML><HEAD>
    <link rel=stylesheet type="text/css" href="/css/Weaver_wev8.css">
    <style type="text/css">
        body{
            font-family:微软雅黑;

        }

        .tab_search{
            align:middle;
            border-bottom:1px solid;

            padding:5px;
            width:100%;
        }

        .tab_search tr{

            border:1px solid;
        }

        .tab_search_input{
            background-color:#EAEAEA;
            width:20%;
        }

        .div_show_result_area{
            text-align:center;
            width:100%;

        }
		.div_show_result_area1{
        	border:1px;
        	height:280px;
        	margin-left:20px;
        	margin-top:10px;
            float:left;
            width:100%;

        }
        .tab_show_result{
            width:100%;
            border-collapse:collapse;
        }

        .tab_show_result th{
            table-layout:fixed ;

            background-color:#4F81BD;
        }

        .tab_show_result th,.tab_show_result tr,.tab_show_result td{

            text-align:center;
            vertical-align:middle;
            border:1px solid #D4E9E9;
        }

        .span_description{
            font-weight:bold;

        }
        
        .input2{
        		height:13px;vertical-align:text-top;margin-top:0;
        }
    </style>
    <script language="javascript" src="/js/weaver_wev8.js"></script>
    <link rel="stylesheet" type="text/css" href="/workflow/exceldesign/css/excelHtml_wev8.css">
</HEAD>
<%
    String imagefilename = "/images/hdDOC_wev8.gif";
    String titlename = "查询PO";
    String needfav ="1";
    String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{查询,javascript:doSearch(),_self}" ;

    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{确定,javascript:confirm(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
    String operate = Util.null2String(request.getParameter("optionType"));
    String privadename = Util.null2String(request.getParameter("privadename"));
    String gysaccount = Util.null2String(request.getParameter("account")); // 防止代码查询页面无限刷新
    if("".equals(privadename) && "".equals(gysaccount)){
        // 再查询
    	 issubmit = "0";
    }else{
    	issubmit = "1";
    }
    String functionname ="ZCHN_MM_PO_GETINFO";
    //当前页
    int currentPageIndex = Util.getIntValue(Util.null2String(request.getParameter("currentPageIndex")),1);
    //页面显示行数
    int pageSize = 2;
    int currentFirstIndex = pageSize*(currentPageIndex-1);//第一条记录的序列
    int totalSize = Util.getIntValue(Util.null2String(request.getParameter("totalSize")),0);//总页码

    //供应商账号
    String account = Util.null2String(request.getParameter("account"));
    net.sf.json.JSONArray array = new net.sf.json.JSONArray();
    if(!account.equals("")||!privadename.equals("")) {
        Purchase_order_SAP order = new Purchase_order_SAP();
        array = order.getProvideInfo(account,privadename);
		LogUtil.debugLog("==供应商查询返回数据==>"+array.toString());
    }

    //数据总条数
    int size = array.size();
    //总数/每页条数
    int temp = size/pageSize;
    //余数大于0，总页数+1
    if(size%pageSize>0){
        totalSize =temp+1;
    }else{
        totalSize= temp;
    }
%>
<wea:layout attributes="{layoutTableId:topTitle}">
    <wea:group context="" attributes="{groupDisplay:none}">
        <wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="javascript:doSearch()" type="button" value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/>
			</span>
            <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
        </wea:item>
    </wea:group>
</wea:layout>
<FORM id="frmmain" name="frmmain" action="" method=post>
    <iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
    <input class=inputstyle type="hidden" name="destination" value="no">
    <input type="hidden" name="from" value="<%=from%>">
    <wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
        <wea:group context="查询条件" attributes="{'class':\"e8_title e8_title_1\",'samePair':'showgroup'}">

            <wea:item>供应商账号</wea:item>
            <wea:item>
                <INPUT type="text" class=Inputstyle  id="account" name="account" value="<%=account%>">
            </wea:item>
            <wea:item>供应商名称</wea:item>
            <wea:item>
                <INPUT type="text" class=Inputstyle  id="privadename" name="privadename" value="<%=privadename%>">
            </wea:item>
        </wea:group>
    </wea:layout>
    <input type="hidden" id="optionType" name="optionType" value='<%=operate%>' />
    <input type="hidden" id="issubmit" name="issubmit" value='<%=issubmit%>' />
    <input type="hidden" id="currentPageIndex" name="currentPageIndex" value="<%=currentPageIndex%>" />
</FORM>
<div class="div_show_result_area1">

<%
	  	int tempsize1 = currentFirstIndex+pageSize;
    	if(tempsize1>size){
        	tempsize1=size;
    	}
   		for(int i=currentFirstIndex; i<array.size();i++){
        	net.sf.json.JSONObject obj = array.getJSONObject(i);
	%>
		<p><input type="radio" notBeauty=true class="input1" id="selectRadio" name = "selectRadio" onClick="radioSelect(<%=i%>);" value=<%=i%>/><%=obj.get("name")%></p>
	<% 	
		} 
	%>
</div>	
<div class="div_show_result_area">
<%--	<input type=hidden id="jsonprovide" name="jsonprovide"  value='<%=array.toString()%>' />--%>
    <textarea style="display: none" id = 'jsonprovide'><%=array.toString()%></textarea>
    <table class="tab_show_result">
    <input type=hidden id="provideid" name="provideid"  value='' />
        <tr>
            <th>项目</th>
            <th>SAP中主数据值</th>
            <!--<th>OA中主数据值</th>
            <th>结果</th>-->
        </tr>
        <tr>
            <td>供应商或客户名称</td>
            <td id = 'providename'></td>
        </tr>
        <tr>
            <td>供应商或客户编码	</td>
            <td id = 'providecode'></td>
        </tr>
        <tr>
            <td>银行国家代码</td>
            <td id='countrybankcode'></td>
        </tr>
        <tr>
            <td>银行代码</td>
            <td id='bankcode'></td>
        </tr>
        <tr>
            <td>银行名称</td>
            <td id='bankname' ></td>
        </tr>
        <tr>
            <td>账户持人姓名</td>
            <td id='Account_name'></td>
        </tr>
        
        <tr>
            <td>银行账户号码</td>
            <td id='accounts'></td>
        </tr>
		<tr>
            <td>银行参考规定</td>
            <td id ='bankreference'></td>
        </tr>
        <tr>
            <td>银行地址</td>
            <td id ='BSTRAS'></td>
        </tr>
        <tr>
            <td>收款人地址</td>
            <td id ='LSTRAS'></td>
        </tr>
        <tr>
            <td>供应商英文描述</td>
            <td id ='ZNAME'></td>
        </tr>
        <tr>
            <td></td>
            <td><input type='button' value='确认' onclick='pareWingetData()'/></td>
        </tr>
    </table>
    <table class="tab_show_result">
        <tr><font size="3" color="red">请核对供应商信息主数据，无误后点击确认!</font></tr>
    </table>
</div>
<script src="http://code.jquery.com/jquery-1.11.0-beta1.js"></script>
<script language=javascript>
    jQuery(document).ready(function(){
    	var strjson = jQuery("#jsonprovide").text();
    	//alert(strjson);
    	var jsonstr = JSON.parse(strjson);
    	var leng = getJsonLength(jsonstr);
    	if(leng>0){
    		radioSelect(0);
    	}
        var issubmit = jQuery("#issubmit").val();
        if(0==issubmit){
            var issubmit = jQuery("#issubmit").val(1);
            doSearch();
        }
    });
    //获取父对象；
    var parentWin = parent.getParentWindow(window);
    var dialog =parent.getDialog(window);
    //搜索
    function doSearch(){
        var account = $("#account").val();
        var privadename = $("#privadename").val();
        //alert(WBS);
        if(account==""&&privadename==""){
            top.Dialog.alert("请输入查询条件");
        }else{
            document.frmmain.action="provide_dialog.jsp";
            document.frmmain.submit();
        }
    }



    //下一页
    function getNextPage(){
        var currentPageIndex =parseInt( $("#currentPageIndex").val());
        currentPageIndex = currentPageIndex+1
        $("#currentPageIndex").val(currentPageIndex);
        document.getElementById("weaver").submit();
    }
    //上一页
    function getProPage(){
        var currentPageIndex = parseInt($("#currentPageIndex").val());
        currentPageIndex = currentPageIndex-1
        $("#currentPageIndex").val(currentPageIndex);
        document.getElementById("weaver").submit();
    }
    //
    function onGoSearch(){
        weaver.destination.value="goSearch";
        weaver.submit();
    }
    //清除
    function onClear(){
        $('form input[type=text]').val('');

    }
    //radio点击事件
    function radioSelect(x){
    	jQuery("#provideid").val(x);
    	var strjson = jQuery("#jsonprovide").text();
    	var jsonstr = JSON.parse(strjson);
    	jQuery("#providename").html(jsonstr[x].name);
    	jQuery("#providecode").html(jsonstr[x].crmcode);
    	jQuery("#countrybankcode").html(jsonstr[x].Bank_country_code);
    	jQuery("#bankcode").html(jsonstr[x].Bank_code);
    	jQuery("#bankname").html(jsonstr[x].bankName);
    	jQuery("#Account_name").html(jsonstr[x].Account_name);
    	jQuery("#accounts").html(jsonstr[x].accounts);
    	jQuery("#bankreference").html(jsonstr[x].Bank_Reference);

    	jQuery("#BSTRAS").html(jsonstr[x].BSTRAS);
    	jQuery("#LSTRAS").html(jsonstr[x].LSTRAS);
    	jQuery("#ZNAME").html(jsonstr[x].ZNAME);
    }
    //流程表单赋值
    function pareWingetData(){
    	var x = jQuery("#provideid").val();
    	var strjson = jQuery("#jsonprovide").text();
    	var jsonstr = JSON.parse(strjson);
        parentWin.setProvideDataSAP(jsonstr[x]);
        dialog.close();
    }
    //判断json长度
    function getJsonLength(jsonData){  
        var jsonLength = 0;  
        for(var item in jsonData){  
            jsonLength++;  
        }  
        return jsonLength;  
    }
    
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</HTML>