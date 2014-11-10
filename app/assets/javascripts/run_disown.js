$(function () {
  window.disown_run = function (run) {
    $("#run_" + run.id).fadeOut(300, function () { $(this).remove(); });
    $.ajax({
      url: "/api/v1/runs/" + run.id + "/user",
      type: "DELETE",
      error: function (response) {
        console.log("Run disown failed with response: " + JSON.stringify(response));
      }
    });
  };
});

