function showImg(path){
	layer.photos({
	    photos: {
    	  	"data": [{
    	      	"src": path//ԭͼ��ַ
    	    }]
	    },
	    tab: function (pic, layero) {
	    	var css = {
	    			width: window.width,
		    		height: window.height
	    	}
	    	$(layero.selector).find('img').css(css);
	    	
	    }
	});
}