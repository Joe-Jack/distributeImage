
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
	
	var constraints = { audio: false, video: { 
						// width: 1280, 
						// height: 720,
						facingMode: 'environment' 
							}
					};
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
	
	// document.getElementById('button').onclick = function () {
 //       document.getElementById('camera').play();
	// const medias = {audio : false, video : true},
 //   video  = document.getElementById("camera");
	// navigator.getUserMedia(medias, successCallback, errorCallback);
	
	// function successCallback(stream) {
	//   video.srcObject = stream;
	// };
	
	// function errorCallback(err) {
	//   alert(err);
	// };
		
	$("#start").click(function() {
		if (localMediaStream) {
			var canvas = document.getElementById('canvas');
			//canvasの描画モードを2dに
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
		
		var canvas = document.getElementById('canvas');
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


