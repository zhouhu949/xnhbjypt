<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html style="background:#f1f6f9;">
<head>
<link href="<%=request.getContextPath()%>/resources/css/test/style1.css" rel="stylesheet" type="text/css" media="all"/>
<link href="<%=request.getContextPath()%>/resources/css/test/style4.css" rel="stylesheet" type="text/css" media="all"/>
<jsp:include page="../test/head.jsp"></jsp:include>
<style type="text/css">
.coinBoxBody {
	background: none repeat scroll 0 0 #ffffff;
	*padding: 4px 3px;
	padding: 0 10px;
}
.security li{
    padding: 10px 0;
}
li span.c1 {
    display: inline-block;
    width: 180px;
    text-align: right;
    padding-right: 20px;
}

.inputStyle {
    height: 25px;
}
.red {
    color: red;
}
.buttonblue3 {
	display: inline-block;
	font-weight: 700;
	font-size: 14px;
	color: #fff;
	text-align: center;
	width: 120px;
	height: 32px;
	line-height: 32px;
	background: #ec5322;
	margin-left: 120px;
	border-radius: 3px
}
//-----------
.Areacon {
	font-size: 14px;
	background: #fff;
	border: 1px solid #e1e1e2;
	padding: 30px 30px 0;
	float: left;
	width: 953px;
	min-height: 542px;
}
.clear {
    zoom: 1;
    clear: both;
}
.Tentitle {
	line-height: 35px;
	font-weight: 700;
	font-size: 14px;
	padding: 10px 10px;
	background: #fff;
}
.coinBoxBody {
	background: none repeat scroll 0 0 #ffffff;
	*padding: 4px 3px;
	padding: 0 10px;
}
.userSetBtn {
	display: inline-block;
	font-weight: 700;
	font-size: 14px;
	color: #fff;
	text-align: center;
	width: 120px;
	height: 32px;
	line-height: 32px;
	background-color: #66b2e3;
	border-radius: 3px;
}

//question
.initiateProblem{
	background:none repeat scroll 0 0 #ffffff;
	padding:0 10px;
}
.initiateProblem .specificContent{
	width:740px;
	padding-left:20px;
	padding-top:10px;
	height: 250px;
}
.questionButtonblue{
	display:inline-block;
	font-weight:700;
	font-size:14px;
	color:#fff;
	text-align:center;
	width:150px;
	height:32px;
	line-height:32px;
	background-color:#66b2e3;
	margin:30px 0 76px 180px;
	border-radius: 3px;
}
pan.c2 {
    display: inline-block;
    font-size: 14px;
    font-weight: 700;
    padding-left: 20px;
    text-align: left;
}

#specificContent ul li {
    line-height: 35px;
    float: left;
    padding-bottom: 10px;
}

</style>
<script type="text/javascript">

$(function(){
	if('${sessionScope.frontUserM.realName}'){
		$('#user_setting1').hide();
		$('#user_setting2').hide();
		$('#safe_setting').show();
	}else {
		$('#user_setting1').show();
		$('#user_setting2').hide();
		$('#safe_setting').hide();
	}
	
	//修改菜单头图片
	$("#index").attr('src', "<%=request.getContextPath()%>/resources/img/test/navHome.png"); 
	$("#trade").attr('src', "<%=request.getContextPath()%>/resources/img/test/navTrade.png"); 
	$("#finance").attr('src', "<%=request.getContextPath()%>/resources/img/test/navFinance.png"); 
	$("#safe").attr('src', "<%=request.getContextPath()%>/resources/img/test/navSafe2.png"); 
	$("#news").attr('src', "<%=request.getContextPath()%>/resources/img/test/navNews.png"); 
});

//验证两次姓名一样
function checkRealName(){
	var realName = trim($('#realName').val());
	var realName2 = trim($('#realName2').val());
	
	if(realName == ''){
		$('#errorMessage').html('请填写姓名 ');
		return false;		
	}else if(realName2 != realName){
		$('#errorMessage').html('两次输入的姓名不一致');
		return false;
	}else {
		$('#errorMessage').html('');
		return true;
	}
}

//提交
function validateIdentity(){
	if(!checkRealName())
		return;
	
	var cardNumber = trim($('#cardNumber').val());
	if(cardNumber == ''){
		$('#errorMessage').html('请填写证件号码');		
		return;
	}
	
	var dataPara = $('#validateIdentityForm').serializeArray();
	$.ajax({
		url : '${pageContext.request.contextPath}/safe.do?validateIdentity',
		type : 'post',
		data : dataPara,
		success : function(data) {
			var d = $.parseJSON(data);
			if (d.success == true) {
				$('#user_setting1').hide();
				$('#user_setting2').show();
				$('#uid').html(d.obj.uid);
				$('#email').html(d.obj.email);
				$('#nickName').html(d.obj.nickName);
				$('#show_realName').html(d.obj.realName);
			} 
		}
	});
}


