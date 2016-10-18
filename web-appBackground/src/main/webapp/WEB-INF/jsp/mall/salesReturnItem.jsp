<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../common/inc/meta.jsp"></jsp:include>
<jsp:include page="../common/inc/easyui.jsp"></jsp:include>
<style type="text/css">
.tableForm{
	width:100%;
}
.tableForm tr td{
	width:100px;
	line-height:30px;
}
</style>
<script type="text/javascript" charset="UTF-8">
	var datagrid;
	var commonDialog;
	var commonForm;
	
	$(function() {
		commonForm = $('#commonForm').form();
	

		datagrid = $('#datagrid').datagrid({
			url : '${pageContext.request.contextPath}/agreeSalesReturn/datagridOrderItem.do',
			toolbar : '#toolbar',
			title : '',
			iconCls : 'icon-save',
			pagination : true,
			pageSize : 10,
			pageList : [ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 ],
			fit : true,
			fitColumns : true,
			nowrap : false,
			border : false,
			singleSelect:false,
			idField : 'id',
			frozenColumns : [ [ {
				title : 'id',
				field : 'id',
				width : 50,
				hidden : false,
				checkbox : true
			},{
				field : 'goodsNo',
				title : '产品代码',
				width : 100,
			} ] ],
			columns :[[{
				field : 'goodsName',
				title : '产品名称',
				width : 100,
			},{
				field : 'price',
				title : '价格',
				width : 20,
			},{
				field : 'integral',
				title : '积分',
				width : 50,
			},{
				field : 'quantity',
				title : '数量',
				width : 50
			},{
				field : 'amount',
				title : '总额',
				width : 50
			},{
				field : 'totalScore',
				title : '总积分',
				width : 50
			}]],
			checkOnSelect: true,
			selectOnCheck: true,
			onLoadSuccess:function(data){       
				//console.log(data);
				if(data){
					$.each(data.rows, function(index, item){
						if(item.checked){
							$('#datagrid').datagrid('checkRow', index);
						}
					});
				}
			} 
		});

	});

	function append() {
		commonForm.form('clear');
		commonDialog.dialog('open');
		passwordInput.validatebox({
			required : true
		});
		commonForm.find('[name=name]').removeAttr('readonly');
	}

	function edit() {
		var rows = datagrid.datagrid('getSelections');
		if (rows.length != 1 && rows.length != 0) {
			var names = [];
			for (var i = 0; i < rows.length; i++) {
				names.push(rows[i].name);
			}
			$.messager.show({
				msg : '只能择一个商品进行编辑！您已经选择了【' + names.join(',') + '】'
						+ rows.length + '个商品',
				title : '提示'
			});
		} else if (rows.length == 1) {
			commonDialog.dialog('open');
			commonForm.form('clear');
			commonForm.form('load', {
				id : rows[0].id,
				name : rows[0].name,
			});
		}
	}



	function searchFun() {
		datagrid.datagrid('load',{
			name : $('#toolbar input[name=name]').val()
		});
	}
	function clearFun() {
		$('#toolbar input').val('');
		datagrid.datagrid('load', {});
	}
	function reloadFun(){
		datagrid.datagrid('reload');
	}
	
	function getCheck(){ 
		var checkedItems = $('#datagrid').datagrid('getChecked');
		var names = [];
		$.each(checkedItems, function(index, item){
			names.push(item.id);
		});
		console.log(names.join(","));
		$.post("${pageContext.request.contextPath}/deliveryManage/generateBill.do",{ids:names.join(",")},function(data){
			
		})
	 	window.location.href="${pageContext.request.contextPath}/deliveryManage/deliveryManage.do";
	}
	
	function printPdf(){
		window.open("${pageContext.request.contextPath}/report/views.do","_blank");			
	}
</script>
</head>
<body class="easyui-layout" fit="true">
	<div region="center" border="false" style="overflow: hidden;">
		<div id="toolbar" class="datagrid-toolbar"
			style="height: auto; display: none;">
			<fieldset>
				<legend>退款单产品信息</legend>
				<table class="tableForm">
					<input type="hidden" value="${refundM.id}" id="dpfId">
					<tr>
						<td>用户：${refundM.userName}</td>
						<td>退款单号:${refundM.orderNo}</td>
					<tr>
					<tr>
						<td>发退款时间:<fmt:formatDate value="${refundM.refundDatetime}" type="both"/></td>
						<td>是否收到货:
							<c:if test="${refundM.goodsReceived==1 }">
								收到货
							</c:if>
							<c:if test="${refundM.goodsReceived!=1 }">
								没有收到货
							</c:if>
						</td>
					</tr>
					<tr>
					</tr>
				</table>
					<div style="float:right">
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="printPdf()">发货单打印</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="window.location.href='${pageContext.request.contextPath}/agreeSalesReturn/agreeSalesReturn.do'">>>返回</a>
				</div>
			</fieldset>
			<div>
				<!-- <a class="easyui-linkbutton" iconCls="icon-add" id="ButonGetCheck"
					plain="true" href="javascript:void(0)" onclick="printPdf()">发货单打印</a> --><a
					class="easyui-linkbutton" iconCls="icon-edit" onclick="reloadFun();"
					plain="true" href="javascript:void(0);">刷新</a><a
					class="easyui-linkbutton" iconCls="icon-undo"
					onclick="datagrid.datagrid('unselectAll');" plain="true"
					href="javascript:void(0);">取消选中</a>
			</div>
		</div>
		<table id="datagrid"></table>
	</div>

	<div id="commonDialog" style="display: none; overflow: hidden;">
		<form id="commonForm" method="post">
			<table class="tableForm">
				<tr>
					<th>ID</th>
					<td><input name="id" readonly="readonly" /></td>
				</tr>
				<tr>
					<th>名称</th>
					<td>
						<input name="name" class="easyui-textbox" type="text" data-options="required:true" />
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>