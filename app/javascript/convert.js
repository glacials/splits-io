import {saveAs} from "file-saver";

$(() => {
  $("form#convert").submit((evt) => {
    evt.preventDefault();
    let formData = new FormData();
    formData.set("file", $("#convert-file-input")[0].files[0]);
    formData.set("format", $("#convert-format-select").val());

    $("#dropzone-overlay").fadeTo(125, 0.9);
    $("#droplabel").text("Converting file...");
    window.isUploading = true;
    window.showSpinner("#fff");

    $.ajax({
      method: "POST",
      url: "/api/v4/convert",
      data: formData,
      cache: false,
      processData: false,
      contentType: false,
      success: (response, textStatus, xhr) => {
        window.isUploading = false;
        window.spinner.stop();
        let filename = xhr.getResponseHeader("X-Filename");
        var blob = new Blob([response]);
        saveAs(blob, filename);
        $("#dropzone-overlay").fadeOut(125);
      },
      error: (xhr) => {
        window.isUploading = false;
        window.spinner.stop();
        $("#droplabel").text(`Error converting: ${xhr.responseJSON.message}`);
      }
    });
  });
});