//修改用户昵称
function submitUserinfoForm(){
	var old_nickName = '${sessionScope.frontUserM.nickName}';
	var new_nickName = $('#nickName').val();
	
	if(new_nickName == old_nickName)
		return;
	
	var dataPara = $('#userinfoForm').serializeArray();
	$.ajax({
		url : '${pageContext.request.contextPath}/safe.do?updateNickName',
		type : 'post',
		data : dataPara,
		success : function(data) {
			var d = $.parseJSON(data);
			if (d.success == true) {
				console.info('${sessionScope.frontUserM.nickName}');
			} 
		}
	});
}

//显示哪部分
function showItem(item){
	/* $("#safe_setting_img").removeClass("hover");
	$("#user_setting_img").removeClass("hover");
	$("#ask_question_img").removeClass("hover");
	$("#question_list_img").removeClass("hover");
	$("#msg_center_img").removeClass("hover"); */
	
	$('#safe_setting').hide();
	$('#user_setting2').hide();
	$('#ask_question').hide();
	
	
	if(item == "safe"){
		$("#safe_setting_img").addClass("hover");
		$('#safe_setting').show();
	}else if(item == "user"){
		$("#user_setting_img").addClass("hover");
		$('#user_setting2').show();
	}else if(item == "ask"){
		$("#ask_question_img").addClass("hover");
		$('#ask_question').show();
	}else if(item == "question"){
		$("#question_list_img").addClass("hover");
	}else if(item == "msg"){
		$("#msg_center_img").addClass("hover");
	}
}

