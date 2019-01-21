
$(function() {
   vn = navigator.mediaDevices = navigator.mediaDevices || ((navigator.mozGetUserMedia || navigator.webkitGetUserMedia) ? {
   getUserMedia: function(c) {
     return new Promise(function(y, n) {
       (navigator.mozGetUserMedia ||
        navigator.webkitGetUserMedia).call(navigator, c, y, n);
     });
	}
	} : null);
	if (!navigator.mediaDevices) {
	  alert("getUserMedia() not supported.");
	  return;
	} else {
		console.log("success")
	}

	// Prefer camera resolution nearest to 1280x720.
	var constraints = { audio: false, video: { 
						advanced: [
							{ width: 640 },
							{ height: 360 },
							{ aspectRatio: 1.5 },
							{ facingMode: 'environment' } 
							]}
					};

	navigator.mediaDevices.getUserMedia(constraints).then(function(stream) {
	  video = document.getElementById('camera');
	  //var video = document.querySelector('video');
	  //video.src = window.URL.createObjectURL(stream);
	  // videoの縦幅横幅を取得
	  var settings = stream.getVideoTracks()[0].getSettings();
	  width = settings.width;
      height = settings.height;
	  video.width = 360;
	  video.height = 640;
	  video.srcObject = stream;
	  localMediaStream = stream;
	}).catch(function(err) {
	  console.log(err.name + ": " + err.message);
	});
	
	
	$("#start").click(function() {
		if (video.srcObject) {
			var canvas = document.getElementById('canvas');
			var canvass = document.getElementById('canvass');
			// diplay:inlineでnoneから回復（９４行目）
			canvass.style.display = "inline";
			var back = document.getElementById('back');
			var start = document.getElementById('start');
			//canvasの描画モードを2dに
			var ctx = canvas.getContext('2d');
			var ctxs = canvass.getContext('2d');
			var w = 1000;
			var h = 1000;
			// 同じサイズをcanvasに指定
			canvas.setAttribute("width", w);
			canvas.setAttribute("height", h);
			// setAttributeを設定しないと上手く貼り付けられない(teratail、29番目質問)
			canvass.setAttribute("width", 640);
			canvass.setAttribute("height", 360);
			// 撮影した画像が横長ならそのまま、縦長なら９０度回転させて表示
			if (width > height) {
				ctxs.drawImage(video, 0, 0, 640, 360);
			} else {
				// 回転前に左上重心移動(height640x分)
				ctx.translate(640, 0);
				// 回転（左から右に）setAttributeの幅・高さを超えると画像がその分消えてしまう
				ctx.rotate(90/180*Math.PI);
				// canvasにコピー
				// ctx.translate(-320, 0);
				// canvas.setAttribute("height", h/2);
				// 回転させると同時にwidth,heightも回転するので気をつける
				ctx.drawImage(video, 0, 0, 360, 640);
				// ctxを切り取り
				var imagedata = ctx.getImageData(0, 0, 640, 360);
				// console.log(imagedata.height);
				// ctx2.createImageData(360, 640);
				// ctx.putImageData(imagedata, 30, 10);
				// ctxs.drawImage(video, 0, 0, 640, 360);
				// 切り取ったimgadataを貼り付け
				ctxs.putImageData(imagedata, 0, 0);
				// alert(canvas.getAttribute("width"))
				// canvas.width = 640;
				// canvas.height = 360;
				// ctx.drawImage(video, 0, 0,360, 200, 0, 0, 640, 360)
			}
		// 撮影後に画面を切り替える
		video.style.display = "none";
		back.style.display = "inline";
		start.style.display = "none";
		$("#back").click(function() {
			canvass.style.display = "none";
			back.style.display = "none";
			video.style.display = "inline";
			start.style.display = "inline";
			
		});
		}
	});
	
	$("#actions").click(function(){
		if (localMediaStream) {
			var canvas = document.getElementById('canvas');
			//canvasの描画モードを2sに
			var ctx = canvas.getContext('2d');
			// var img = document.getElementById('img');

			//videoの縦幅横幅を取得
			// var w = video.offsetWidth;
			// var h = video.offsetHeight;

			//同じサイズをcanvasに指定
			canvas.setAttribute("width", 100);
			canvas.setAttribute("height", 100);

			//canvasにコピー
			ctx.drawImage(video, 0, 0, 100, 100);
			//imgにpng形式で書き出し
			// img.src = canvas.toDataURL('image/png');
			
		}
	});
	$('#save-buttonn').click(function(){
		var bucketName = 'distributeimage';
		var regionName = 'ap-northeast-1';
		AWS.config.update({
		    accessKeyId: gon.aws_access_key_id,
		    secretAccessKey: gon.aws_secret_key,
		});
		var bucket = new AWS.S3({
		    params: {
		        Bucket: bucketName,
		        Region: regionName,
		    },
		});
		
		var canvas = document.getElementById('canvass');
		var url = canvas.toDataURL('image/png');
		// console.log(url.length)
		var urlToThumb = canvas.toDataURL('image/jpeg', 0.1);
		// console.log(urlToThumb.length)
		var blob1 = Base64toBlob(url);
		 bucket.putObject(
            {
                'ACL': 'public-read',
                'Key': 'user'+gon.user+'_namenum'+gon.index+'_'+gon.time,
                'ContentType': 'image/png',
                'Body': blob1,
            },
            function (error, data) {
                if (error === null) {
                } else {
                }
            }
        );
		// var blob2 = window.URL.createObjectURL(blob1);
		$("#picture_pic").val(""); 
		$("#picture_pic").val(urlToThumb);
		$("#new_picture").submit();
		// $.ajax({
		//     url: "canvasurl",
		//     type: "post",
		//     data: {content: url
		//     },
		//     datatype: "text",
		//     success: function(data){
		//       alert('success');
		//     },
		//     error: function(jqXHR, textStatus, errorThrown){
  //  		  alert(textStatus);
  //  		  alert(errorThrown.message);
  //  		  alert(jqXHR.status);
  //  		  alert(jqXHR.responseText);
  //  		},
		// });
		
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
    //  1文字ごとにUTF-16コードを表す 0から65535 の整数���取得
	var buf = new Uint8Array(data.length);
	for (var i = 0; i < data.length; i++) {
        buf[i] = data.charCodeAt(i);
    }
    // blobデータを作成
	var blob = new Blob([buf], { type: mime });
    return blob;
}		


