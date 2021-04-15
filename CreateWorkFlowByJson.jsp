<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.mytest.file2other.DocCreateUtil" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.webservices.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    RecordSet updateSet = new RecordSet();
    RecordSet recordSet = new RecordSet();
    BaseBean baseBean = new BaseBean();
    //创建流程的类
    WorkflowServiceImpl service = new WorkflowServiceImpl();

    // SJTX-科研项目支票领用单(内网)——流程id
    String workFlowId = baseBean.getPropValue("fileToOther", "workFlowId");
    // 建模表名
    String tableName = baseBean.getPropValue("fileToOther", "tableName");
    // 内网流程 —— 文件目录id
    int muLuId = Util.getIntValue(baseBean.getPropValue("fileToOther", "muLuId"));
    // 文件上传身份 用户名 密码
    String userName = baseBean.getPropValue("fileToOther", "userName");
    String password = baseBean.getPropValue("fileToOther", "password");
    String updateSql = "update " + tableName + " set zt = ?, bz = ? where id = ?";
    try {
        long start = System.currentTimeMillis();
        baseBean.writeLog("批量创建内网流程Start===========流程id： "+ workFlowId);
        recordSet.executeQuery("SELECT * FROM " + tableName + " where zt = 0 or zt IS NULL");
        baseBean.writeLog("本次需创建流程数量： " + recordSet.getCounts());
        while (recordSet.next()) {
            String id = recordSet.getString("id");
            String jbr = recordSet.getString("jbr");
            WorkflowRequestTableField[] mainField = new WorkflowRequestTableField[10]; //主表行对象
            int i = 0;
            mainField[i] = new WorkflowRequestTableField();
            mainField[i].setFieldName("sqrq");// 申请日期
            mainField[i].setFieldValue(recordSet.getString("sqrq")); // 字段值
            mainField[i].setView(true);
            mainField[i].setEdit(true);

            i++;
            mainField[i] = new WorkflowRequestTableField();
            mainField[i].setFieldName("jbr");
            mainField[i].setFieldValue(jbr); // 经办人
            mainField[i].setView(true);
            mainField[i].setEdit(true);

            i++;
            mainField[i] = new WorkflowRequestTableField();
            mainField[i].setFieldName("jkbm");
            mainField[i].setFieldValue(recordSet.getString("jkbm")); // 借款部门
            mainField[i].setView(true);
            mainField[i].setEdit(true);

            i++;
            mainField[i] = new WorkflowRequestTableField();
            mainField[i].setFieldName("zpskdwqc");
            mainField[i].setFieldValue(recordSet.getString("zpskdwqc")); // 支票收款单位全称
            mainField[i].setView(true);
            mainField[i].setEdit(true);

            i++;
            mainField[i] = new WorkflowRequestTableField();
            mainField[i].setFieldName("jkje");
            mainField[i].setFieldValue(recordSet.getString("jkje")); // 借款金额
            mainField[i].setView(true);
            mainField[i].setEdit(true);

            i++;
            mainField[i] = new WorkflowRequestTableField();
            mainField[i].setFieldName("jkyt");
            mainField[i].setFieldValue(recordSet.getString("jkyt")); // 借款用途
            mainField[i].setView(true);
            mainField[i].setEdit(true);

            i++;
            mainField[i] = new WorkflowRequestTableField();
            mainField[i].setFieldName("xmgd");
            mainField[i].setFieldValue(recordSet.getString("xmgd")); // 项目工单
            mainField[i].setView(true);
            mainField[i].setEdit(true);

            String sessionStr = DocCreateUtil.getDocSession(userName, password);
            String wjl = DocCreateUtil.createNewDoc(sessionStr, recordSet.getString("wjl"), muLuId);
            baseBean.writeLog("文件id值： " + wjl);
            i++;
            mainField[i] = new WorkflowRequestTableField();
            mainField[i].setFieldName("xgfj"); // 相关附件
            mainField[i].setFieldValue(wjl);
            mainField[i].setView(true);
            mainField[i].setEdit(true);

            WorkflowRequestTableRecord[] mainRecord = new WorkflowRequestTableRecord[1];// 主字段只有一行数据
            mainRecord[0] = new WorkflowRequestTableRecord();
            mainRecord[0].setWorkflowRequestTableFields(mainField);

            WorkflowMainTableInfo workflowMainTableInfo = new WorkflowMainTableInfo();
            workflowMainTableInfo.setRequestRecords(mainRecord);

            //==========================================明细字段
            WorkflowDetailTableInfo[] detailTableInfos = new WorkflowDetailTableInfo[0];// 明细表数组
            //====================================流程基本信息录入
            WorkflowBaseInfo workflowBaseInfo = new WorkflowBaseInfo();
            workflowBaseInfo.setWorkflowId(workFlowId);// 流程id

            WorkflowRequestInfo workflowRequestInfo = new WorkflowRequestInfo();// 流程基本信息
            workflowRequestInfo.setCreatorId(jbr);// 创建人id
            workflowRequestInfo.setRequestLevel("0");// 0 正常，1重要，2紧急
            workflowRequestInfo.setRequestName(recordSet.getString("lcbt"));// 流程标题
            workflowRequestInfo.setWorkflowBaseInfo(workflowBaseInfo);
            workflowRequestInfo.setWorkflowMainTableInfo(workflowMainTableInfo);// 添加主表字段数据
            workflowRequestInfo.setWorkflowDetailTableInfos(detailTableInfos);// 添加明细表字段数据
            workflowRequestInfo.setIsnextflow("0");

            String requestId = service.doCreateWorkflowRequest(workflowRequestInfo, Integer.parseInt(jbr));
            baseBean.writeLog("创建流程完毕=============== " + requestId);

            int requestIdInt = Util.getIntValue(requestId);
            String flag = requestIdInt > 0 ? "1" : "0";
            String flowMes = getFlowMes(requestIdInt);

            // 更新数据状态
            updateSet.executeUpdate(updateSql, flag, flowMes, id);
        }
        long end = System.currentTimeMillis();
        baseBean.writeLog("批量创建内网流程End===========耗时：" + (end - start) + " 毫秒");
    } catch (Exception e) {
        baseBean.writeLog("对公付款创建流程异常： " + e);
    }

    JSONObject jsonObject = new JSONObject();
    jsonObject.put("myState", "执行完成");
    out.clear();
    out.print(jsonObject.toString());

%>

<%!
    public static String getFlowMes(int returnInt) {
        String errStr = "";
        if (returnInt > 0) {
            errStr = "流程创建成功, requestId = " + returnInt;
        } else if (returnInt == -1) {
            errStr = "流程创建失败";
        } else if (returnInt == -2) {
            errStr = "没有创建权限";
        } else if (returnInt == -3) {
            errStr = "流程创建失败";
        } else if (returnInt == -4) {
            errStr = "字段或表名不正确";
        } else if (returnInt == -5) {
            errStr = "更新流程级别失败";
        } else if (returnInt == -6) {
            errStr = "无法创建流程待办任务";
        } else if (returnInt == -7) {
            errStr = "流程下一节点出错，请检查流程的配置，在OA中发起流程进行测试";
        } else if (returnInt == -8) {
            errStr = "流程节点自动赋值操作错误";
        }
        return errStr;
    }
%>