</script>
</head>
<body style="background:#f1f6f9;">
<div class="ad_main">
	
	<div class="safe_tip">
		<span>重要提示：</span>	
		客服不会要求用QQ远程控制您的计算机,所有要求远程的都是骗子。短信验证码、谷歌验证码非常重要，请勿透露给任何人，包括客服。
	</div>
	
	<div class="ad_aside">
		<a href="#" id="safe_setting_img" onclick="javascript:showItem('safe');" class="hover"><img src="<%=request.getContextPath()%>/resources/img/test/safe_ico1.png" />安全设置<i></i></a>
		<a href="#" id="user_setting_img"  onclick="javascript:showItem('user');" ><img src="<%=request.getContextPath()%>/resources/img/test/safe_ico2.png" />用户设置<i></i></a>
		<a href="#" id="ask_question_img"  onclick="javascript:showItem('ask');"><img src="<%=request.getContextPath()%>/resources/img/test/safe_ico3.png" />发起问题<i></i></a>
		<a href="#" id="question_list_img"  onclick="javascript:showItem('questiong');"><img src="<%=request.getContextPath()%>/resources/img/test/safe_ico4.png" />问题列表<i></i></a>
		<a href="#" id="msg_center_img"  onclick="javascript:showItem('msg');" class="bottom"><img src="<%=request.getContextPath()%>/resources/img/test/safe_ico5.png" />消息中心<i></i></a>
	</div>
	
	<div class="safe_section" id="safe_setting" style="display: none;">
		
		<div class="safe_item">
			<span class="tit">谷歌验证</span>
			<div class="tip">提现，修改密码，及安全设置时用以输入谷歌验证码。 下载:Andriod/IOS</div>
			<a href="#" class="go_btn">立即验证</a>
			<div class="clear"></div>	
		</div>
		<div class="safe_item">
			<span class="tit">短信验证</span>
			<div class="tip">手机号码： <span class="blue">15088723092</span>   提现，修改密码，及安全设置时用以收取验证短信</div>
			<a href="#" class="go_btn">重置</a>
			<div class="clear"></div>	
		</div>
		<div class="safe_item safe_itemhover">
			<span class="tit">邮箱验证</span>
			<div class="tip">用于登录和找回密码</div>
			<a href="#" class="go_btn">立即验证</a>
			<div class="clear"></div>	
		</div>
		<div class="safe_item ">
			<span class="tit">登录密码</span>
			<div class="tip">开通短信验证或谷歌验证才能进行设置</div>
			<a href="#" class="go_btn">重置</a>
			<div class="clear"></div>	
		</div>
		<div class="safe_item safe_itemend">
			<span class="tit">交易密码</span>
			<div class="tip">开通短信验证或谷歌验证才能进行设置</div>
			<a href="#" class="go_btn">立即验证</a>
			<div class="clear"></div>	
		</div>
		
		<div class="clear"></div>	
	</div>
	
	<div class="safe_section" id="user_setting1" style="display: none;">
		<div class="safe_item safe_itemhover">
			<span class="">实名认证信息</span>
			<div class="clear"></div>	
		</div>
		
		<div class="coinBoxBody">
			<form method="post" enctype="multipart/form-data" id="validateIdentityForm" >
				<ul class="security">
					<li>
						<span class="c1">
							真实姓名:
						</span>
						<span>
							<input type="text" onblur="javascript:checkRealName();" class="inputStyle" value="" name="realName" id="realName">
						</span>
						&nbsp;
						<span class="red" style="position: absolute;width: 500px;">
							真实姓名一经提交后不能修改，人民币提现只能提到该姓名的银行卡上!
						</span>
					</li>
					<li>
						<span class="c1">
							再次输入真实姓名:
						</span>
						<span>
							<input type="text" onblur="javascript:checkRealName();" class="inputStyle" value=""  name="realName2" id="realName2">
						</span>
					</li>
					<li>
						<span class="c1">
							请选择证件类型:
						</span>
						<select class="selectStyle" id="identityType" name="cardType" style="width:173px;">
							<option value="身份证">
								身份证
							</option>
						</select>
					</li>
					<li>
						<span class="c1">
							请输入证件号码:
						</span>
						<span>
							<input class="inputStyle"  value="" name="cardNumber" id="cardNumber">
						</span>
						&nbsp;
						<span class="red">
							证件号码一经提交后不能修改,请如实填写!
						</span>
					</li>
				</ul>
				<span style="color:red;padding-left: 157px;" id="errorMessage">&nbsp;&nbsp;</span>
				</br>
				</br>
				<a style="margin-left:156px;margin-bottom: 45px;" onclick="javascript:validateIdentity();" href="javascript:void(0);" class="buttonblue3">
					确定修改
				</a>
			</form>
		</div>
		

	</div>
	
	<div class="safe_section" id="user_setting2" style="display: none;">
	
		<div class="Tentitle">
			<span class="lightblue4">
				个人信息
			</span>
		</div>
		
		<div class="coinBoxBody">
			<form method="post" id="userinfoForm" >
				<ul class="security">
					<li style="position:relative;">
						<span class="c1">UID:</span>
						<span style="display:inline-block;" id="uid">${sessionScope.frontUserM.uid}</span>
					</li>
					<li style="position:relative;">
						<span class="c1">E-mail:</span>
						<span style="display:inline-block;" id="email">${sessionScope.frontUserM.email}</span>
					</li>
					<li>
						<span class="c1">
							昵称:
						</span>
						<span>
							<input type="text" class="inputStyle" value='${sessionScope.frontUserM.nickName}' name="nickName" id="nickName">
						</span>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<span class="c3">
							<input type="button" class="userSetBtn" value="确定修改" onclick="javascript:submitUserinfoForm();">
						</span>
					</li>
				</ul>
			</form>
		</div>
		
		
		<div class="Tentitle">
			<span class="lightblue4">
				实名认证信息
			</span>
		</div>
		<div class="coinBoxBody">
			<ul class="security">
				<li>
					<span class="c1">
						真实姓名:
					</span>
					<span id="show_realName">${sessionScope.frontUserM.realName}</span>
					&nbsp;
					<span class="red">
						(已认证)
					</span>
				</li>
				<li>
					<span class="c1">
						证件类型：
					</span>
					<span>
						身份证
					</span>
				</li>
				<li>
					<span class="c1">
						证件号码：
					</span>
					<span>
						44092************
					</span>
				</li>
			</ul>
		</div>

	</div>
	
	<div class="safe_section" id="ask_question" style="display: block;">
	
		<div class="initiateProblem">
			<div class="specificContent">
				<form method="post" id="askQuestionForm" >
				<ul>
					<li>
						<span class="c1">
							<span class="red">*</span>
							问题类型:
						</span>
						<span class="c2">
							<select id="questionType">
								<option value="-1">
									---请选择问题类型---
								</option>
								
									<option value="1">充值问题</option>
								
									<option value="2">提现问题</option>
								
									<option value="3">其它问题</option>
								
							</select>
						</span>
					</li>
					<li>
						<span style="float:left;" class="c1">
							<span class="red">*</span>
							问题描述:
						</span>
						<span style="float:left;" id="" class="c2">
							<span>
								<textarea onblur="trimValue(this);" rows="4" cols="50" class="textarea" id="desc" style="resize: none"></textarea>
							</span>
						</span>
					</li>
					<li>
						<span class="c1">
							<span class="red">*</span>
							姓名:
						</span>
						<span class="c2">
							<input type="text" onblur="trimValue(this);" name="" value="李时岐" class="blankInformation" id="name">
						</span>
					</li>
					<li>
						<span class="c1">
							<span class="red">*</span>
							联系电话:
						</span>
						<span class="c2">
							<input type="text" onkeyup="value=value.replace(/[^\d]/g,'')" name="" value="" class="blankInformation" id="phone">
						</span>
					</li>
				</ul>
				</form>
			</div>
			<div>
				<span style="color: red;padding-left: 210px;" id="errorMsg">&nbsp;</span>
				<br>
				<a onclick="javascript:submitQuestion();" class="questionButtonblue" href="javascript:void(0)">
					提交问题
				</a>
			</div>
		</div>
	
	</div>
	<div class="safe_section" id="question_list" style="display: none;">
	
	</div>
	<div class="safe_section" id="msg_center" style="display: none;">
	
	</div>
</div>

<!--footer start here-->
<jsp:include page="../test/footer.jsp"></jsp:include>
<!--footer end here-->


</body>
</html>