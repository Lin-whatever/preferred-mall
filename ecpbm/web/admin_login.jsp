<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>优选商城 - 后台管理</title>
    <meta charset="UTF-8">
    <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{background:linear-gradient(135deg,#1a1a2e,#16213e);min-height:100vh;display:flex;align-items:center;justify-content:center;font-family:"Microsoft YaHei",sans-serif;}
        .login-box{width:360px;}
        .login-header{text-align:center;margin-bottom:28px;}
        .login-header h1{color:#fff;font-size:26px;font-weight:600;margin-bottom:8px;}
        .login-header p{color:rgba(255,255,255,.5);font-size:13px;}
        .login-card{background:#fff;border-radius:12px;padding:36px 32px;box-shadow:0 12px 40px rgba(0,0,0,.3);}
        .form-group{margin-bottom:20px;}
        .form-group label{display:block;font-size:13px;color:#555;margin-bottom:6px;font-weight:500;}
        .form-group input{width:100%;padding:12px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:14px;outline:none;}
        .form-group input:focus{border-color:#4f46e5;}
        .btn-row{display:flex;gap:12px;margin-top:24px;}
        .btn{flex:1;padding:12px;border:none;border-radius:6px;font-size:14px;font-weight:500;cursor:pointer;}
        .btn-login{background:#4f46e5;color:#fff;}
        .btn-login:hover{background:#4338ca;}
        .btn-reset{background:#f0f2f5;color:#666;}
    </style>
</head>
<body>
<div class="login-box">
    <div class="login-header">
        <h1>优选商城</h1>
        <p>后台管理系统</p>
    </div>
    <div class="login-card">
        <div class="form-group">
            <label>用户名</label>
            <input id="uName" type="text" value="admin" placeholder="请输入用户名" />
        </div>
        <div class="form-group">
            <label>密码</label>
            <input id="uPwd" type="password" value="123456" placeholder="请输入密码" />
        </div>
        <div class="btn-row">
            <button class="btn btn-login" onclick="doLogin()">登录</button>
            <button class="btn btn-reset" onclick="resetForm()">重置</button>
        </div>
    </div>
</div>
<script>
function resetForm(){ document.getElementById('uName').value=''; document.getElementById('uPwd').value=''; }
function doLogin(){
    var name=document.getElementById('uName').value;
    var pwd=document.getElementById('uPwd').value;
    if(!name||!pwd){alert('请输入用户名和密码');return;}
    var xhr=new XMLHttpRequest();
    xhr.open('POST','${pageContext.request.contextPath}/admininfo/login',true);
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    xhr.onreadystatechange=function(){
        if(xhr.readyState===4){
            try{
                var res=JSON.parse(xhr.responseText);
                if(res.success==='true') window.location.href='${pageContext.request.contextPath}/admin.jsp';
                else alert(res.message||'登录失败');
            }catch(e){ window.location.href='${pageContext.request.contextPath}/admin.jsp'; }
        }
    };
    xhr.send('name='+encodeURIComponent(name)+'&pwd='+encodeURIComponent(pwd));
}
</script>
</body>
</html>
