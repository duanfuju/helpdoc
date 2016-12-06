<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<% 
	String ora_code= session.getAttribute("whouseId").toString();
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    	<style type="text/css">
		*{
		 font-size:12px;
		 } 
	</style>
    <title>My JSP 'theDistributionOfPreRowOfCars.jsp' starting page</title>
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<link rel="stylesheet" type="text/css" href="../scripts/font-awesome-4.3.0/css/font-awesome.css"/>
	 <script type="text/javascript" src="../scripts/dorado/boot.js"></script>
	<script type="text/javascript">$import("silk,tree,grid");</script>
	<script type="text/javascript">
		var  ys=0;
		var  k=0;
		var numbers="0";//自动计算的默认值
		dorado.onInit(function() {
/* 			new dorado.widget.Dialog({
					id:"_print_dialog",
					caption:"打印预览",
					width:"80%",
					height:"96%",
					children:[{
						$type:"IFrame",
						id:"_Iframe_",
					} ]
					}); */
				var printDataSet=new dorado.widget.DataSet();
				var printWindows=new dorado.widget.Dialog({
					width:"70%",
					height:"90%",
					children:[{
						$type:"ToolBar",
						items:[]
					},{
						$type:"DataGrid",
						dataSet:printDataSet,
						readOnly:true,
						columns: [
						"#",
						{property:"ora_code",caption:"所属机构"},
						{property:"loadingbill",caption:"装车单号",width:100},
						{property:"platenumber",caption:"车辆编号"},
						{property:"driver1",caption:"主驾驶员"},
						{property:"dirver2",caption:"副驾驶员"},
						{property:"line_id",caption:"路线id"},
						{property:"printtime",caption:"打印时间"},
						{property:"printer",caption:"打印人"},
						{property:"status",caption:"状态"},
						{property:"confirmation",caption:"确认人"},
						{property:"loadingtype",caption:"任务类型"},
						],
						onDataRowDoubleClick:function(self,arg){
							var entity=self.getCurrentItem();
/* 							var entity=self.getCurrentItem();  //
							$id("_Iframe_").objects[0].reload(); 
							$id("_Iframe_").set("path","/kill.jhtml?data={printFuntion:{print_no:\"10010\",ora_code:\"8010\"},query:{loadingbill:\""+entity.get("loadingbill")+"\"}}");
							$id("_print_dialog").objects[0].refresh();
							//$id("_Iframe_").objects[0].get("iFrameWindow"),open("path","/kill.jhtml?data={printFuntion:{print_no:\"10010\",ora_code:\"8010\"},query:{loadingbill:\""+entity.get("loadingbill")+"\"}}");
							$id("_print_dialog").objects[0].show(); */
							window.open("/kill.jhtml?data={printFuntion:{print_no:\"10010\",ora_code:\"8010\"},query:{loadingbill:\""+entity.get("loadingbill")+"\"}}",'打印预览', 'fullscreen=yes');
						},
						onReady:function(self,arg){
							self.get("dataSet").setData(GetData({sql:"select * from view_print_ls where ora_code like '%<%=ora_code%>%'"},"/findBySQL.jhtml","json"));
						}
						}]
				});
				printWindows.show();
				var dataSet_=new dorado.widget.DataSet({
					tags:"___",
				});
				function getDataGridCaption(id){
					var json=new dorado.EntityList();
					try{
						var entity=$id(id).objects[0].get("columns").items;
						for(var i = 1 ; i<entity.length;i++){
							entity.set(entity[i]._name,entity[i]._caption);
						}
						return json;
					}catch(e){
						alert(e.message);
						console.error(e);						
					}

				}
				var updateDataSet=new dorado.widget.DataSet({});
				var zbDataSet=new dorado.widget.DataSet({});
				var fjDataSet=new dorado.widget.DataSet({});
				var sum=GetData({
					"function":"rvehiclesnumIsSUM"
				},"/windows.jhtml","json")[0];
				var clDataSet=new dorado.widget.DataSet({});

				//装车单管理
				var updateWindows=new dorado.widget.Dialog({
					width:"770",
					height:"380",
					caption:"修改运车单",
					children:[{
						$type:"ToolBar",
						items:[{
							$type:"Label",
							text:"装车单号:",
						},{
							$type:"TextEditor",
							tags:"query__Name",
							onTextEdit:function(self,arg){
								updateDataSet.setData(GetData({
									 		sql:"select * from VIEW_t_Tvs_Ls where ORA_CODE like '"+"<%=ora_code%>"+"%' and loadingbill like '%"+self.get("text")+"%'"
 											},"/findBySQL.jhtml","json"));
							}
						},{
							$type:"toolbar.Button",
							caption:"查询",
							iconClass:"fa fa-search",
							onClick:function(self,arg){
									 	updateDataSet.setData(GetData({
									 		sql:"select * from VIEW_t_Tvs_Ls where ORA_CODE like '"+"<%=ora_code%>"+"%' and loadingbill  like  '%"+$tag("query__Name").objects[0].get("text")+"%'"
 											},"/findBySQL.jhtml","json"));
							}
						}]
					},{
						$type:"DataGrid",
						dataSet:updateDataSet,
						readOnly:true,
						columns: [
						"#",
						{property:"loadingbill",caption:"装车单号" },
						{property:"driver1",caption:"主驾驶员编号" },
						{property:"driver1name",caption:"主驾驶员名称" },
						{property:"platenumber",caption:"车牌号" },
						{property:"line_id",caption:"线路" },
						{property:"loadingport",caption:"装卸口" },
						{property:"initdate",caption:"生成时间" ,width:"140"},
						{property:"rvehiclesnum",caption:"笼车数" },
						],
						onDataRowDoubleClick:function(self,arg){
							var entitys=self.getCurrentItem();//当前行的实体
							var message=GetData({
								"function":"getTTvsLd",
								"loadingbill":entitys._data.loadingbill
							},"/windows.jhtml","json");
							var entitys=new dorado.EntityList(message);
							console.table(message);
							entitys.each(function(entity){
								entity.set("cName",entity.get("c_name"));
								entity.set("cCode",entity.get("c_code"));
							});
							dataSet_.setData(message);
							updateWindows.hide();
						}
					}]
				});
				
				var selectWindowsZX=new dorado.widget.Dialog({//选择装卸口
					width:"770",
					height:"380",
					caption:"请选择装卸口信息",
					children:[{
						$type:"ToolBar",
						items:[{
							$type:"Label",
							text:"装卸口:",
						},{
							$type:"TextEditor",
							tags:"query__Name",
							onTextEdit:function(self,arg){
									 	zbDataSet.setData(GetData({
									 		sql:"select * from VIEW_T_VM_LOADINGPORT where ORA_CODE like '"+"<%=ora_code%>"+"%' and loaduport like '%"+self.get("text")+"%'"
 											},"/findBySQL.jhtml","json"));
							}
						},{
							$type:"toolbar.Button",
							caption:"查询",
							iconClass:"fa fa-search",
							onClick:function(self,arg){
									 	zbDataSet.setData(GetData({
									 		sql:"select * from VIEW_T_VM_LOADINGPORT where ORA_CODE like '"+"<%=ora_code%>"+"%' and loaduport like '%"+$tag("query__Name").objects[0].get("text")+"%'"
 											},"/findBySQL.jhtml","json"));
							}
						}]
					},{
						$type:"DataGrid",
						dataSet:zbDataSet,
						readOnly:true,
						columns: [
						"#",
						{property:"loaduport",caption:"装车口" },
						{property:"begin_date",caption:"每天开始时间" },
						{property:"end_date",caption:"每天结束时间" },
						{property:"currentnum",caption:"当前派车数" },
						],
						onDataRowDoubleClick:function(self,arg){
							var entity=self.getCurrentItem();//当前行的实体
							console.log(entity.id);
							var AutoFormEntity=$tag("AutoForm___").objects[0].get("entity");
							AutoFormEntity.zbId=entity._data.id;
							AutoFormEntity.loaduport=entity._data.loaduport;//vehiclecode
 							$tag("loaduport").set("text",entity._data.loaduport);
							selectWindowsZX.hide();
						}
					}]
				});
				var selectWindows=new dorado.widget.Dialog({
					width:"770",
					height:"380",
					caption:"请选择车辆信息",
					children:[{
						$type:"ToolBar",
						items:[{
							$type:"Label",
							text:"车牌号/助记码:",
						},{
							$type:"TextEditor",
							tags:"queryName",
							onTextEdit:function(self,arg){
									 	clDataSet.setData(GetData({
 												sql:"select * from VIEW_DRIVER where ORA_CODE like '"+"<%=ora_code%>"+"' and LINE_ID='"+ $tag("AutoForm___").objects[0].get("entity").line_id+"'"+" and VEHICLECODE like '%"+$tag("queryName").objects[0].get("text")+"%' or  mnemonic like '%"+$tag("queryName").objects[0].get("text")+"%'"
 											},"/findBySQL.jhtml","json"));
							}
						},{
							$type:"toolbar.Button",
							caption:"查询",
							iconClass:"fa fa-search",
							onClick:function(self,arg){
									 	clDataSet.setData(GetData({
 												sql:"select * from VIEW_DRIVER where ORA_CODE like '"+"<%=ora_code%>"+"' and LINE_ID='"+ $tag("AutoForm___").objects[0].get("entity").line_id+"'"+" and vehiclename like '%"+$tag("queryName").objects[0].get("text")+"%' or  mnemonic like '%"+$tag("queryName").objects[0].get("text")+"%'"
 											},"/findBySQL.jhtml","json"));
							}
						}]
					},{
						$type:"DataGrid",
						dataSet:clDataSet,
						readOnly:true,
						columns: [
						"#",
						{property:"vehiclename",caption:"车辆名称" },
						{property:"mnemonic",caption:"助记码" },
						{property:"maindriver",caption:"主驾驶员" },
						{property:"vehiclecode",caption:"车辆编号" },
						{property:"vehicleclass",caption:"车辆类别" },
						{property:"management_c",caption:"管理单位" },
						{property:"vehiclestype",caption:"品牌型号" },
						{property:"platenumber",caption:"车牌号" },
						],
						onDataRowDoubleClick:function(self,arg){
							var entity=self.getCurrentItem();//当前行的实体
							console.log(entity);
							var AutoFormEntity=$tag("AutoForm___").objects[0].get("entity");
							AutoFormEntity.vehiclename=entity._data.vehiclename;
							AutoFormEntity.driver1=entity._data.maindriver;//vehiclecode
							AutoFormEntity.vehiclecode=entity._data.vehiclecode;
 							$tag("vehiclename").set("text",entity._data.vehiclename);
							$tag("driver1").set("text",entity._data.maindriver); 
							selectWindows.hide();
						}
					}]
				});
				 var fjDataSetM=new dorado.widget.DataSet();
					var selectWindowsUserM=new dorado.widget.Dialog({ //选择主驾驶员的编号
					width:"770",
					height:"380",
					caption:"请选择主驾驶员:",
					children:[{
						$type:"ToolBar",
						items:[{
							$type:"Label",
							text:"人员编号/助记码:",
						},{
							$type:"TextEditor",
							tags:"queryName2",
							onTextEdit:function(self,arg){
									 	fjDataSetM.setData(GetData({
									 	sql :"select * from VIEW_T_VM_DRIVER where  ORA_CODE like '<%=ora_code%>%' and  u_code like  '%"+$tag("queryName2").objects[0].get("text")+"%' or  mnemonic like  '%"+$tag("queryName2").objects[0].get("text")+"%'"
 											},"/findBySQL.jhtml","json"));
							},
							onReady:function(self,arg){
																 	fjDataSetM.setData(GetData({
									 	sql :"select * from VIEW_T_VM_DRIVER where  ORA_CODE like '<%=ora_code%>%' and  u_code like  '%"+$tag("queryName2").objects[0].get("text")+"%' or  mnemonic like  '%"+$tag("queryName2").objects[0].get("text")+"%'"
 											},"/findBySQL.jhtml","json"));
							}
						},{
							$type:"toolbar.Button",
							caption:"查询",
							iconClass:"fa fa-search",
							onClick:function(self,arg){
							}
						}]
					},{
						$type:"DataGrid",
						dataSet:fjDataSetM,
						readOnly:true,
						columns: [
						"#",
							{property:"u_code",caption:"主驾驶员编号"},
							{property:"u_name",caption:"主驾驶员名称"},
							{property:"mnemonic",caption:"主驾驶员助记码"},
							{property:"ora_name",caption:"所属机构名称"},
						],
						onDataRowDoubleClick:function(self,arg){
							var entity=self.getCurrentItem();//当前行的实体
							console.log(entity);
							var AutoFormEntity=$tag("AutoForm___").objects[0].get("entity");
							AutoFormEntity.driver1=entity._data.u_code;
							AutoFormEntity.u_name=entity._data.u_name;
							$tag("driver1").set("text",entity._data.u_code); 
							$tag("u_name").set("text",entity._data.u_name); 
							selectWindowsUserM.hide();
						}
					}]
				});
				//选择副驾驶员
				var selectWindowsUser=new dorado.widget.Dialog({
					width:"770",
					height:"380",
					caption:"请选择副驾驶员",
					children:[{
						$type:"ToolBar",
						items:[{
							$type:"Label",
							text:"人员编号/助记码:",
						},{
							$type:"TextEditor",
							tags:"queryName2",
							onTextEdit:function(self,arg){
									 	fjDataSet.setData(GetData({
									 	sql :"select * from View_Copilot where   ORA_CODE like '<%=ora_code%>%' and  u_code like '%"+$tag("queryName2").objects[0].get("text")+"%' or mnemonic like  '%"+$tag("queryName2").objects[0].get("text")+"%'"
 											},"/findBySQL.jhtml","json"));
							},
							onReady:function(self,arg){
										fjDataSet.setData(GetData({
									 	sql :"select * from View_Copilot where  ORA_CODE like '<%=ora_code%>%' and  u_code like  '%"+$tag("queryName2").objects[0].get("text")+"%' or  mnemonic like  '%"+$tag("queryName2").objects[0].get("text")+"%'"
 											},"/findBySQL.jhtml","json"));
							}
						},{
							$type:"toolbar.Button",
							caption:"查询",
							iconClass:"fa fa-search",
							onClick:function(self,arg){
							}
						}]
					},{
						$type:"DataGrid",
						dataSet:fjDataSet,
						readOnly:true,
						columns: [
						"#",
							{property:"u_code",caption:"副驾驶员编号"},
							{property:"u_name",caption:"副驾驶员名称"},
							{property:"mnemonic",caption:"副驾驶员助记码"},
							{property:"ora_name",caption:"所属机构名称"},
						],
						onDataRowDoubleClick:function(self,arg){
							var entity=self.getCurrentItem();//当前行的实体
							console.log(entity);
							var AutoFormEntity=$tag("AutoForm___").objects[0].get("entity");
							AutoFormEntity.driver2=entity._data.u_code;
							$tag("driver2").set("text",entity._data.u_code); 
							selectWindowsUser.hide();
						}
					}]
				});
				
				var send=new dorado.widget.Dialog({
					width:"800",
     				height:"230",
					caption:"请选择车辆",
					onHide :function(self,arg){
						dataSet_.getData().clear();
					},
					children:[{
						$type:"FieldSet",
						caption:"资料修改",
						children:[{
							$type:"AutoForm",
							tags:"AutoForm___",
							labelWidth:90,
							cols:"*,*,*",
							elements:[
								{property:"ora_code",label:"所属机构:",readOnly:true,},
								{property:"Waybill",label:"派车单号:",readOnly:true,},
								{property:"initdate",label:"生成时间:",readOnly:true,},
								{property:"loaduport",label:"装卸口:" ,editor:{
									$type:"TextEditor",
									tags:"loaduport",
									editable:false,
									onClick:function(self,arg){
											 zbDataSet.setData(GetData({
										 	sql:"select * from VIEW_T_VM_LOADINGPORT where ORA_CODE like '"+"<%=ora_code%>"+"%'"
 											},"/findBySQL.jhtml","json"));
 											selectWindowsZX.show();
									}
								}},
								{property:"driver1",label:"驾驶员编号:",editor:{
									$type:"TextEditor",
									readOnly:true,
									tags:"driver1"
								},},//主驾驶员编号
 								{property:"u_name",label:"主驾驶员:",editor:{//主驾驶员名称
									$type:"TextEditor",
									editable:false,
									blankText:"请选择主驾驶员",
									tags:"u_name",
									onClick:function(self,arg){
										fjDataSetM.setData(GetData({
									 	sql :"select * from view_t_vm_driver where  ORA_CODE like '<%=ora_code%>%'"
 											},"/findBySQL.jhtml","json"));
									selectWindowsUserM.show();
									}
								}}, 
								{property:"driver2",label:"副驾驶员:",editor:{
										$type:"TextEditor",
										tags:"driver2",
										editable:false,
										blankText:"请选择副驾驶..",
										onClick:function(self,arg){
									 	fjDataSet.setData(GetData({
									 	 	sql:"select * from View_Copilot where   ORA_CODE  like  '<%=ora_code%>%'"
 											},"/findBySQL.jhtml","json"));
 											selectWindowsUser.show();
										}
								}},
 								{property:"vehiclename",label:"车辆名称:",
								editor:{
										$type:"TextEditor",
										tags:"vehiclename",
										editable:false,
										blankText:"请选择车辆..",
 										onClick:function(self,arg){
 											selectWindows.show();
 											clDataSet.setData(GetData({
 												sql:"select * from VIEW_DRIVER where ORA_CODE like '"+"<%=ora_code%>"+"' and LINE_ID='"+ $tag("AutoForm___").objects[0].get("entity").line_id+"'"
 											},"/findBySQL.jhtml","json"));
										}
									} 
								}, 
								{property:"loadingtype",label:"类型:"}
							]
						}]
						}],
					buttons:[{
						$type:"Button",
						caption:"保存",
						width:"85",
						iconClass:"fa fa-floppy-o",
						onClick:function(self,arg){
						GetData({
							"function":"insertNo",
							"entity":$tag("AutoForm___").objects[0].get("entity")
							},"/windows.jhtml","json"); 
							send.hide();
						}
					},{
						$type:"Button",
						caption:"返回",
						iconClass:"fa fa-share-square-o",
						width:"85",
						onClick:function(self,arg){
							send.hide();
						}
					}]
				});
				//传入dataSet 返回算好的信息总汇
				function compute(dataSet){
					var TotalNumber=0;//总件数
					var TotaWholeNumber=0;//总整件数
					var TotaWareNumber=0;//总器数
					var TotaWeight=0;//总重量
					var TotaVolume=0;//总体积
					var TotaP=0;//总规品
					dataSet.get("data").each(function(entity){
						TotalNumber+=entity.get("totalpackages");
						TotaWholeNumber+=entity.get("totalpackages");
						TotaWareNumber+=entity.get("vehiclesnum");
						TotaWeight+=entity.get("totalweight");
						TotaVolume+=entity.get("totalvolume");
						TotaP+=entity.get("productp");
					});
					return {
					"TotalNumber":TotalNumber,
					"TotaWholeNumber":TotaWholeNumber,
					"TotaWareNumber":TotaWareNumber,
					"TotaWeight":TotaWeight,
					"TotaVolume":TotaVolume,
					"TotaP":TotaP,
					};
				}
				var page =new Page("ViewTTvsLd");
				var toolBar=new dorado.widget.ToolBar({
					items :[{
						$type:"toolbar.Button",
						iconClass:"fa fa-play",
						caption:"添加顺序"
					},{
						$type:"toolbar.Button",
						tags:"send",
						caption:"派车确定",
						iconClass:"fa fa-check",
						onClick:function(self,arg){
						 boolean=false;
						$tag("___").objects[0].get("data").each(function(entity){
							if(typeof(entity.get("loadingbill"))!="undefined" ){
								boolean=true;
								return ;
							}
						});  
						 message=GetData({
							fields:$tag("___").objects[0].get("data").toJSON(),
							isNo:boolean
							},"/returnNumber.jhtml","json");		
							$tag("AutoForm___").set("entity",message);
							boolean=false;
							if(message.type=="false"){
							 dorado.MessageBox.alert(message.message); 
							 return;
							}
							 send.show();
						}
					},{
						$type:"toolbar.Button",
						caption:"修改装车单",
						iconClass:"fa fa-pencil-square-o",
						onClick:function(self,arg){
						var entitys = new dorado.EntityList(GetData({
							sql:"select DRIVER1NAME,LOADINGBILL,DISPATCHER, INITDATE,LINE_ID,LOADINGTYPE,CONFIRM_DATE,CONFIRMATION,LOADINGPORT,LOADING_BTIME, LLOADING_STIME,DEPARTURE_TIME,STATUS,PRINTTIME,PRINTER,RECEIPTTIME,RECEIPTER,PLATENUMBER,DRIVER1,DIRVER2,ORA_CODE,TR_NUMBER,PRIORITY,ID,COSTTEMP,CONFIRUSER,CONFIRDATE,to_char(initdate,'yyyy-MM-dd HH:mm:ss') initdate from VIEW_t_Tvs_Ls where ORA_CODE='<%=ora_code%>'"
					},"/findBySQL.jhtml","json"));

						updateDataSet.setData(entitys);
						 updateWindows.show();
						 GetData({sql:"delete from t_Tvs_ls t where not exists (select 1 from t_tvs_ld a where a.loadingbill = t.loadingbill)"},"/findBySQL.jhtml","json");
						}	
					},{
						$type:"toolbar.Button",
						iconClass:"fa fa-refresh",
						caption:"刷新",
						onClick:function(self,arg){
							dorado.MessageBox.confirm("刷新后下面未排单据会消失!是否执行刷新?",function(){
								page.Refresh();
								dataSet_.clear();
							});

						}
					},{
						$type:"toolbar.Button",
						caption:"派车单打印",
						iconClass:"fa fa-print",
					},"|",{
						$type:"toolbar.Button",
						caption:"清空",
						iconClass:"fa fa-trash",
						onClick:function(self,arg){
							dorado.MessageBox.confirm("是否确认清空?",function(){
								dataSet_.clear();
							});
						}
					},{
						$type:"toolbar.Button",
						caption:"筛选",
						iconClass:"fa fa-binoculars",
						onClick:function(self,arg){
							queryDialog_____.show();
						}
					}],
				});
				var dataGrid=new dorado.widget.DataGrid({
					id:"dataGrid",
					dataSet:dataSet_,
					height:"30%",
					selectionMode:"multiRows",
					columns: [
						"#","[]",
						{property:"waybill",caption:"运单号",width:120,readOnly:true},
						{property:"orderNo",caption:"订单编号",width:80,readOnly:true},
						{property:"cName",caption:"单位名称",width:120,readOnly:true},
						{property:"cCode",caption:"单位编号",width:120,readOnly:true},
						{property:"billdate",caption:"单据日期",width:140,readOnly:true},
						{property:"demandDate",caption:"到货日期",width:140,readOnly:true},
						{property:"shipto",caption:"到货站",width:80,readOnly:true},
						{property:"lineId",caption:"线路id",width:80,readOnly:true},
						{property:"loadingseq",caption:"装车顺序",width:80,editor:{
								$type: "CustomSpinner", 
								pattern: "[0]"
						}},
						{property:"ordertype",caption:"运单类型",width:80,readOnly:true},
						{property:"shiptoadd",caption:"到货地址",width:180,readOnly:true},
						{property:"shipfromadd",caption:"发货地址",width:80,readOnly:true},
						{property:"consignee",caption:"收货人",width:80,readOnly:true},
						{property:"consigneetel",caption:"收货人电话",width:80,readOnly:true},
						{property:"consigneemobile",caption:"收货人手机",width:80,readOnly:true},
						{property:"mnemonic",caption:"助记码",width:100,readOnly:true},
						{property:"isRejection",caption:"是否拒收",width:80,readOnly:true},
						{property:"status",caption:"状态",width:80,readOnly:true},
						{property:"vehiclesnum",caption:"计划笼车数",width:80,readOnly:true},
						{property:"productp",caption:"计划品规数",width:80,readOnly:true},
						{property:"packages",caption:"计划整件数",width:80,readOnly:true},
						{property:"lclnumber",caption:"计划拼箱数",width:80,readOnly:true},
						{property:"totalpackages",caption:"计划总件数",width:80,readOnly:true},
						{property:"totalweight",caption:"计划总重量",width:80,readOnly:true},
						{property:"totalvolume",caption:"计划总体积",width:80,readOnly:true},
						{property:"trNumber",caption:"运输方式编号",width:80,readOnly:true},
						{property:"conTraffic",caption:"运输要求",width:80,readOnly:true},
						{property:"platenumber",caption:"车牌号",width:80,readOnly:true},
						{property:"aId",caption:"地址内码",width:80,readOnly:true},
						{property:"driver",caption:"司机",width:80,readOnly:true},//
						{property:"fatherwaybill",caption:"父运单号",width:80,readOnly:true},
						{property:"consignor",caption:"货主",width:80,readOnly:true},
						{property:"carrierid",caption:"承运商",width:80,readOnly:true},
						{property:"remark",caption:"备注",width:80,readOnly:true},
						{property:"rproductp",caption:"实际品规数",width:80,readOnly:true},
						{property:"rpackages",caption:"实际整件数",width:80,readOnly:true},
						{property:"rlclnumber",caption:"实际拼箱数",width:80,readOnly:true},
						{property:"rtotalpackages",caption:"实际总件数",width:80,readOnly:true},
						{property:"rtotalweight",caption:"实际总重量",width:80,readOnly:true},
						{property:"rtotalvolume",caption:"实际总体积",width:80,readOnly:true},
						{property:"rvehiclesnum",caption:"实际笼车数",width:80,readOnly:true},
						{property:"loadingbill",caption:"装车单号",width:80,readOnly:true},
						{property:"loadingrow",caption:"派车单行号",width:80,readOnly:true},
						{property:"oraCode",caption:"所属机构" ,width:80,readOnly:true},
						{property:"orderstatuss",caption:"订单状态" ,width:80},
						],
						onDataRowDoubleClick:function(self,arg){
							var entity=self.getCurrentItem(); 
							
							if(typeof(entity.get("loadingbill"))!="undefined" ||entity.get("loadingbill")!=""){
								var loadingbill=entity.get("waybill");
								GetData({
									"function":"deleteNo",
									"No":loadingbill
									},"/windows.jhtml","json");
							}
							entity.remove();
							if(dataSet_.get("data").toJSON().length<1)
								GetData({sql:"delete from t_Tvs_ls t where not exists (select 1 from t_tvs_ld a where a.loadingbill = t.loadingbill)"},"/findBySQL.jhtml","json");
							entity.set("loadingbill","");
							page.dataSet.getData().insert(entity);
							 var entity=compute(dataSet_);
 							$tag("TotalNumber").set("text",entity.TotalNumber);
							 $tag("TotaWholeNumber").set("text",entity.TotaWholeNumber);
							 $tag("TotaWareNumber").set("text",entity.TotaWareNumber);
							 $tag("TotaWeight").set("text",entity.TotaWeight);
							 $tag("TotaVolume").set("text",entity.TotaVolume);
							 $tag("YesOrder").set("text",$id("dataGrid").objects[0].get("dataSet").get("data").entityCount);
							$tag("NoOrder").set("text" ,$id("totalCountViewTTvsLd").objects[0].get("text")-$id("dataGrid").objects[0].get("dataSet").get("data").entityCount);
							// dorado.widget.NotifyTipManager.notify("订单添加成功...");
							$tag("NoTotaWareNumber").set("text",(sum.vehiclesnum)-$tag("TotaWareNumber").objects[0].get("text"));
							$tag("NoTotaWholeNumber").set("text",(sum.rpackages)-$tag("TotaWholeNumber").objects[0].get("text"));
							$tag("NoTotaSpecifications").set("text",(sum.rproductp)-entity.TotaP);
							$tag("id").set("text",(sum.id)-$id("dataGrid").objects[0].get("dataSet").get("data").entityCount);
							$tag("NoStatus").set("text",GetData({
							"function":"queryStatus"
							},"/windows.jhtml","json")[0].status);
							var data_sj=GetData({
							"function":"queryDriver"
							},"/windows.jhtml","json")[0];
							if(data_sj.type=="false")
							 dorado.MessageBox.alert(data_sj.message);
							 return ;
							$tag("NoUser").set("text",data_sj.sche_status);
						

						}
				});
				var dataGridM=new dorado.widget.DataGrid({
					id:"dataGridM",
					readOnly:true,
					height:"50%",
					columns: [
						"#",
						{property:"waybill",caption:"运单号",width:120},
						{property:"orderNo",caption:"订单编号",width:80},
						{property:"cName",caption:"单位名称",width:120},
				    	{property:"cCode",caption:"单位编号",width:120},
						{property:"mnemonic",caption:"助记码",width:100},
						{property:"billdate",caption:"单据日期",width:140},
						{property:"demandDate",caption:"到货日期",width:140},
						{property:"shipto",caption:"到货站",width:80},
						{property:"lineId",caption:"线路id",width:80},
						{property:"status",caption:"状态",width:80},
						{property:"ordertype",caption:"运单类型",width:80},
						{property:"shiptoadd",caption:"到货地址",width:180},//
						{property:"shipfromadd",caption:"发货地址",width:80},
						{property:"consignee",caption:"收货人",width:80},
						{property:"consigneetel",caption:"收货人电话",width:80},
						{property:"consigneemobile",caption:"收货人手机",width:80},
						{property:"isRejection",caption:"是否拒收",width:80},
						{property:"loadingseq",caption:"装车顺序",width:80},
						{property:"vehiclesnum",caption:"计划笼车数",width:80},
						{property:"productp",caption:"计划品规数",width:80},
						{property:"packages",caption:"计划整件数",width:80},
						{property:"lclnumber",caption:"计划拼箱数",width:80},
						{property:"totalpackages",caption:"计划总件数",width:80},
						{property:"totalweight",caption:"计划总重量",width:80},
						{property:"totalvolume",caption:"计划总体积",width:80},
						{property:"trNumber",caption:"运输方式编号",width:80},
						{property:"conTraffic",caption:"运输要求",width:80},
						{property:"platenumber",caption:"车牌号",width:80},
						{property:"aId",caption:"地址内码",width:80},
						{property:"driver",caption:"司机",width:80},//
						{property:"fatherwaybill",caption:"父运单号",width:80},
						{property:"consignor",caption:"货主",width:80},
						{property:"carrierid",caption:"承运商",width:80},
						{property:"remark",caption:"备注",width:80},
						{property:"rproductp",caption:"实际品规数",width:80},
						{property:"rpackages",caption:"实际整件数",width:80},
						{property:"rlclnumber",caption:"实际拼箱数",width:80},
						{property:"rtotalpackages",caption:"实际总件数",width:80},
						{property:"rtotalweight",caption:"实际总重量",width:80},
						{property:"rtotalvolume",caption:"实际总体积",width:80},
						{property:"rvehiclesnum",caption:"实际笼车数",width:80},
						{property:"loadingbill",caption:"装车单号",width:80},
						{property:"loadingrow",caption:"派车单行号",width:80},
						{property:"oraCode",caption:"所属机构" ,width:80},
						{property:"orderstatuss",caption:"订单状态" ,width:80},
						],
						onRenderRow:function(self,arg){
							k+=1;
							if(k%2==1){
								arg.dom.style.background="#EFEFEF";
							}else {
								arg.dom.style.background="#FFFFFF";
							}
							if(arg.data.get("orderstatus")==1)
								arg.dom.style.background="#F7F5BD";
							else if (arg.data.get("orderstatus")==2)
								arg.dom.style.background="#95EEF2";
							else if (arg.data.get("orderstatus")==3)
								arg.dom.style.background="#FC7C86";
							else if (arg.data.get("orderstatus")==4)
								arg.dom.style.background="#5959FF";
							arg.processDefault=true;
						},
						onCurrentChange:function(self,arg){
							
						},
						onReady:function(self,arg){ //初始化DataGrid时候加载数据
						   $id("dataGridM").set("dataSet",page.dataSet);  
						   page.JMP(1, 10, " and ORA_CODE like "+"'<%=ora_code%>%'");
						},
						onDataRowDoubleClick:function(self,arg){
							var entity=self.getCurrentItem(); 
							if(entity.get("lineId")=="" || typeof(entity.get("lineId"))=="undefined"){
								dorado.MessageBox.alert("单位资料初始线路ID未维护,请在单位资料界面维护");
								return;
							}
							//console.log(entity._data);
							if(dataSet_.getData()==null){
								entity.set("loadingseq",1);
								dataSet_.setData (new dorado.EntityList(entity._data));
								entity.remove();
							}else {
								var number=$id("dataGrid").objects[0].get("dataSet").getData().toArray().length+1;
								entity.set("loadingseq",number);
								dataSet_.getData().insert(entity);
							}
							 var entity=compute(dataSet_);
							 $tag("TotalNumber").set("text",entity.TotalNumber);
							 $tag("TotaWholeNumber").set("text",entity.TotaWholeNumber);
							 $tag("TotaWareNumber").set("text",entity.TotaWareNumber);
							 $tag("TotaWeight").set("text",entity.TotaWeight);
							 $tag("TotaVolume").set("text",entity.TotaVolume);
							 $tag("YesOrder").set("text",$id("dataGrid").objects[0].get("dataSet").get("data").entityCount);
							$tag("NoOrder").set("text" ,$id("totalCountViewTTvsLd").objects[0].get("text")-$id("dataGrid").objects[0].get("dataSet").get("data").entityCount);
							// dorado.widget.NotifyTipManager.notify("订单添加成功...");
							$tag("NoTotaWareNumber").set("text",(sum.vehiclesnum)-$tag("TotaWareNumber").objects[0].get("text"));
							$tag("NoTotaWholeNumber").set("text",(sum.rpackages)-$tag("TotaWholeNumber").objects[0].get("text"));
							$tag("NoTotaSpecifications").set("text",(sum.rproductp)-entity.TotaP);
							$tag("id").set("text",(sum.id)-$id("dataGrid").objects[0].get("dataSet").get("data").entityCount);
							$tag("NoStatus").set("text",GetData({
							"function":"queryStatus"
							},"/windows.jhtml","json")[0].status);
							$tag("NoUser").set("text",GetData({
							"function":"queryDriver"
							},"/windows.jhtml","json")[0].sche_status);
							
						},
				});
				var fieldSet=new dorado.widget.AutoForm({
/* 					caption:"已排订单信息汇总",
					children:[{ */
						$type:"AutoForm",
						height:"10%",
						labelWidth:70,
					//	editorWidth:100,
						cols:"*,*,*,*,*,*,*,*,*,*,*,*,*,*,*",readOnly:true,
						elements:[
							{$type:"Label",text:"已排---> ",style:"color:red"},
							{$type:"Label",text:"已排订单: "},
							{$type:"Label",tags:"YesOrder",text: numbers,style:"color:red"},
							{$type:"Label",text:"总笼车数: "},
							{$type:"Label",tags:"TotaWareNumber",text: numbers,style:"color:red"},
							{$type:"Label",text:"总整件数: "},
							{$type:"Label",tags:"TotaWholeNumber",text: numbers,style:"color:red"},
							{$type:"Label",text:"总数量: "},
							{$type:"Label",tags:"TotalNumber",text: numbers,style:"color:red"},
							{$type:"Label",text:"总重量: "},
							{$type:"Label",tags:"TotaWeight",text: numbers,style:"color:red"},
							{$type:"Label",text:"总体积: "},
							{$type:"Label",tags:"TotaVolume",text: numbers,style:"color:red"},
							{$type:"Label"},
							{$type:"Label"},
							{$type:"Label",text: "未排--->",style:"color:red"},
							{$type:"Label",text:"未安排订单: "},
							{$type:"Label",tags:"NoOrder",text: numbers,style:"color:red"},
							{$type:"Label",text:"未排笼车数: "},
							{$type:"Label",tags:"NoTotaWareNumber",text: numbers,style:"color:red"},
							{$type:"Label",text:"未排整件数: "},
							{$type:"Label",tags:"NoTotaWholeNumber",text: numbers,style:"color:red"},
							{$type:"Label",text:"未排品规数: "},
							{$type:"Label",tags:"NoTotaSpecifications",text: numbers,style:"color:red"},
							{$type:"Label",text:"未排客户数: "},
							{$type:"Label",tags:"id",text:  numbers,style:"color:red"},
							{$type:"Label",text:"空闲车辆: "},
							{$type:"Label",tags:"NoStatus",text:  numbers,style:"color:red"},
							{$type:"Label",text:"空闲司机: "},
							{$type:"Label",tags:"NoUser",text: numbers,style:"color:red"},
						]
/* 					}] */
				});
			//查询按钮的弹出框
			var queryDialogSet=new dorado.widget.DataSet({}); 
			var queryDialog_____=new dorado.widget.Dialog({
				floating :false,
				caption:"筛选框",
				width  :"40%",
				height:"420",
				buttons:[{
					$type:"Button",
					caption:"确认查询",
					onClick:function(self,arg){
						if(queryDialogSet.get("data")==null ){
							dorado.MessageBox.alert("-_-。sorry！ 没有定义规则无法进行查询!");
						}else{
							var string ="";
							var data=queryDialogSet.get("data").toJSON();
							for(var i =0; i<data.length;i++){
								if(typeof(data[i].TJ)!="undefined" &&data[i].TJ!=""){
									if(data[i].ZD=="billdate" || "demandDate"==data[i].ZD){
										if(data[i].FH=="%%")
											string+=" and "+data[i].ZD+" like "+"'%to_date("+data[i].TJ+",'yyyy-mm-dd')%' ";
										else 
											string+=" and "+data[i].ZD+" "+data[i].FH+" "+"to_date('"+data[i].TJ+"','yyyy-mm-dd') ";
									}else {
										if(data[i].FH=="%%")
											string+=" and "+data[i].ZD+" like "+"'%"+data[i].TJ+"%' ";
										else 
											string+=" and "+data[i].ZD+" "+data[i].FH+" "+"'"+data[i].TJ+"' ";
									}

								}
							}
							page.JMP(1, 100, string);
							queryDialog_____.hide();
						}
					}
				},{
					$type:"Button",
					caption:"取消查询",
					onClick:function(self,arg){
						queryDialog_____.hide();
					}
				}],
				children:[{
					$type:"ToolBar",
					items:[{
						$type:"toolbar.Button",
						caption:"新增规则",
						onClick:function(self,arg){
							if(queryDialogSet.getData()==null)
								queryDialogSet.setData([{}]);
							else 
								queryDialogSet.insert({});
						}
					},{
						$type:"toolbar.Button",
						caption:"删除规则",
						onClick:function(self,arg){
							dorado.MessageBox. confirm("是否要移除此查询规则?",function(){
								$id("queryDialogGrid").objects[0].get("selection").each(function(entity){
									entity.remove();
								});
							});
						}
					},{
						$type:"toolbar.Button",
						caption:"清空规则",
						onClick:function(self,arg){
							console.log($id("queryDialogGrid").objects[0].get("footerEntity"));
							queryDialogSet.clear();
						}
					},{
						$type:"toolbar.Button",
						caption:"重置条件",
						onClick:function(self,arg){
							queryDialogSet.get("data").each(function(entity){
								entity.set("TJ","");
							});
						}
					}]
				},{
					$type:"DataGrid",
					id:"queryDialogGrid",
					dataSet:queryDialogSet,
					selectionMode:"multiRows",
					columns: [
						"#","[]",
						{property:"_caption",caption:"查询的字段",editor:{
							$type:"TextEditor",
							editable:false,
							trigger: {
								$type: "ListDropDown",
								autoOpen :true,
								items:$id("dataGridM").objects[0].get("columns").items.slice(1),
								property: "_caption",
								onValueSelect:function(self,arg){
										var data=$id("dataGridM").objects[0].get("columns").items.slice(1);
										for(var i=0;i<data.length;i++){
											if(data[i]._caption==arg.selectedValue)
												$id("queryDialogGrid").objects[0].getCurrentItem().set("ZD",data[i]._name);
											if(arg.selectedValue=="单据日期")
												$id("queryDialogGrid").objects[0].getCurrentItem().set("TJ",new Date().formatDate("Y-m-d"));
												$id("queryDialogGrid").objects[0].getCurrentItem().set("queryF","等于");
												$id("queryDialogGrid").objects[0].getCurrentItem().set("FH","=");
										}
								}
							}
						}},
						{property:"queryF",caption:"查询方式" ,editor:{
							$type:"TextEditor",
							trigger: {
								$type: "ListDropDown",
								autoOpen :true,
								items: GetData({"sql":"select DICNAME,OBJECTPARM from T_BASE_REFDATAD where OBJECTCODE='FH'"},"/findBySQL.jhtml","json"),
								property: "dicname",
								onValueSelect:function(self,arg){
									var entity =GetData({"sql":"select OBJECTPARM from T_BASE_REFDATAD where OBJECTCODE='FH' and DICNAME='"+arg.selectedValue+"'"},"/findBySQL.jhtml","json");
									$id("queryDialogGrid").objects[0].getCurrentItem().set("FH",entity[0].objectparm);
								}
							}
						} },
						{property:"TJ",caption:"查询条件" },
						],
						beforeShow :function(self,arg){
							self.refreshDom();
						},
						onGetCellEditor:function(self,arg){
							var  editor=null;
							if((arg.data.get("ZD")=="billdate" || "demandDate"==arg.data.get("ZD")) && "TJ"==arg.column.get("name")){
								 editor=new dorado.widget.TextEditor({
									editable:false,
									 trigger: {
										$type: "YearMonthDropDown",
										autoOpen:true,
										onValueSelect: function(self, arg) {
											arg.selectedValue = arg.selectedValue.formatDate("Y-m-d");
										}
									}
								 });
								 arg.cellEditor.setEditorControl(editor);
							}else if("TJ"==arg.column.get("name")&&arg.data.get("ZD")!="billdate" ){
								arg.cellEditor.setEditorControl(new dorado.widget.TextEditor());
							}
						},
						onReady:function(self,arg){
							var data=$id("dataGridM").objects[0].get("columns").items.slice(1);
							for(var i=0;i<data.length;i++){
								data[i].queryF="等于";
								data[i].FH="=";
								data[i].ZD=data[i]._name;
							}
							queryDialogSet.setData(data);
						}
				}]
			} );
				//布局容器	   
		   	new dorado.widget.Container({
		   		id:"MMM",
     			renderTo: document.body,
     			width:"100%",
     			height:"100%",
     			children :[toolBar,dataGridM,page.container,dataGrid,fieldSet/* fieldSetD */],
     			});		
		});
	</script>
  </head>
  
  <body>
  </body>
</html>
