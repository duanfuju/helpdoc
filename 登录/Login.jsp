<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登录</title>
    <style type="text/css">
        *{
            padding: 0px;
            margin: 0px;
            font-size: 1em;
        }
        html,body{
            text-align:center;
            margin:0px auto;
        }
        .container{
            margin-top: 5%;
            margin-bottom: 5%;
            margin-right: 5%;
            float: right;
            width:300px;
            height:500px;
            line-height: 50px;
            border:1px solid pink;
        }
		.from{
	            margin-top: 80%;
	        }
    </style>
</head>
<body>
<div class="container">
    <form action="LoginServlet" method="post">
        <div class="from">
        	<label for=username>用户名:</label>
	        <input type=text required placeholder=用户名 name=username pattern=[a-zA-Z0-9]{5,50} />
	        <br/>
	        <label for=upassword>密&nbsp;码:</label>
	        <input type=password required placeholder=请填写密码 name=pwd />
	        <br/>
	        <button type=submit>提交</button>
        </div>
    </form>
</div>
</body>
</html>