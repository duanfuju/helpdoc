function Module(){

}

Module.prototype={
    getExistModule:function(name){
        if( $(name).length==0){
            return ;
        }
        var container = $(name).parents('.box').parent();
        container.pos = container.attr('data-pos');
        container.size = container.attr('data-size');
        return container;
    },
    getAdd:function(){
        return this.getExistModule('.addModule');
    },
    getModule:function(name){
         //..通过名字从后端获取新模块数据

    },
    cloneModule:function(name){
        var clone = this.getExistModule(name).clone();
        clone.pos = clone.attr('data-pos');
        clone.size = clone.attr('data-size');
        return clone;
    },
    addNewModule:function(ele,add){
         var pos=(function(pos){
            pos=pos.split(',');
            return{
                col:pos[0],
                row:pos[1]
            }
        })(add.pos)
        ele.attr('data-pos',add.pos);
        if(add.pos.split(',')[0]==2){
            add.attr('data-pos',1+','+(+pos.row+1));
        }else{
            add.attr('data-pos',(+pos.col+1)+','+(pos.row));
        }

    },
    swModule:function(a,b){
        var pos=function(item){
            var pos=item.attr('data-pos');
            var size=item.attr('data-size');
            return {
                pos:pos,
                size:size
            }
        }
        aPos=pos(a);
        bPos=pos(b);
        if(aPos.size==bPos.size){
            a.attr('data-pos',bPos.pos);
            b.attr('data-pos',aPos.pos);
        }else{
                console.log('大小不一致');
        }
    },
    getLastModule:function(container){
        if(!container){
            console.log('请传入容器');
            return;
        }
        var $container = $(container),
              ms = $container.children('div'),
              l = ms.length;
        var last = $('div[data-moid='+String(l-1)+']',$container);
        return last;
    }

}
