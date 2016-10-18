<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../common/inc/meta.jsp"></jsp:include>
<jsp:include page="../common/inc/easyui.jsp"></jsp:include>
<script type="text/javascript" charset="UTF-8">
	var editRow;
	var treegrid;
	$(function() {

		treegrid = $('#treegrid').treegrid({
			url : '${pageContext.request.contextPath}/category/treegrid.do',
			toolbar : [ {
				text : '展开',
				iconCls : 'icon-redo',
				handler : function() {
					var node = treegrid.treegrid('getSelected');
					if (node) {
						treegrid.treegrid('expandAll', node.id);
					} else {
						treegrid.treegrid('expandAll');
					}
				}
			}, '-', {
				text : '折叠',
				iconCls : 'icon-undo',
				handler : function() {
					var node = treegrid.treegrid('getSelected');
					if (node) {
						treegrid.treegrid('collapseAll', node.id);
					} else {
						treegrid.treegrid('collapseAll');
					}
				}
			}, '-', {
				text : '刷新',
				iconCls : 'icon-reload',
				handler : function() {
					editRow = undefined;
					treegrid.treegrid('reload');
				}
			}, '-', {
				text : '增加',
				iconCls : 'icon-add',
				handler : function() {
					append();
				}
			}, '-', {
				text : '删除',
				iconCls : 'icon-remove',
				handler : function() {
					remove();
				}
			}, '-', {
				text : '编辑',
				iconCls : 'icon-edit',
				handler : function() {
					edit();
				}
			}, '-', {
				text : '保存',
				iconCls : 'icon-save',
				handler : function() {
					if (editRow) {
						treegrid.treegrid('endEdit', editRow.id);
					}
				}
			}, '-', {
				text : '取消编辑',
				iconCls : 'icon-undo',
				handler : function() {
					if (editRow) {
						treegrid.treegrid('cancelEdit', editRow.id);
						editRow = undefined;
					}
				}
			}, '-', {
				text : '取消选中',
				iconCls : 'icon-undo',
				handler : function() {
					treegrid.treegrid('unselectAll');
				}
			}, '-' ],
			title : '',
			iconCls : 'icon-save',
			fit : true,
			fitColumns : true,
			nowrap : true,
			animate : false,
			border : false,
			idField : 'id',
			treeField : 'text',
			frozenColumns : [ [ {
				title : 'id',
				field : 'id',
				width : 50,
				hidden : true
			}, {
				field : 'text',
				title : '类别名称',
				width : 150,
				editor : {
					type : 'validatebox',
					options : {
						required : true
					}
				},
				formatter : function(value) {
					if (value) {
						return sy.fs('<span title="{0}">{1}</span>', value, value);
					}
				}
			} ] ],
			columns : [ [ {
				field : 'description',
				title : '描述',
				width : 100,
				editor : {
					type : 'text'
				}
			}, {
				field : 'seq',
				title : '排序',
				width : 50,
				editor : {
					type : 'numberbox',
					options : {
						min : 0,
						max : 999,
						required : true
					}
				}
			}, {
				field : 'parentId',
				title : '上级资源',
				width : 150,
				hidden : false,
				formatter : function(value, rowData, rowIndex) {
					return rowData.parentText;
				},
				editor : {
					type : 'combotree',
					options : {
						url : '${pageContext.request.contextPath}/category/tree.do',
						animate : false,
						lines : !sy.isLessThanIe8(),
						onLoadSuccess : function(node, data) {
							var t = $(this);
							if (data) {
								$(data).each(function(index, d) {
									if (this.state == 'closed') {
										t.tree('expandAll');
									}
								});
							}
						}
					}
				}
			},{
				field : 'parentText',
				title : '上级类别',
				width : 80,
				hidden : true
			}] ],
			onDblClickRow : function(row) {
				if (editRow) {
					$.messager.show({
						msg : '您没有结束之前编辑的数据，请先保存或取消编辑！',
						title : '提示'
					});
				} else {
					treegrid.treegrid('beginEdit', row.id);
					editRow = row;
				}
			},
			onAfterEdit : function(row, changes) {
				if (row.parentId != row.id) {
					$.ajax({
						url : '${pageContext.request.contextPath}/category/edit.do',
						data : row,
						cache : false,
						dataType : "json",
						success : function(r) {
							if (r.success) {
								$.messager.show({
									msg : r.msg,
									title : '提示'
								});
								treegrid.treegrid('reload');
								editRow = undefined;
							} else {
								$.messager.show({
									msg : '保存失败!',
									title : '提示'
								});
							}
						}
					});
				} else {
					$.messager.show({
						msg : '保存失败，上级类别不可以是自己!',
						title : '提示'
					});
				}
			},
			onContextMenu : function(e, row) {
				e.preventDefault();
				$(this).treegrid('unselectAll');
				$(this).treegrid('select', row.id);
				$('#menu').menu('show', {
					left : e.pageX,
					top : e.pageY
				});
			},
			onLoadSuccess : function(row, data) {
				var t = $(this);
				if (data) {
					$(data).each(function(index, d) {
						if (this.state == 'closed') {
							t.treegrid('expandAll');
						}
					});
				}
			},
			onExpand : function(row) {
				treegrid.treegrid('unselectAll');
			},
			onCollapse : function(row) {
				treegrid.treegrid('unselectAll');
			}
		});

	});

	function edit() {
		if (editRow) {
			$.messager.show({
				msg : '您没有结束之前编辑的数据，请先保存或取消编辑！',
				title : '提示'
			});
		} else {
			var node = treegrid.treegrid('getSelected');
			if (node && node.id) {
				treegrid.treegrid('beginEdit', node.id);
				editRow = node;
			}
		}
	}
	function append() {
		if (editRow) {
			$.messager.show({
				msg : '您没有结束之前编辑的数据，请先保存或取消编辑！',
				title : '提示'
			});
		} else {
			var node = treegrid.treegrid('getSelected');
			var data = [ {
				id : sy.UUID(),
				text : '新资源',
				seq : 999,
				parentId : (node ? node.id : '')
			} ];
			var opts = {
				parent : data[0].parentId,
				data : data
			};
			$.ajax({
				url : '${pageContext.request.contextPath}/category/add.do',
				data : data[0],
				cache : false,
				dataType : "json",
				success : function(r) {
					if (r.success) {
						treegrid.treegrid('append', opts);
						treegrid.treegrid('beginEdit', data[0].id);
						editRow = data[0];
					} else {
						$.messager.show({
							msg : '添加类别失败!',
							title : '提示'
						});
					}
				}
			});
		}
	}
	function remove() {
		var node = treegrid.treegrid('getSelected');
		if (node) {
			$.messager.confirm('询问', '您确定要删除【' + node.text + '】类别？', function(b) {
				if (b) {
					$.ajax({
						url : '${pageContext.request.contextPath}/category/del.do',
						data : {
							id : node.id
						},
						cache : false,
						dataType : "json",
						success : function(r) {
							if (r.success) {
								treegrid.treegrid('reload');
								$.messager.show({
									msg : r.msg,
									title : '提示'
								});
								editRow = undefined;
							} else {
								$.messager.show({
									msg : '删除失败!',
									title : '提示'
								});
							}
						}
					});
				}
			});
		}
	}
</script>
</head>
<body class="easyui-layout" fit="true">
	<div region="center" border="false" style="overflow: hidden;">
		<table id="treegrid"></table>
	</div>

	<!-- <div id="menu" class="easyui-menu" style="width:120px;display: none;">
		<div onclick="append();" iconCls="icon-add">增加</div>
		<div onclick="remove();" iconCls="icon-remove">删除</div>
		<div onclick="edit();" iconCls="icon-edit">编辑</div>
	</div> -->
</body>
</html>