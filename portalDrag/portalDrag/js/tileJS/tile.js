function tile(opt){
	this.id = opt.boxId;
	this.col = opt.col;
	this.divHeight = opt.divHeight;
	//this.margin = opt.margin;
	//+handle
	this.$box = $("#"+this.id);
        this.curPOS = null;//当前选区位置
	this.map = null;//位置地图
	this.init();
}
tile.prototype={
	init:function(){
		 this.initBox();
		 this.location();
		 this.initDrag();
	},
	initBox:function(){
		var that = this;
		//设置容器定位方式
		this.$box.css({
			position:"relative"
		})
	},
	location:function(){
		var that = this;
		this.map = [];
		//遍历子容器，设定位置
		this.$box.children().each(function(e){
			//编队
			var idx = $(this).index();
			$(this).attr("data-moID",idx)
			//取大小和位置
			var size = $(this).attr("data-size").split(","),
				pos =  $(this).attr("data-pos").split(",");
			//定位
			$(this).css({
				width:(100/that.col*size[0])+"%",
				height:that.divHeight*size[1],
				position:"absolute",
				left:(100/that.col*(pos[0]-1))+"%",
				top:that.divHeight*(pos[1]-1)

			})
			//注册位置
			that.bindMap(size,pos,idx)

		})
		//console.log(that.map)
	},
	eleLocate:function($obj,pos){
		var that = this;
		//取位置
		var pos =  pos.split(",");
		//定位
		$obj.css({
			left:(100/that.col*(pos[0]-1))+"%",
			top:that.divHeight*(pos[1]-1)
		})
	},
	bindMap:function(size,pos,$obj){
		//注册位置
		for(var i=0;i<size[0];i++){
			for(var j=0;j<size[1];j++){
				this.map[(pos[0]-1+i)+","+(pos[1]-1+j)]=$obj;
			}
		}
	},
	//
	curArea:function(size,pos,ui){
		var divX = this.$box.innerWidth()/this.col;
		//yizhongxindianpanduan
		var posX = ui.position.left+divX/2;
		var posY = ui.position.top+this.divHeight/2;
		var curX = posX<0?parseInt(posX/divX)-1:parseInt(posX/divX);//console.log(curX)
		var curY = posY<0?parseInt(posY/this.divHeight)-1:parseInt(posY/this.divHeight);//console.log(curY)
		var arr = [];
		for(var i=0;i<size[0];i++){
			for(var j=0;j<size[1];j++){
				arr.push((curX+i)+","+(curY+j));
			}
		}
		//console.log(arr);
		return arr;
	},
	exchangeType:function(arr,orgID,size,pos){
		//根据map计算ARR范围内覆盖元素可交换性
		var cross = false,
			crossEle = [],//交切元素id集合
			ox = null,//第一个相交元素
			oy = null,
			cx=0,
			cy=0;
		for(var i=0;i<arr.length;i++){
			var oArr = arr[i].split(",");//console.log(oArr)
			//超出边界
			if(oArr[0]<0||oArr[0]>=this.col||oArr[1]<0){//暂不考虑Y轴越界
				return false
			}
			if(this.map[arr[i]]!=undefined){

				if(this.map[arr[i]]==orgID){//重叠块

					if(i==0 && (pos[0]-1)==oArr[0] && (pos[1]-1)==oArr[1]){//原位置没动
						return false
					}
					cross = true;
					if(ox!=null){

						if(oArr[0]==ox){//同X轴 即为Y+1
							cy += 1;
						}
						if(oArr[1]==oy){
							cx += 1;
						}
					}else{

						ox = oArr[0];
						oy = oArr[1];
						cx += 1;
						cy += 1;
					}
				}else{
					//记录编号
					//加入切入区占元素
					if(crossEle.length){
						for(var k=0;k<crossEle.length;k++){
							if(this.map[arr[i]]==crossEle[k]){
								break;
							}
							if(k==crossEle.length-1){
								crossEle.push(this.map[arr[i]])
							}
						}
					}else{
						crossEle.push(this.map[arr[i]])
					}
					//根据当前所占位置块编号查找
					for(var j in this.map){
						if(this.map[arr[i]]==this.map[j] && arr[i]!=j){
							//校验是否在范围内
							var res = false;
							for(var k=0;k<arr.length;k++){
								if(j==arr[k]){//该坐标在目标区域内
									res = true;
								}
							}
							if(!res){
								return false;
							}

						}
					}
				}

			}
		}
		//若重叠块数组不为空的时候，判断镜像方式
		var type = "trans";
		if(cross){console.log(cx+":"+cy)
			if(size[0]==cx && size[1]==cy){
				return false;
			}else if(size[0]==cx){
				type = "X"
			}else if(size[1]==cy){
				type = "Y"
			}else{
				type = "center"
			}

		}
		return {
			type:type,
			ele:crossEle
		}

	},
	//移动方式和移动元素id对象，当前范围数组，移动本体大小，移动本体初始位置,移动本体JQ对象
	move:function(ex,cu,size,pos,$this){console.log(cu)
		if(!ex){//非法区域时 还原
			$this.removeAttr("data-posing");
			this.recover();
			return;
		}
		this.recover();
		//当前移动区块标记
		var org = cu[0].split(",");
		$this.attr("data-posing",(parseInt(org[0])+parseInt(1))+","+(parseInt(org[1])+parseInt(1)));
		for(var i=0;i<ex.ele.length;i++){//排队上车
			var $obj = this.$box.children("[data-moID="+ex.ele[i]+"]");
			var cuPos = $obj.attr("data-pos").split(","),
				cuSize = $obj.attr("data-size").split(","),
				toPos = "";
			switch(ex.type)
			{
				case "center":
					//以中心位置镜像
					toPos = (size[0]-cuPos[0]+parseInt(org[0])+1-cuSize[0]+parseInt(pos[0]))+","+(size[1]-cuPos[1]+parseInt(org[1])+1-cuSize[1]+parseInt(pos[1]))
				    break;
				case "X":
					//以X轴镜像
					toPos = (cuPos[0]-org[0]-1+parseInt(pos[0]))+","+(size[1]-cuPos[1]+parseInt(org[1])+1-cuSize[1]+parseInt(pos[1]))
					break;
				case "Y":
					//以Y轴镜像
					toPos = (size[0]-cuPos[0]+parseInt(org[0])+1-cuSize[0]+parseInt(pos[0]))+","+(cuPos[1]-org[1]-1+parseInt(pos[1]))
					break;
				default:
					//相对平移
					toPos = (cuPos[0]-org[0]-1+parseInt(pos[0]))+","+(cuPos[1]-org[1]-1+parseInt(pos[1]))

			}
			console.log(ex.type)
			console.log(toPos)

			$obj.attr("data-posing",toPos).addClass("moving");
			this.eleLocate($obj,toPos);
		}


	},
	//还原所有移动中的元素
	recover:function(){
		var that = this;
		this.$box.children(".moving").each(function(){
			var _this = $(this);
			_this.removeAttr("data-posing").removeClass("moving");
			var pos = _this.attr("data-pos");//console.log(_this)
			that.eleLocate(_this,pos);//console.log(pos)
		})
	},
	//刷新定位信息
	refresh:function(){
		var that = this;
		this.$box.children().each(function(){
			var _this = $(this);
			_this.removeClass("moving");
			var newPos = _this.attr("data-posing");
			if(newPos){
				_this.attr("data-pos",newPos).removeAttr("data-posing")
			}
		})
	},
	initDrag:function(){
		var that = this;
		this.$box.children().draggable({
				opacity:0.9,
				zIndex:9999,
				//revert:"invalid",
				//start: function(event, ui){console.log(event);console.log(ui)},
				drag: function(event, ui){//console.log($(this))
					//console.log(ui)
					//拖拽时逻辑
					//计算当前覆盖位置,多于临界值不反应
					var size = $(this).attr("data-size").split(","),
					posStr = $(this).attr("data-pos")
					pos = posStr.split(",");
					id = $(this).attr("data-moID")
					//先计算出占区，然后将占区内容平移(无误)至移动块原位置，并校验合法性，如合法则移动，需要注意移动不完全的情况，推导结果时可移植原区不一定=初始位置
					//当前拖拽hover的区块，暂不考虑超出区域情况，即为小的不能替换大的
					var curArr = that.curArea(size,pos,ui);
					//获得当前占用区域后，分为在原区域，相交区域，分离三种情况
					if(curArr[0]==(pos[0]-1)+","+(pos[1]-1)){//原区域 不操作
						//return;
					}
					if(that.curPOS == curArr[0]){//缓存当前选区位置，如本次和记录中数值相同则不进一步操作(优化性能)
						return;
					}else{
						that.curPOS = curArr[0];
					}
					//console.log(curArr)
					var exchangeObj = that.exchangeType(curArr,id,size,pos);//console.log(exchangeObj)
					that.move(exchangeObj,curArr,size,pos,$(this))

				},
				stop: function(event, ui){
					//放鼠标时逻辑
					//修改pos信息，重新注册MAP
					that.refresh();//刷新位置标记
					that.location();//重新注册
				}

			});
	}
}


$.fn.tile=function(opt){
	return new tile(opt);
}
