$(function(){
	var elm = document.getElementsByClassName('dragedanddroped');
	// var elm = document.getElementsByTagName("img");
	
	for ( var i=0 ; i < elm.length ; i++ )
	    {
	      elm[i].addEventListener("dragstart", function(evt){
	      	console.log("start");
	      	origin_id = evt.path[2].id.slice(2.)
	      	image_number = evt.path[0].title
	      	// console.log(image_number);
	        evt.dataTransfer.setData("text/plain",evt.target.src);
	        evt.stopPropagation();
	      },false);
	    }
	    
	var droparea = document.getElementsByClassName("dropboxed");

	for ( var i=0; i < droparea.length ; i++ ){
	    droparea[i].addEventListener("drop", function(evt){
		    data = evt.dataTransfer.getData( "text/plain" );
		    var obj = document.getElementById(evt.target.id);
		    console.log(evt);
		    id = obj.id.slice(2);
		    
		 
		    // セレクターを作成
		    var newselecter = document.createElement("img");
		    // 新たに作ったセレクターに属性（src,class）を付ける
		    newselecter.setAttribute("src", data);
		    newselecter.classList.add("droppedimages");
			// console.log(newselecter);
		    if(data){
				var result = confirm('本当にコピペしますか？');
				if(result) {
					obj.appendChild(newselecter);
					$.ajax({
					    url: "indices/" + id + "/pictures/imagecopy",
					    type: "post",
					    data: {
					    	index_id: id,
					    	origin_id: origin_id,
					    	image_number: image_number
					    },
					    datatype: "text",
					    success: function(data){
					      // alert('success');
					    },
					    error: function(jqXHR, textStatus, errorThrown){
			  			　alert(textStatus);
			    		  alert(errorThrown.message);
			    		  alert(jqXHR.status);
			    		  alert(jqXHR.responseText);
			    		},
					});
					$.ajax({
					    url: "indices/" + id + "/dropnew",
					    type: "post",
					    data: {
					    	content: data,
					    	index_id: id
					    },
					    datatype: "text",
					    success: function(data){
					      // alert('success');
					    },
					    error: function(jqXHR, textStatus, errorThrown){
					  	　alert(textStatus);
						  alert(errorThrown.message);
						  alert(jqXHR.status);
						  alert(jqXHR.responseText);
						},
					});	
					
				} 
		    }
		    $(this).css({
	    		"border": "solid thin",
	    		"background-color": "white",
	    		"border-style": "solid",
	    		"height": "25px"
	    	});
	    	evt.preventDefault();
    	},false);
	    
	    droparea[i].addEventListener("dragenter" , function(evt){
	    	$(this).css({
	    		"background-color": "#fff",
	    	    "border": "ridge 1px",
	    	    "height": "75px"
	    	});
	    	evt.preventDefault();
	    }, false);
	    droparea[i].addEventListener("dragover" , function(evt){
	    	$(this).css({
	    		"background-color": "#fff",
	    		"border": "ridge 3px",
	    		"height": "75px"
	    	});
	    	evt.preventDefault();
	    }, false);
	    
	    droparea[i].addEventListener("dragleave" , function(evt){
	    	$(this).css({
	    		"border": "solid thin",
	    		"background-color": "white",
	    		"height": "25px"
	    	});
	    	evt.preventDefault();
	    }, false);
	    
	    droparea[i].addEventListener("dragend" , function(evt){
	    	$(this).css({
	    		"border": "solid thin",
	    		"background-color": "white",
	    		"height": "25px",
	    	});
	  //  	$("#picture_index_id").val(id); 
			// $("#picture_pic").val(data);
			// $("#new_picture").submit();
	    	// console.log(id);
	    	evt.preventDefault();
	    }, false);
	}  
});

$(function() {
	$("#switch").click('turbolinks:load', function() {
		// alert("a");
		var normalmode = document.getElementById('normalmode');
		var csvmode = document.getElementById('csvmode');
		var midashi = document.getElementById('midashi');
		if (normalmode.style.display == "none") {
			normalmode.style.display = "block";
			csvmode.style.display = "none";
			midashi.style.display = "block";
		} else {
			normalmode.style.display = "none";
			csvmode.style.display = "inline";
			midashi.style.display = "none";
		}
	});	
});


	

