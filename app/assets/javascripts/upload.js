$(function () {
  window.upload = function (file, options) {
    options = options || {redirect: true}
    var data = new FormData();
    data.append("file", file);
    return $.ajax({
      url: "/api/v3/runs",
      type: "POST",
      data: data,
      cache: false,
      processData: false,
      contentType: false,
      success: function (data, textStatus, xhr) {
        localStorage.setItem("claim_tokens/" + data.id, data.claim_token);
        if (options.redirect) {
          window.location = data.uris.public_uri;
        }
      },
      error: function (xhr, textStatus) {
        window.isUploading = false;
        if (xhr.status === 400) {
          if (options.redirect === true) {
            window.location = '/cant-parse';
          }
        } else {
          $("#droplabel").html("oops, got a " + xhr.status + " (" + xhr.statusText + ").<br />try again, or contact glacials.<br />");
          window.spinner.stop();
        }
      }
    });
  };

  window.uploadAll = function (files) {
    $("#multiupload").show();

    Promise.all(files.map(function (file) {
      return new Promise(function (resolve, reject) {
        window.upload(file, {redirect: false}).then(function () {
          $("#successful-uploads").html(Number($("#successful-uploads").html()) + 1);
          resolve();
        }, function (err) {
          $("#failed-uploads").html(Number($("#failed-uploads").html()) + 1);
          resolve();
        });
      });
    })).then(function () {
      window.location = "/";
    });
  };

  $("#dropzone").on("dragenter", function (evt) {
    evt.preventDefault();
    evt.stopPropagation();
    $("#dropzone-overlay").fadeTo(125, .9);
  });

  $("#dropzone").on("dragleave", function (evt) {
    if (event.pageX < 10 || event.pageY < 10 || $(window).width() - event.pageX < 10 || $(window).height - event.pageY < 10) {
      $("#dropzone-overlay").fadeOut(125);
    }
  });

  $("#dropzone").on("dragover", function (evt) {
    evt.preventDefault();
    evt.stopPropagation();
  });

  $("#dropzone").on("drop", function (evt) {
    evt.preventDefault();
    evt.stopPropagation();
    files = evt.originalEvent.dataTransfer.files;

    if (files.length > 1 && gon.user === null) {
      $("#droplabel").html("to upload more than one file at a time, please sign in.");
      return
    }
    $("#droplabel").html("parsing...");
    window.isUploading = true;
    window.showSpinner("#fff");
    if (files.length > 1) {
      window.uploadAll(_.toArray(files));
    } else {
      window.upload(files[0]);
    }
  });

  $("#dropzone").click(function (evt) {
    if (!window.isUploading) {
      $("#dropzone-overlay").fadeOut(125);
    }
  });

  $(document).keyup(function (evt) {
    if (!window.isUploading && evt.keyCode == 27) {
      $("#dropzone-overlay").fadeOut(125);
    }
  });
});
