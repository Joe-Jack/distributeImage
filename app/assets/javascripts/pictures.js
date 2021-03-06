
$(function() {
	navigator.mediaDevices = navigator.mediaDevices || ((navigator.mozGetUserMedia || navigator.webkitGetUserMedia) ? {
   getUserMedia: function(c) {
     return new Promise(function(y, n) {
       (navigator.mozGetUserMedia ||
        navigator.webkitGetUserMedia).call(navigator, c, y, n);
     });
	}
	} : null);

	if (!navigator.mediaDevices) {
	  console.log("getUserMedia() not supported.");
	  return;
	}

	// Prefer camera resolution nearest to 1280x720.

	var constraints = { audio: false, video: { width: 400, height: 300 } };

	navigator.mediaDevices.getUserMedia(constraints).then(function(stream) {
	  video = document.getElementById('camera');
	  //var video = document.querySelector('video');
	  //video.src = window.URL.createObjectURL(stream);
	  video.srcObject = stream;
	  localMediaStream = stream;
	  //console.log(video);
	}).catch(function(err) {
	  console.log(err.name + ": " + err.message);
	});
	
	$("#start").click(function() {
		if (localMediaStream) {
			var canvas = document.getElementById('canvas');
			//canvasの描画モードを2sに
			var ctx = canvas.getContext('2d');
			// var img = document.getElementById('img');

			//videoの縦幅横幅を取得
			// video.width = 400;
			// var w = video.width;
			// video.height = 300;
			// var h = video.height;

			//同じサイズをcanvasに指定
			canvas.setAttribute("width", 400);
			canvas.setAttribute("height", 300);
			// console.log(video);
			//canvasにコピー
			ctx.drawImage(video, 0, 0, 400, 300);
			//imgにpng形式で書き出し
			// img.src = canvas.toDataURL('image/jpeg');
			
		}
	});
	$("#actions").click(function(){
		if (localMediaStream) {
			var canvas = document.getElementById('canvas');
			//canvasの描画モードを2sに
			var ctx = canvas.getContext('2d');
			// var img = document.getElementById('img');

			//videoの縦幅横幅を取得
			var w = video.offsetWidth;
			var h = video.offsetHeight;

			//同じサイズをcanvasに指定
			canvas.setAttribute("width", w);
			canvas.setAttribute("height", h);

			//canvasにコピー
			ctx.drawImage(video, 0, 0, w, h);
			//imgにpng形式で書き出し
			// img.src = canvas.toDataURL('image/png');
			
		}
	});
	$('#save-button').click(function(){
		// var ctx = canvas.getContext('2d');
		var canvas = document.getElementById('canvas');
		var url = canvas.toDataURL('image/png');
		var urlToThumb = canvas.toDataURL('image/jpeg');
		// var blob1 = Base64toBlob(url);
		// var blob2 = window.URL.createObjectURL(blob1);
		// console.log(blob2);
		$("#picture_pic").val(""); 
		$("#picture_pic").val(urlToThumb);
		$("#new_picture").submit();
		$.ajax({
		    url: "canvasurl",
		    type: "post",
		    data: {content: url
		    },
		    datatype: "text",
		    success: function(data){
		      alert('success');
		    },
		    error: function(jqXHR, textStatus, errorThrown){
    		  alert(textStatus);
    		  alert(errorThrown.message);
    		  alert(jqXHR.status);
    		  alert(jqXHR.responseText);
    		},
		});
		// ctx.clearRect(0, 0, 800, 600);
	});
	
});


// Base64データをBlobデータに変換
function Base64toBlob(base64)
{
    // カンマで分割して以下のようにデータを分ける
    // tmp[0] : データ形式（data:image/png;base64）
    // tmp[1] : base64データ（iVBORw0k～）
    var tmp = base64.split(',');
    // base64データの文字列をデコード
    var data = atob(tmp[1]);
    // tmp[0]の文字列（data:image/png;base64）からコンテンツタイプ（image/png）部分を取得
		var mime = tmp[0].split(':')[1].split(';')[0];
	    //  1文字ごとにUTF-16コードを表す 0から65535 の整数を取得
		var buf = new Uint8Array(data.length);
		for (var i = 0; i < data.length; i++) {
	        buf[i] = data.charCodeAt(i);
	    }
	    // blobデータを作成
		var blob = new Blob([buf], { type: mime });
	    return blob;
}		

// function dataURLtoBlob(dataURL) {
// 	  // Decode the dataURL
// 	  var binary = atob(dataURL.split(',')[1]);
// 	  // Create 8-bit unsigned array
// 	  var array = [];
// 	  for(var i = 0; i < binary.length; i++) {
// 	      array.push(binary.charCodeAt(i));
// 	  }
// 	  // Return our Blob object
// 	  blob = new Blob([new Uint8Array(array)], {type: 'image/jpeg'});
// 	  return blob;
// 	}


// //videoタグを取得
// 	var video = document.getElementById('camera');
// 	//カメラが起動できたかのフラグ
// 	var localMediaStream = null;
// 	//カメラ使えるかチェック
// 	var hasGetUserMedia = function() {
// 		return (navigator.mediaDevices || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia);
// 	};

// 	//エラー
// 	var onFailSoHard = function(e) {
// 		console.log('エラー!', e);
// 	};

// 	if(!hasGetUserMedia()) {
// 		alert("未対応ブラウザです。")
// 		;
// 	} else {
// 		window.URL = window.URL || window.webkitURL;
// 		navigator.mediaDevices  = navigator.mediaDevices || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;
// 		navigator.mediaDevices.getUserMedia({video: true}, function(stream) {
// 			video.src = window.URL.createObjectURL(stream);
// 			// video.srcObject = stream;
// 			localMediaStream = stream;
// 			video.width = 400;
// 			video.height = 300;
// 		}, onFailSoHard);
// 	}