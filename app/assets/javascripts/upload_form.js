$(function () {
  $('input:file').on("change", function() {
    window.showSpinner("#000");
    $('form#upload').submit();
  });
});
