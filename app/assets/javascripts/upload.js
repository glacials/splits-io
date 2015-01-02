$(function () {
  window.upload = function (file) {
    var data = new FormData();
    data.append("file", file);
    $.ajax({
      url: "/api/v2/runs",
      type: "POST",
      data: data,
      cache: false,
      processData: false,
      contentType: false,
      success: function (data, textStatus, xhr) {
        $.ajax({
          url: xhr.getResponseHeader("Location"),
          type: "GET",
          success: function (data, textStatus, xhr) {
            window.location = "/" + data.run.id.toString(36);
          }
        });
      },
      error: function (xhr, textStatus) {
        if (xhr.status == 400) {
          window.location = '/cant-parse';
        }
      }
    });
  };

  $("#dropzone").on("dragenter", function (evt) {
    evt.preventDefault();
    evt.stopPropagation();
    $("img").css("opacity", .05);
    $("#dropzone-overlay").fadeTo(125, .9);
  });
  $("#dropzone").on("dragleave", function (evt) {
    if (event.pageX < 10 || event.pageY < 10 || $(window).width() - event.pageX < 10 || $(window).height - event.pageY < 10) {
      $("#dropzone-overlay").fadeOut(125);
      $("img").css("opacity", 1);
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
