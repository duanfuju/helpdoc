/** @Bind #dsDoc.onReady */
!function(dsDoc){
	dsDoc.insert();
};



//@Bind #dgShow.onDataRowClick 
!function(dgShow,dsDoc){
	var dataset =dgShow.get("dataSet");
	var row = dataset.getData("#");
	var _id= row.get("id");
	if (_id) {
		dsDoc.set("parameter",_id);
		dsDoc.flushAsync();
	}
};



/** @Bind #autoUpdateAction.onSuccess   */
!function(dsDocList){
	dsDocList.flushAsync();
};










/**------上传 start---------*/
/** @Bind #btnFile.onClick   */
!function(fileDialog,fileIFrame,dsDoc){
	var data = dsDoc.getData();
	var fileid = "";
	if(data != null){
		fileid = data.get("fileid");
	}
	var _type = "fileShowPath";   //参照config.xml
	var _pathType = "DOC";   //参照FileUtils文件
	var _exec = "doc";     //限制上传格式
	var _size= "2MB";    //限制上传文件大小
	fileIFrame.set("path","cn.com.oking.upload.upload.d?fileid="+fileid+
			"&type="+ _type+   //showPath类型
			"&pathType="+_pathType+        //保存文件夹
			"&exec="+_exec+        //上传文件格式
			"&size="+_size);       //文件大小
	fileDialog.show();
	fileIFrame.reload();
};

window.setUploadParam = function(fileid,filename){
	if(fileid != null && fileid != "" && fileid != undefined && 
			filename != null && filename != "" && filename != undefined){
		dorado.MessageBox.alert("文件上传成功！  \n \t文件名:"+filename+"\n\t关联ID:"+fileid);
		var data = view.get("#dsDoc").getData();
		data.set("fileid",fileid);
		data.set("filename",filename);
		view.get("#fileDialog").hide();
		var action=view.get("#autoUpdateAction");
		action.execute();
	}
};

/**------上传 end---------*/

/** @Bind #btnFileLoad.onClick   */
!function(dsDoc){
	//为ajax设置参数
	//获取datagird当前选中的数据行并获取列filedid的值
	var datagrid = this.get("#dgShow");
	var dataset =datagrid.get("dataSet");
	var row = dataset.getData("#");
	var fileid= row.get("fileid");
	location.href='DownloadServlet?filedid='+fileid;
};
