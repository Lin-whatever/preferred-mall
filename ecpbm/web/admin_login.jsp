<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>优选商城 - 后台管理</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{background:linear-gradient(135deg,#1a1a2e,#16213e);min-height:100vh;display:flex;align-items:center;justify-content:center;font-family:"Microsoft YaHei","PingFang SC",sans-serif;}
        .login-box{width:400px;}
        .login-header{text-align:center;margin-bottom:32px;}
        .login-header h1{color:#fff;font-size:28px;font-weight:600;margin-bottom:8px;letter-spacing:2px;}
        .login-header p{color:rgba(255,255,255,.45);font-size:14px;}
        .login-card{background:#fff;border-radius:16px;padding:40px 36px;box-shadow:0 20px 60px rgba(0,0,0,.35);}
        .form-group{margin-bottom:22px;}
        .form-group label{display:block;font-size:14px;color:#333;margin-bottom:8px;font-weight:500;}
        .form-group input{width:100%;padding:14px 16px;border:1.5px solid #e0e0e0;border-radius:8px;font-size:15px;outline:none;transition:border-color .2s;background:#fafafa;}
        .form-group input:focus{border-color:#4f46e5;background:#fff;box-shadow:0 0 0 3px rgba(79,70,229,.1);}
        .btn-row{display:flex;gap:14px;margin-top:28px;}
        .btn{flex:1;padding:14px;border:none;border-radius:8px;font-size:15px;font-weight:600;cursor:pointer;transition:all .2s;}
        .btn-login{background:linear-gradient(135deg,#4f46e5,#6366f1);color:#fff;}
        .btn-login:hover{background:linear-gradient(135deg,#4338ca,#4f46e5);transform:translateY(-1px);box-shadow:0 4px 12px rgba(79,70,229,.35);}
        .btn-reset{background:#f5f5f5;color:#666;}
        .btn-reset:hover{background:#e8e8e8;}
        .error-msg{color:#e4393c;font-size:13px;text-align:center;margin-bottom:16px;display:none;}
    </style>
</head>
<body>
<div class="login-box">
    <div class="login-header">
        <h1>优选商城</h1>
        <p>后台管理系统</p>
    </div>
    <div class="login-card">
        <div id="errorMsg" class="error-msg"></div>
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
