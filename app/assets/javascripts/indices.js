// $(function () {

//     // dropzoneの表示テキストを初期化
//     initDropzone();

//     // listテーブルのitem行が操作された時のリスナーを設定
//     // items = document.getElementById('d&d').getElementsByClassName('images');

//     Array.prototype.forEach.call(items, function (item) {
//         $(item).on('dragstart', onDragStart);
//         $(item).on('dragend', onDragEnd);
//     });
//     // dropzoneのリスナーを設定
//     var $dropbox = $("[id^=dropbox]")
//         .on('dragover', onDragOver)
//         .on('dragenter', onDragEnter)
//         .on('dragleave', onDragLeave)
//         .on('drop', onDrop);
        
//     // dropzoneの表示テキストを指定
//     var dropbox = "[id^=dropbox]"
//     function initDropzone() {
//         $(dropbox).text("ここにドロップできます。");
//     }

//     function startDropzone() {
//         $(dropbox).text("ドラッグ中。");
//     }

//     function endDropzone(name) {
//     $(dropbox).text(name + "をドロップしました。");
//     }
    
//     //  ドロップ時の処理
//     // (1) ドロップされた行のidをPOSTする
//     // (2) 成功したらリダイレクトする
//     // (3) 失敗したらダイアログを表示する
//     // function doAction(id) {
//     //     $.ajax({
//     //         url: "<%=  sample_add_path  %>",
//     //         type: "POST",
//     //         data: {
//     //             id: id
//     //         },
//     //         dataType: "html",
//     //         success: function (data) {
//     //             //alert("success");

//     //             // dataにドラッグ＆ドロップした
//     //             // Userのid, nameがjson形式で
//     //             // 渡される
//     //             // console.log(data);
//     //             // {"id":1,"name":"Yamada Taro"}

//     //             // 暫定的にページを再読込
//     //             location.href = "<%= sample_index_path %>"
//     //         },
//     //         error: function (data) {
//     //             alert("errror");
//     //         }
//     //     });
//     // }

//     // ドラッグ＆ドロップ操作
//     function onDragStart(e) {
//         var id = e.originalEvent.target.id;
//         var name = e.originalEvent.target.cells[1].innerHTML;
//         e.originalEvent.dataTransfer.setData('id', id);
//         e.originalEvent.dataTransfer.setData('name', name);
//         addDraggingEffect();
//         startDropzone();
//     }

//     function onDragEnter(e) {
//         addEnterEffect();
//     }

//     function onDragLeave(e) {
//         removeEnterEffect();
//     }

//     function onDragOver(e) {
//         e.preventDefault();
//     }

//     function onDragEnd(e) {
//         resetAllEffect();
//     }

//     function onDrop(e) {
//         e.preventDefault();
//         var id = e.originalEvent.dataTransfer.getData('id');
//         var name = e.originalEvent.dataTransfer.getData('name');
//         endDropzone(name);
//         doAction(id);
//     }

//     function addDraggingEffect() {
//         $dropzone.addClass('dragging');
//     }

//     function removeDraggingEffect() {
//         $dropzone.removeClass('dragging');
//         initDropzone();
//     }

//     function addEnterEffect() {
//         $dropzone.addClass('dragenter');
//     }

//     function removeEnterEffect() {
//         $dropzone.removeClass('dragenter');
//     }

//     function resetAllEffect(e) {
//         removeDraggingEffect();
//         removeEnterEffect();
//     }
// });

