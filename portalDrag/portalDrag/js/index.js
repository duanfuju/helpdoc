function Index() {
    this.module = new Module();
	this.init();
}

Index.prototype = {
    init: function() {
        this.render();
    },

    render: function() {
        this.initTile();
        this.slcModule();
        this.backSlc();
        this.hoverHeader();
    },
    initPos:function(){
    
		$(".boxHeader").each(function(i,d){
			var v=$(this).html();
			if(v=="近期组织能耗排名"){
				var b=$(".boxHeader:eq("+(i-1)+")").parents(".box").html();
				$(this).parents(".box").html(b1);
			}
		})
    },
    
    
    initTile: function() {
        var opt = {
            boxId: "indexCon",
            col: 2,
            divHeight: 320
        }
        this.tile = $.fn.tile(opt);
        $('#' + opt.boxId + ' .box').height(opt.divHeight - 10);
        (function(height, add) {
            var row = $(add).attr('data-pos').split(',')[1];
            $('#' + opt.boxId).css('height', row * height);
        })(opt.divHeight, this.module.getAdd());
    },
    
    
        slcModule: function() {
            $('.addModule').on('click', function() {
                $(this).hide().siblings().show();
            });
            var $btnArea = $('.moduleSlc .slcArea');
            var $btns = $('div', $btnArea);
            $btns.on('click', function() {
                var btn = $(this).find('button');
                if (btn.hasClass('current')) {
                    btn.removeClass('current')
                } else {
                    btn.addClass('current');
                }

            });
        },
        //返回选择模块
        backSlc: function() {
            var that = this;
            var count = 0;
            $('.moduleSlc .btnArea .cancel').on('click', function() {
                $(this).parents('.moduleSlc').hide().siblings().show();
            });
            $('.moduleSlc .btnArea .confirm').on('click', function() {
                var $btnArea = $('.moduleSlc .slcArea');
                var $btn = $('button', $btnArea);
                var arr = [];
                $btn.each(function(idx, dom) {
                    if ($(dom).hasClass('current')) {
                        arr.push($(dom).html());
                    }
                });
                console.log("---------------------arr")
                console.log(arr)
                for (var i = 0; i < arr.length; i++) {
                    var clone = function(name) {
                        var c = that.module.cloneModule(name);
                        c.find(name).attr('class', name + count++);
                        return c;
                    }('.insert')
                    var add = that.module.getAdd();
                     console.log("---------------------add")
                console.log(add)
                    $('#indexCon').append(clone);
                    that.hoverHeader();
                    that.module.addNewModule(clone, add);
                    that.initTile();
                }
                $('.moduleSlc .slcArea button').removeClass('current');
                $(this).parents('.moduleSlc').hide().siblings().show();
            })
        },
        hoverHeader: function() {
            var that = this;
            $('.boxHeader').hover(function() {
                $(this).find('img').remove();
                var $img = $(`<img src="img/remove.png">`);
                $(this).append($img);
                $(this).css('position', 'relative');
                $img.css({
                    'position': 'absolute',
                    'top': '7px',
                    'right': '7px',
                    'cursor': 'pointer'
                });
                $img.one('click', function() {
                    $(this).parent().parent().parent().remove();
                    that.initTile();
                });
            }, function() {
                $(this).find('img').remove();
            })
        }
}

$(function() {
    var index = new Index();
});



