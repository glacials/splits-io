$(function () {
  window.upload = function (file) {
    var data = new FormData();
    data.append("file", file);
    $.ajax({
      url: "/api/v3/runs",
      type: "POST",
      data: data,
      cache: false,
      processData: false,
      contentType: false,
      success: function (data, textStatus, xhr) {
        localStorage.setItem("claim_tokens/" + data.id, data.claim_token);
        window.location = data.uris.public_uri;
      },
      error: function (xhr, textStatus) {
        window.isUploading = false;
        if (xhr.status == 400) {
          window.location = '/cant-parse';
        } else {
          $("#droplabel").html("oops, got a " + xhr.status + " (" + xhr.statusText + ").<br />try again, or contact glacials.<br />");
          window.spinner.stop();
        }
      }
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
    $.each(evt.originalEvent.dataTransfer.files, function(filename, file) {
      $("#droplabel").html("parsing...");
      window.isUploading = true;
      window.showSpinner("#fff");
      window.upload(file);
    });
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
