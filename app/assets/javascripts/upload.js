(function () {
  var dropArea = document.getElementById("dropzone"),
      fileList = document.getElementById("file-list");

  function uploadFile (file) {
    var li = document.createElement("div"),
      img,
      progressBarContainer = document.createElement("div"),
      progressBar = document.createElement("div"),
      reader,
      xhr,
      fileInfo;

    progressBarContainer.className = "progress-bar-container";
    progressBar.className = "progress-bar";
    progressBarContainer.appendChild(progressBar);
    li.appendChild(progressBarContainer);

    /*
      If the file is an image and the web browser supports FileReader,
      present a preview in the file list
    */
    if (typeof FileReader !== "undefined" && (/image/i).test(file.type)) {
      img = document.createElement("img");
      li.appendChild(img);
      reader = new FileReader();
      reader.onload = (function (theImg) {
        return function (evt) {
          theImg.src = evt.target.result;
        };
      }(img));
      reader.readAsDataURL(file);
    }

    var formData = new FormData(),
        xhr      = new XMLHttpRequest();

    formData.append('authenticity_token', $('meta[name="csrf-token"]').attr('content'));
    formData.append('file', file);

    xhr.open('POST', '/upload', true);
    xhr.onload = function() {
      if (xhr.status === 200) {
        console.log('all done: ' + xhr.status);
      } else {
        console.log('Something went wrong...');
      }
    };

    xhr.setRequestHeader('accept', '*/*;q=0.5, text/javascript');
    xhr.send(formData);

    // Present file info and append it to the list of files
    $("#droplabel").html("uploaded!");

    fileList.appendChild(li);
  }

  function traverseFiles (files) {
    if (typeof files !== "undefined") {
      for (var i=0, l=files.length; i<l; i++) {
        uploadFile(files[i]);
      }
    }
    else {
      fileList.innerHTML = "No support for the File API in this web browser";
    }
  }

  dropArea.addEventListener("dragleave", function (evt) {
    var target = evt.target;

    if (target && target === dropArea) {
      this.className = "";
    }
    evt.preventDefault();
    evt.stopPropagation();
    /*
     * We have to double-check the 'leave' event state because this event stupidly
     * gets fired by JavaScript when you mouse over the child of a parent element;
     * instead of firing a subsequent enter event for the child, JavaScript first
     * fires a LEAVE event for the parent then an ENTER event for the child even
     * though the mouse is still technically inside the parent bounds. If we trust
     * the dragenter/dragleave events as-delivered, it leads to "flickering" when
     * a child element (drop prompt) is hovered over as it becomes invisible,
     * then visible then invisible again as that continually triggers the enter/leave
     * events back to back. Instead, we use a 10px buffer around the window frame
     * to capture the mouse leaving the window manually instead. (using 1px didn't
     * work as the mouse can skip out of the window before hitting 1px with high
     * enough acceleration).
     */
    if(evt.pageX < 10 || evt.pageY < 10 || $(window).width() - evt.pageX < 10
      || $(window).height - evt.pageY < 10) {
      $("#dropzone-overlay").fadeOut(125);
    }
  }, false);

  dropArea.addEventListener("dragenter", function (evt) {
    this.className = "over";
    evt.preventDefault();
    evt.stopPropagation();
    $("#dropzone-overlay").fadeTo(125, .9);
  }, false);

  dropArea.addEventListener("dragover", function (evt) {
    evt.preventDefault();
    evt.stopPropagation();
  }, false);

  dropArea.addEventListener("drop", function (evt) {
    traverseFiles(evt.dataTransfer.files);
    this.className = "";
    evt.preventDefault();
    evt.stopPropagation();
  }, false);
})();
