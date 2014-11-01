$(function () {
  window.upload = function (file) {
    var data = new FormData();
    data.append("file", file);
    $.ajax({
      url: "/api/v1/runs",
      type: "POST",
      data: data,
      cache: false,
      processData: false,
      contentType: false,
      success: function (data, textStatus, jqXHR) {
        console.log(jqXHR.getAllResponseHeaders());
        $.ajax({
          url: jqXHR.getResponseHeader("Location"),
          type: "GET",
          success: function (data, textStatus, jqXHR) {
            window.location = data.url;
          },
          error: function (jqXHR, textStatus, error) {
            console.log(jqXHR.responseText);
            console.log(textStatus);
            console.log(error);
          }
        });
      },
      error: function (jqXHR, textStatus, error) {
        console.log(jqXHR.responseText);
        console.log(textStatus);
        console.log(error);
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
      window.showSpinner("#fff");
      window.upload(file);
    });
  });
});
