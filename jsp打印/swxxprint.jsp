<%@page import="com.oking.pkqx.dao.Crudspjl.spyjType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
		<%@ page import="com.oking.pkqx.swgl.dao.*,com.bstek.bdf2.core.context.ContextHolder,com.oking.pkqx.dao.*,java.text.SimpleDateFormat,java.util.*,com.oking.pkqx.bean.*,com.oking.pkqx.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
<!--
 .title{

	font-weight: bold;
	text-align:center;
	height:100px;
	width:100px;
	}
	
	.title2{

	font-weight: bold;
	text-align:center;
	width:100px;
	}
	table {
		 border-collapse: collapse; 
		 
		}
table td{
	 border:solid  2px;

	}
-->
</style>
<script>  

	function preview(oper) {
		if (oper < 10) {
			bdhtml = window.document.body.innerHTML;//获取当前页的html代码  
			sprnstr = "<!--startprint" + oper + "-->";//设置打印开始区域  
			eprnstr = "<!--endprint" + oper + "-->";//设置打印结束区域  
			prnhtml = bdhtml.substring(bdhtml.indexOf(sprnstr) + 18); //从开始代码向后取html  

			prnhtml = prnhtml.substring(0, prnhtml.indexOf(eprnstr));//从结束代码向前取html  
			window.document.body.innerHTML = prnhtml;
			window.print();
			window.document.body.innerHTML = bdhtml;
		} else {
			window.print();
		}
	}

	
</script>
<%
	String id = request.getParameter("id");
	FtGwSwxxDao swgl = ContextHolder.getApplicationContext().getBean(
			FtGwSwxxDao.class);
	List<Map<String, Object>> list = swgl.getByid(id);
	Map<String, Object> m = list.get(0);

	UtilMap um = ContextHolder.getApplicationContext().getBean(
			UtilMap.class);

	Crudspjl spjlfunc = ContextHolder.getApplicationContext().getBean(
			Crudspjl.class);
	SimpleDateFormat sh = new SimpleDateFormat("yyyy-MM-dd");
	
%>
</head>

<body>
<input id="btnPrint" type="button" value="打印"  onclick="javascript:preview(1)"  />    

<!--startprint1-->
	<div style="width: 800px;margin:0 auto;">

		<div
			style='text-align: center; font-size: 18.0pt; font-family: "微软雅黑", "sans-serif"'>浦口区气象局办公室办文单</div>

		<p class=MsoNormal align=center style='text-align: center'>
			<b><span lang=EN-US
				style='font-size: 18.0pt; font-family: "微软雅黑", "sans-serif"'>&nbsp;</span></b>
		</p>

		<div><%=m.get("swzh")%></div>

		<div align=right style='text-align: right'><%=m.get("xfrq") == null ? "" : sh.format(m.get("xfrq"))%></div>

		<table border=1 cellspacing=0 cellpadding=0 width=652
			style='width: 800px;'>
			<tr>
				<td class="title">来文单位</td>
				<td>&nbsp;<%=m.get("lwdw") == null ? "" : m.get("lwdw")%></td>
				<td class="title">文号</td>
				<td>&nbsp;<%=m.get("lwzh") == null ? "" : m.get("lwzh")%></td>
			</tr>
			<tr>
				<td class="title">文件标题</td>
				<td colspan="3">&nbsp;<%=m.get("lwbt") == null ? "" : m.get("lwbt")%></td>
			</tr>
			<tr>
				<td rowspan="2" class="title">拟&nbsp;&nbsp;&nbsp;&nbsp;办</td>
				<%
				
					Map<String, Object> map1 = new HashMap<String, Object>();
					map1.put("sid", id);
					map1.put("taskname", "办公室主任拟办");
					map1.put("spzt", "2");
					
				%>
				<td colspan="3">&nbsp;<%=spjlfunc.getSpyjToJsp(spjlfunc.getAll(map1),spyjType.nr)%></td>
			</tr>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td class="title" style="height: 300px;">领&nbsp;导&nbsp;批&nbsp;示</td>
				<%
					Map<String, Object> map2 = new HashMap<String, Object>();
					map2.put("sid", id);
					map2.put("taskname", "领导批示");
					map2.put("spzt", "2");
					
				%>
				<td colspan="3">&nbsp;<%=spjlfunc.getSpyjToJsp(spjlfunc.getAll(map2),spyjType.nr)%></td>
			</tr>
			<tr>
				<td class="title">办理情况</td>
				<%
					Map<String, Object> map3 = new HashMap<String, Object>();
					map3.put("sid", id);
					map3.put("taskname", "承办人处理");
					map3.put("spzt", "2");
					
				%>
				<td colspan="3">&nbsp;<%=spjlfunc.getSpyjToJsp(spjlfunc.getAll(map3),spyjType.nr)%></td>
			</tr>
			<tr>
				<td class="title">督办情况</td>
			<%--<td colspan="3">&nbsp;<%=um.getrwzt().get(m.get("zt"))%></td> --%>
				<%
					Map<String, Object> map4 = new HashMap<String, Object>();
					map4.put("sid", id);
					map4.put("taskname", "秘书办理");
					map4.put("spzt", "2");
					
				%>
				<td colspan="3">&nbsp;<%=spjlfunc.getSpyjToJsp(spjlfunc.getAll(map4),spyjType.nr)%></td>
			</tr>
			<tr>
				<td class="title">备注</td>
			  <td colspan="3">&nbsp;<%=m.get("bz") ==null?"": m.get("bz")%></td>
			</tr>
		</table>


	</div>
<!--endprint1-->  
</body>

</html>